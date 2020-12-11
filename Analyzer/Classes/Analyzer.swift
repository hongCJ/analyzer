//
//  Analyzer.swift
//  Analyzer
//
//  Created by 郑红 on 2020/12/10.
//  Copyright © 2020 com.zhenghong. All rights reserved.
//

import UIKit

class Analyzer: NSObject {
    static let shared = Analyzer()
    
    fileprivate var viewProxys: [String : ViewProxy]  = [:]
    fileprivate var dispatcher = TaskDispatcher()
    fileprivate var uploadCache = AnalyzerCache()
    fileprivate var readyCache = AnalyzerCache()
    fileprivate var uploader: [AnalyzerUploader] = []
    deinit {
        dispatcher.stop()
    }
    
    override init() {
        super.init()
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
}


extension Analyzer: ProxyDelegate {
    func proxyViewClickAtIndex(indexPath: IndexPath, _ view: UIView) {
        let task = AnalyzerTask(view: view, kind: .click(path: indexPath))
        dispatcher.enque(task: task)
    }
    
    func proxyViewShowFor(view: UIView) {
        let task = AnalyzerTask(view: view, kind: .show)
        dispatcher.enque(task: task)
    }
    
}
