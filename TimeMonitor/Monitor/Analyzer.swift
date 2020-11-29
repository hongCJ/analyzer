//
//  CollectionViewMonitor.swift
//  TimeMonitor
//
//  Created by mac on 2020/11/28.
//

import UIKit


class BaseMonitor<BaseView: UIView> {
    weak var baseView: BaseView?
    var analyzer:  Analyzer
    init(analyzer:   Analyzer) {
        self.analyzer  = analyzer
    }
    func start(type: MonotorEventType) {
        guard let v = self.baseView else {
            return
        }
        switch type {
        case .show:
            analyzer.analyzerShow(view: v)
        case .click(index: let index):
            analyzer.analyzerClick(view: v, section: index.section, row: index.row)
        }
    }
}


protocol Analyzer {
    func analyzerShow(view: UIView)
    func analyzerClick(view: UIView, section: Int, row: Int)
    
    func sendEvent(events: [MonitorEvent])
}

extension Analyzer {
    func sendEvent(events: [MonitorEvent]) {
        for event in events {
            print(event.key)
        }
    }
}

struct CollectionAnalyzer: Analyzer {
    func analyzerShow(view: UIView) {
        guard let collection = view as?  UICollectionView else {
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
    
    func analyzerClick(view: UIView,section: Int, row: Int) {
        guard let collection = view as?  UICollectionView else {
            return
        }
        guard let cell = collection.cellForItem(at: IndexPath(row: row, section: section)) as? MonitorObservable else {
            return
        }
        
        sendEvent(events: cell.clickMonitorEvent)
        
    }
    
}

struct TableAnalyzer: Analyzer {
    func analyzerShow(view: UIView) {
        print("tablle show")
    }
    
    func analyzerClick(view: UIView, section: Int, row: Int) {
        print("tablle click at \(section) \(row)")
    }
}
