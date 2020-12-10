//
//  Analyzer.Checker.swift
//  Analyzer
//
//  Created by 郑红 on 2020/12/10.
//  Copyright © 2020 com.zhenghong. All rights reserved.
//


import UIKit

protocol CheckerProtocol {
    func startCheck(kind: AnalyzerEvent.Kind)
}

extension UIView {
    var checker: CheckerProtocol {
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



protocol ViewAnalyzerProtocol: CheckerProtocol {
    func analyzeShowEvent()
    func analyzerClickEvent(path: IndexPath)
//    func sendEvent(events: [AnalyzerEvent])
}

extension ViewAnalyzerProtocol {
    func sendEvent(events: [AnalyzerEvent]) {
        for event in events {
            AnalyzerUploader.uploadEvent(event: event)
        }
    }
    
    func startCheck(kind: AnalyzerEvent.Kind) {
        switch kind {
        case .show:
            analyzeShowEvent()
        case .click(path: let path):
            analyzerClickEvent(path: path)
        }
    }
}

struct BaseViewAnalyzer: ViewAnalyzerProtocol {
    func analyzerClickEvent(path: IndexPath) {}
    func analyzeShowEvent() {}
    weak var view: UIView?
}

struct CollectionAnalyzer: ViewAnalyzerProtocol {
    weak var collectionView: UICollectionView?
    
    func analyzerClickEvent(path: IndexPath) {
       guard let collection = collectionView else {
            return
        }
        guard let cell = collection.cellForItem(at: path) as? AnalyzerAbleProtocol else {
            return
        }
        sendEvent(events: cell.analyzerClickEvents)
    }
    
    
    
    
    func analyzeShowEvent() {
        guard let collection = collectionView else {
            return
        }
        guard collection.isVisible() else {
            return
        }
        guard let visibleCells = collection.visibleCells.filter({ $0.isVisible() })  as? [AnalyzerAbleProtocol] else {
            return
        }
        
        for cell in visibleCells {
            sendEvent(events: cell.analyzerShowEvents)
        }
        
    }

}

struct TableAnalyzer: ViewAnalyzerProtocol {
    weak var tableView: UITableView?
    
    func analyzerClickEvent(path: IndexPath) {
        guard let tableView = tableView else {
            return
        }
        guard let cell = tableView.cellForRow(at: path) as? AnalyzerAbleProtocol else {
            return
        }
        sendEvent(events: cell.analyzerClickEvents)
    }
    func analyzeShowEvent() {
        guard let tableView = tableView else {
            return
        }
        guard tableView.isVisible() else {
            return
        }
        guard let visibleCells = tableView.visibleCells.filter({ $0.isVisible() })  as? [AnalyzerAbleProtocol] else {
            return
        }
        
        for cell in visibleCells {
            sendEvent(events: cell.analyzerShowEvents)
        }
    }

}


struct ScrollViewAnalyzer: ViewAnalyzerProtocol {
    weak var scrollView: UIScrollView?
    func analyzerClickEvent(path: IndexPath) {
        
    }
    
    
    func analyzeShowEvent() {
        guard let scrollView = scrollView else {
            return
        }
        guard let observable = scrollView.subviews.filter({ $0.isVisible()}) as? [AnalyzerAbleProtocol] else {
            return
        }
        for obser in observable {
            sendEvent(events: obser.analyzerClickEvents)
        }
    }
}
