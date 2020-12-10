//
//  CollectionViewMonitor.swift
//  TimeMonitor
//
//  Created by mac on 2020/11/28.
//

import UIKit


protocol AnalyzerProtocol {
    func startAnalyze(type: AnalyzerEventType)
}

class BaseAnalyzer {
    class func analyzer(for view: UIView) -> AnalyzerProtocol {
        if let collection = view as? UICollectionView {
            return CollectionAnalyzer(collectionView: collection)
        }
        if let table = view as? UITableView {
            return TableAnalyzer(tableView: table)
        }
        if let scrollView = view as? UIScrollView {
            return ScrollViewAnalyzer(scrollView: scrollView)
        }
        
        return ViewAnalyzer(view: view)
    }
}


protocol ViewAnalyzer: AnalyzerProtocol {
    func analyzerShow()
    func analyzerClick(section: Int, row: Int)
    func sendEvent(events: [AnalyzerEvent])
}

extension ViewAnalyzer {
    func sendEvent(events: [AnalyzerEvent]) {
        for event in events {
            AnalyzerUploader.uploadEvent(event: event)
        }
    }
    
    func startAnalyze(type: AnalyzerEventType) {
        switch type {
        case .show:
            analyzerShow()
        case .click(section: let section, row: let row):
            analyzerClick(section: section, row: row)
        }
    }
}

struct ViewAnalyzer: ViewAnalyzer {
    func analyzerShow() {
        
    }
    
    func analyzerClick(section: Int, row: Int) {
        
    }
    
    weak var view: UIView?
}

struct CollectionAnalyzer: ViewAnalyzer {
    
    weak var collectionView: UICollectionView?
    
    func analyzerShow() {
        guard let collection = collectionView else {
            return
        }
        guard collection.isVisible() else {
            return
        }
        guard let visibleCells = collection.visibleCells.filter({ $0.isVisible() })  as? [MonitorObservable] else {
            return
        }
        
        for cell in visibleCells {
            sendEvent(events: cell.showMonitorEvent)
        }
        
    }
    
    func analyzerClick(section: Int, row: Int) {
        guard let collection = collectionView else {
            return
        }
        guard let cell = collection.cellForItem(at: IndexPath(row: row, section: section)) as? MonitorObservable else {
            return
        }
        sendEvent(events: cell.clickMonitorEvent)
    }
    
}

struct TableAnalyzer: ViewAnalyzer {
    weak var tableView: UITableView?
    func analyzerShow() {
        print("tablle show")
    }
    
    func analyzerClick(section: Int, row: Int) {
        print("tablle click at \(section) \(row)")
    }
}


struct ScrollViewAnalyzer: ViewAnalyzer {
    weak var scrollView: UIScrollView?
    func analyzerShow() {
        print("tablle show")
    }
    
    func analyzerClick(section: Int, row: Int) {
        print("tablle click at \(section) \(row)")
    }
}
