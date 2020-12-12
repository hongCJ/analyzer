//
//  Analyzer.swift
//  Analyzer
//
//  Created by 郑红 on 2020/12/10.
//  Copyright © 2020 com.zhenghong. All rights reserved.
//

import UIKit

class PBNAnalyzer: NSObject {
    static let shared = PBNAnalyzer()
    
    fileprivate var viewProxys: [String : ViewProxy]  = [:]
    fileprivate var dispatcher = Dispatcher()
    fileprivate var uploadCache = AnalyzerCache()
    fileprivate var readyCache = AnalyzerCache()
    fileprivate var uploaders: [AnalyzerUploader] = []
    
    fileprivate var uploadQueue: DispatchQueue?
    
    deinit {
        dispatcher.stop()
    }
    
    override init() {
        super.init()
        dispatcher.delegate = self
        dispatcher.start()
    }
    
    func analyze(view: UIView, delay: TimeInterval = 1.0) {
        let key = view.key
        defer {
            dispatcher.enque(task: AnalyzerTask(view: view, kind: .show), after: delay)
        }
        if let _ = viewProxys[key] {
            return
        }
        let proxy = view.viewProxy
        proxy.proxyDelegate = self
        viewProxys[key] = proxy
    }
    
    func setReady(object: AnalyzerAbleProtocol) {
        object.analyzerClickEvents.forEach { (event) in
            readyCache.set(value: true, for: event.key, to: .memory)
        }
        object.analyzerShowEvents.forEach { (event) in
            readyCache.set(value: true, for: event.key, to: .memory)
        }
    }
    
    func addUploader(uploader: AnalyzerUploader) {
        uploaders.append(uploader)
    }
    
    func addQueue(queue: DispatchQueue) {
        uploadQueue = queue
    }
}


extension PBNAnalyzer: ProxyDelegate {
    func proxyViewClickAtIndex(indexPath: IndexPath, _ view: UIView) {
        let task = AnalyzerTask(view: view, kind: .click(path: indexPath))
        dispatcher.enque(task: task)
    }
    
    func proxyViewShowFor(view: UIView) {
        let task = AnalyzerTask(view: view, kind: .show)
        dispatcher.enque(task: task)
    }
    
}

extension PBNAnalyzer: TaskDispatchDelegate {
    func dispatchDidFinishTask(tasks: [AnalyzerTask], events: [AnalyzerEvent]) {
        if let queue = uploadQueue {
            queue.async {
                self.uploadEvents(events: events)
            }
        } else {
            uploadQueue = DispatchQueue(label: "analyzer_upload_queue")
            uploadQueue?.async {
                self.uploadEvents(events: events)
            }
        }
    }
    
    private func uploadEvents(events: [AnalyzerEvent]) {
       let readyEvents = events.filter {
            readyCache.get(for: $0.key, from: .memory)
        }
        let unSendEvents = readyEvents.filter { (event) -> Bool in
            switch event.time {
            case .everyTime:
                return true
            case .diskOnce:
                return !uploadCache.get(for: event.key, from: .disk)
            case .memoryOnce:
                return !uploadCache.get(for: event.key, from: .memory)
            }
        }
        unSendEvents.forEach { (event) in
            uploaders.forEach { (loader) in
                loader.uploadEvent(event: event)
                switch event.time {
                case .diskOnce:
                    uploadCache.set(value: true, for: event.key, to: .disk)
                case .memoryOnce:
                    uploadCache.set(value: true, for: event.key, to: .memory)
                case .everyTime: break
                }
            }
        }
    }
}
