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
    fileprivate var dispatcher =  TaskDispatcher()
    
    override init() {
        super.init()
        dispatcher.start()
    }
    
    func startCheck(view: UIView, after time: TimeInterval = 1.0) {
        if let tablecell = view as? UITableViewCell {
            if let tableView = tablecell.tableView {
                addView(view: tableView, after: time)
            } else if time > 0 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    self.startCheck(view: tablecell, after: 0)
                }
            }
            return
        }
        if let collectionCell = view as? UICollectionViewCell {
            if let collectionView = collectionCell.collectionView {
                addView(view: collectionView, after: time)
            } else if time > 0 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    self.startCheck(view: collectionCell, after: 0)
                }
            }
            return
        }
        addView(view: view, after: time)
    }
    
    
    
    private func addView(view: UIView, after time: TimeInterval = 1.0) {
        let key = view.key
        defer {
            dispatcher.enque(task: AnalyzerTask(view: view, kind: .show), after: time)
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
