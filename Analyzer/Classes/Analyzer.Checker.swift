//
//  Analyzer.Checker.swift
//  Analyzer
//
//  Created by 郑红 on 2020/12/10.
//  Copyright © 2020 com.zhenghong. All rights reserved.
//


import UIKit

protocol CheckerProtocol {
    func startCheck(kind: AnalyzerEvent.Kind) -> [AnalyzerEvent]
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
    func analyzeShowEvent() -> [AnalyzerEvent]
    func analyzerClickEvent(path: IndexPath) -> [AnalyzerEvent]
    func analyzerClickEvent(location: CGPoint) -> [AnalyzerEvent]
}

extension ViewAnalyzerProtocol {
    func startCheck(kind: AnalyzerEvent.Kind) -> [AnalyzerEvent] {
        switch kind {
        case .show:
            return analyzeShowEvent()
        case .click(path: let click):
            switch click {
            case .indexPath(path: let path):
                return analyzerClickEvent(path: path)
            case .location(location: let location):
                return analyzerClickEvent(location: location)
            }
        }
    }
    func analyzeShowEvent() -> [AnalyzerEvent] {
        return []
    }
    func analyzerClickEvent(path: IndexPath) -> [AnalyzerEvent] {
        return []
    }
    func analyzerClickEvent(location: CGPoint) -> [AnalyzerEvent] {
        return []
    }
}

struct BaseViewAnalyzer: ViewAnalyzerProtocol {
    weak var view: UIView?
}

struct CollectionAnalyzer: ViewAnalyzerProtocol {
    weak var collectionView: UICollectionView?
    
    func analyzerClickEvent(path: IndexPath) -> [AnalyzerEvent] {
      guard let collection = collectionView else {
            return []
        }
        guard let cell = collection.cellForItem(at: path) as? AnalyzerAbleProtocol else {
            return []
        }
        return cell.analyzerClickEvents
    }

    func analyzeShowEvent() -> [AnalyzerEvent] {
        guard let collection = collectionView else {
            return []
        }
        guard collection.isVisible() else {
            return []
        }
        let visibleCells = collection.visibleCells.filter({ $0.isVisible() })
        
        let observable = visibleCells.compactMap {
            $0 as? AnalyzerAbleProtocol
        }
        return observable.flatMap {
            $0.analyzerShowEvents
        }
    }

}

struct TableAnalyzer: ViewAnalyzerProtocol {
    weak var tableView: UITableView?
    
    func analyzerClickEvent(path: IndexPath) -> [AnalyzerEvent] {
        guard let tableView = tableView else {
            return []
        }
        guard let cell = tableView.cellForRow(at: path) as? AnalyzerAbleProtocol else {
            return []
        }
        return cell.analyzerClickEvents
    }
    func analyzeShowEvent() -> [AnalyzerEvent]{
        guard let tableView = tableView else {
            return []
        }
        guard tableView.isVisible() else {
            return []
        }
        let visibleCells = tableView.visibleCells.filter({ $0.isVisible() })
        
        let observable = visibleCells.compactMap {
            $0 as? AnalyzerAbleProtocol
        }
        return observable.flatMap {
            $0.analyzerShowEvents
        }
    }

}


struct ScrollViewAnalyzer: ViewAnalyzerProtocol {
    weak var scrollView: UIScrollView?
    func analyzerClickEvent(location: CGPoint) -> [AnalyzerEvent] {
        guard let scrollView = scrollView else {
            return []
        }
        guard scrollView.isVisible() else {
            return []
        }
        let visibleViews = scrollView.subviews.filter {
            $0.isVisible() && $0.frame.contains(location)
        }
        let observable = visibleViews.compactMap {
            $0 as? AnalyzerAbleProtocol
        }
        return observable.flatMap {
            $0.analyzerClickEvents
        }
    }
    
    func analyzeShowEvent() -> [AnalyzerEvent]{
        guard let scrollView = scrollView else {
            return []
        }
        let visibleViews = scrollView.subviews.filter({ $0.isVisible()})
        let observable = visibleViews.compactMap {
            $0 as? AnalyzerAbleProtocol
        }
        return observable.flatMap {
            $0.analyzerShowEvents
        }
    }
}
