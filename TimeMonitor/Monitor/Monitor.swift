//
//  Monitor.swift
//  TimeMonitor
//
//  Created by mac on 2020/11/28.
//

import UIKit


struct MonitorObject {
    var monitor: BaseMonitor<UIView>
    var proxy: ScrollViewProxy
}

class Monitor: NSObject {
    static let shared = Monitor()
    fileprivate var runLoopObserver: CFRunLoopObserver!
    fileprivate var moniterViews: [String : MonitorObject]  = [:]
    fileprivate var moniterActions: [MonitorAction] = []
    override init() {
        super.init()
        addRunLoopObserver()
    }
    
    private func addRunLoopObserver() {
        let info = Unmanaged<Monitor>.passUnretained(self).toOpaque()
        var context = CFRunLoopObserverContext(version: 0, info: info, retain: nil, release: nil, copyDescription: nil)
        runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, CFRunLoopActivity.beforeWaiting.rawValue, true, 0, runLoopObserverCallBack(), &context)
        CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, CFRunLoopMode.defaultMode)
    }

    private func runLoopObserverCallBack() -> CFRunLoopObserverCallBack {
        return { observer, activity, info in
            guard let context = info else {
                return
            }
            let weakSelf = Unmanaged<Monitor>.fromOpaque(context).takeUnretainedValue()
            weakSelf.fireAction()
        }
    }
    
    private func fireAction() {
        guard !moniterActions.isEmpty else {
            return
        }
        
        let copyActions = moniterActions[0...];
        moniterActions.removeAll()
        var cached: [String : Bool] = [:]
        for action in copyActions {
            if let _ = cached[action.key] {
                continue
            }
            cached[action.key] = true
            if let view = self.moniterViews[action.key] {
                view.monitor.start(type: action.type)
            }
        }
    }
    
    
    func register(cell: UITableViewCell) {
        guard let tableView = cell.tableView else {
            return
        }
        let key = tableView.key
        defer {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.moniterActions.append(MonitorAction(key: key, type: .show))
            }
        }
       
        guard !moniterViews.keys.contains(key) else {
            return
        }
        
        let tableViewProxy = TableDelegateProxy(proxy: tableView.delegate)
        tableView.delegate = tableViewProxy
        let analyzer = TableAnalyzer()
        addAnalyzer(analyzer: analyzer, for: tableView, proxy: tableViewProxy)
    }
    
    
    func register(cell: UICollectionViewCell) {
        guard let collectionView = cell.collectionView else {
            return
        }
        let key = collectionView.key
        defer {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.moniterActions.append(MonitorAction(key: key, type: .show))
            }
        }
       
        guard !moniterViews.keys.contains(key) else {
            return
        }
        
        let collectionProxy = CollectionDelegateProxy(proxy: collectionView.delegate)
        collectionView.delegate = collectionProxy
        let analyzer = CollectionAnalyzer()
        addAnalyzer(analyzer: analyzer, for: collectionView, proxy: collectionProxy)
    }
    
    private func addAnalyzer(analyzer: Analyzer, for view: UIScrollView, proxy: ScrollViewProxy) {
        let monitor = BaseMonitor(analyzer: analyzer)
        monitor.baseView = view
        let observer = MonitorObject(monitor: monitor, proxy: proxy)
        proxy.proxyDelegate = self
        moniterViews[view.key] = observer
    
    }
}


extension Monitor: ScrollViewProxyDelegate {
    func scrollViewClickAtIndex(indexPath: IndexPath, viewKey key: String) {
        let action = MonitorAction(key: key, type: .click(section: indexPath.section, row: indexPath.row))
        moniterActions.append(action)
    }
    
    func scrollViewShowFor(viewKey key: String) {
        let action = MonitorAction(key: key, type: .show)
        moniterActions.append(action)
    }
}
