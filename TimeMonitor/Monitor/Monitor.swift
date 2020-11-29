//
//  Monitor.swift
//  TimeMonitor
//
//  Created by mac on 2020/11/28.
//

import UIKit


protocol Analyzer {
    func analyze(view: UIView)
}

struct CollectionAnalyzer: Analyzer {
    func analyze(view: UIView) {
        print("analyze collection")
    }
}

struct TableAnalyzer: Analyzer {
    func analyze(view: UIView) {
        print("analyze table")
    }
}



class BaseMonitor<BaseView: UIView> {
    weak var baseView: BaseView?
    
    var analyzer:  Analyzer
    init(analyzer:   Analyzer) {
        self.analyzer  = analyzer
    }
    func start() {
        guard let v = self.baseView else {
            return
        }
        self.analyzer.analyze(view: v)
    }
}

struct MonitorObject {
    var monitor: BaseMonitor<UIView>
    var proxy: ScrollViewProxy
}


class Monitor: NSObject {
    static let shared = Monitor()
    
    
    
    fileprivate var runLoopObserver: CFRunLoopObserver!
    fileprivate var moniterViews: [String : MonitorObject]  = [:]
    
    
    
    
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
//            guard let context = info else {
//                return
//            }
//            let weakSelf = Unmanaged<Monitor>.fromOpaque(context).takeUnretainedValue()
//            print("done");
        }
    }
    
    
    func register(cell: UITableViewCell) {
        guard let tableView = cell.tableView else {
            return
        }
        let key = tableView.key
        guard !moniterViews.keys.contains(key) else {
            return
        }
        
        let tableViewProxy = TableDelegateProxy(proxy: tableView.delegate)
        tableView.delegate = tableViewProxy
        let analyzer = CollectionAnalyzer()
        addAnalyzer(analyzer: analyzer, for: tableView, proxy: tableViewProxy)
    }
    
    
    func register(cell: UICollectionViewCell) {
        guard let collectionView = cell.collectionView else {
            return
        }
        let key = collectionView.key
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
        moniterViews[view.key] = observer
  
    }
}
