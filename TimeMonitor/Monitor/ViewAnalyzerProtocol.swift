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

extension UIView {
    var analyzer: AnalyzerProtocol {
        if let collection = self as? UICollectionView {
            return CollectionAnalyzer(collectionView: collection)
        }
        if let table = self as? UITableView {
            return TableAnalyzer(tableView: table)
        }
        if let scrollView = self as? UIScrollView {
            return ScrollViewAnalyzer(scrollView: scrollView)
        }
        return BaseViewAnalyzer(view: self)
    }
}



protocol ViewAnalyzerProtocol: AnalyzerProtocol {
    func analyzeShowEvent()
    func analyzerClickEvent(section: Int, row: Int)
    func sendEvent(events: [AnalyzerEvent])
}

extension ViewAnalyzerProtocol {
    func sendEvent(events: [AnalyzerEvent]) {
        for event in events {
            AnalyzerUploader.uploadEvent(event: event)
        }
    }
    
    func startAnalyze(type: AnalyzerEventType) {
        switch type {
        case .show:
            analyzeShowEvent()
        case .click(path: let path):
            analyzerClickEvent(section: path.section, row: path.row)
        }
    }
}

struct BaseViewAnalyzer: ViewAnalyzerProtocol {
    func analyzeShowEvent() {}
    
    func analyzerClickEvent(section: Int, row: Int) {}
    
    weak var view: UIView?
}

struct CollectionAnalyzer: ViewAnalyzerProtocol {
    
    weak var collectionView: UICollectionView?
    
    func analyzeShowEvent() {
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
    
    func analyzerClickEvent(section: Int, row: Int) {
        guard let collection = collectionView else {
            return
        }
        guard let cell = collection.cellForItem(at: IndexPath(row: row, section: section)) as? MonitorObservable else {
            return
        }
        sendEvent(events: cell.clickMonitorEvent)
    }
    
}

struct TableAnalyzer: ViewAnalyzerProtocol {
    weak var tableView: UITableView?
    func analyzeShowEvent() {
        guard let tableView = tableView else {
            return
        }
        guard tableView.isVisible() else {
            return
        }
        guard let visibleCells = tableView.visibleCells.filter({ $0.isVisible() })  as? [MonitorObservable] else {
            return
        }
        
        for cell in visibleCells {
            sendEvent(events: cell.showMonitorEvent)
        }
    }
    
    func analyzerClickEvent(section: Int, row: Int) {
        guard let tableView = tableView else {
            return
        }
        guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? MonitorObservable else {
            return
        }
        sendEvent(events: cell.clickMonitorEvent)
    }
}


struct ScrollViewAnalyzer: ViewAnalyzerProtocol {
    weak var scrollView: UIScrollView?
    func analyzeShowEvent() {
        guard let scrollView = scrollView else {
            return
        }
        guard let observable = scrollView.subviews.filter({ $0.isVisible()}) as? [MonitorObservable] else {
            return
        }
        for obser in observable {
            sendEvent(events: obser.showMonitorEvent)
        }
    }
    
    func analyzerClickEvent(section: Int, row: Int) {
        
    }
}
