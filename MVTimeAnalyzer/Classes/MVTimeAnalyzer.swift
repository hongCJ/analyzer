//
//  MVTimeAnalyzer.swift
//  MVTimeAnalyzer
//
//  Created by mac on 2021/1/19.
//

import UIKit

public final class MVTimeAnalyzer: NSObject {
    public static let shared = MVTimeAnalyzer()
    
    fileprivate var viewProxys: [String : ViewProxy]  = [:]
    fileprivate var dispatcher = Dispatcher()
    fileprivate var uploadCache = AnalyzerCache()
    fileprivate var uploaders: [MVAnalyzerUploader] = []
    
    fileprivate var uploadQueue: DispatchQueue?
    
    private var timeCache: [String : TimeInterval] = [:]
    
    var strictMode = false
    
    override init() {
        super.init()
        dispatcher.delegate = self
    }
    
    func addBeginTime(eventKey: String) {
        if let _ = timeCache[eventKey] {
            return
        }
        timeCache[eventKey] = Date.timeIntervalSinceReferenceDate
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
    
    public func addUploader(uploader: MVAnalyzerUploader) {
        uploaders.append(uploader)
    }
    
    func addQueue(queue: DispatchQueue) {
        uploadQueue = queue
    }
}


extension MVTimeAnalyzer: ProxyDelegate {
    func proxyViewClickAtIndex(indexPath: IndexPath, _ view: UIView) {
        let task = AnalyzerTask(view: view, kind: .click(path: .indexPath(path: indexPath)))
        dispatcher.enque(task: task)
    }
    
    func proxyViewShowFor(view: UIView) {
        let task = AnalyzerTask(view: view, kind: .show)
        dispatcher.enque(task: task)
    }
    func proxyViewClickAtLocation(location: CGPoint, _ view: UIView) {
        let task = AnalyzerTask(view: view, kind: .click(path: .location(location: location)))
        dispatcher.enque(task: task)
    }
    
}

extension MVTimeAnalyzer: TaskDispatchDelegate {
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
        let unSendEvents = events.filter { (event) -> Bool in
            switch event.time {
            case .everyTime:
                return true
            case .diskOnce:
                return !uploadCache.get(for: event.key, from: .disk)
            case .memoryOnce:
                return !uploadCache.get(for: event.key, from: .memory)
            }
        }
        let now = Date.timeIntervalSinceReferenceDate
        let events = !strictMode ? unSendEvents : unSendEvents.filter({ (event) -> Bool in
            guard let t = timeCache[event.key] else {
                return false
            }
            return (now - t) > 0.8
        })
        events.forEach { (event) in
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

