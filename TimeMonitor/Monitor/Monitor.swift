//
//  Monitor.swift
//  TimeMonitor
//
//  Created by mac on 2020/11/28.
//

import UIKit

class Monitor: NSObject {
    
    static let shared = Monitor()
    
    fileprivate var viewProxys: [String : ViewProxy]  = [:]
    fileprivate var taskDispatcher =  TaskDispatcher()
    
    override init() {
        super.init()
        taskDispatcher.start()
    }
    
    func register(view: UIView) {
        addView(view: view)
    }
    
    private func addView(view: UIView) {
        let key = view.key
        defer {
            taskDispatcher.enque(task: AnalyzerTask(view: view, type: .show), after: 1)
        }
        if let _ = viewProxys[key] {
            return
        }
        let proxy = view.viewProxy
        proxy.proxyDelegate = self
        viewProxys[key] = proxy
    }
}


extension Monitor: ScrollViewProxyDelegate {
    func scrollViewClickAtIndex(indexPath: IndexPath, _ view: UIView) {
        let task = AnalyzerTask(view: view, type: .click(path: indexPath))
        taskDispatcher.enque(task: task)
    }
    
    func scrollViewShowFor(view: UIView) {
        let task = AnalyzerTask(view: view, type: .show)
        taskDispatcher.enque(task: task)
    }

}
