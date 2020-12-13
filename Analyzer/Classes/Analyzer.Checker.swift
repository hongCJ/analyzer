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
        if let source = collection.analyzerDataSource {
            let events = source.provideClickEvent(for: path)
            if !events.isEmpty {
                return events
            }
        }
        guard let cell = collection.cellForItem(at: path) else {
            return []
        }
        guard let observable = cell as? AnalyzerAbleProtocol else {
            return []
        }
        return observable.analyzerClickEvents
    }
    
    func analyzeShowEvent() -> [AnalyzerEvent] {
        guard let collection = collectionView else {
            return []
        }
        guard collection.isVisible() else {
            return []
        }
        let visibleIndexPath = collection.indexPathsForVisibleItems
        if visibleIndexPath.isEmpty {
            return []
        }
        let provider = collection.analyzerDataSource
        var result: [AnalyzerEvent] = []
        for indexpath in visibleIndexPath {
            guard let cell = collection.cellForItem(at: indexpath), cell.isVisible() else {
                continue
            }
            guard let obserable = cell as? AnalyzerAbleProtocol, obserable.analyzerReady else {
                continue
            }
            if let source = provider {
                let events = source.provideShowEvent(for: indexpath)
                if !events.isEmpty {
                    result.append(contentsOf: events)
                    continue
                }
            }
            result.append(contentsOf: obserable.analyzerShowEvents)
        }
        
        return result
    }
    
}

struct TableAnalyzer: ViewAnalyzerProtocol {
    weak var tableView: UITableView?
    
    func analyzerClickEvent(path: IndexPath) -> [AnalyzerEvent] {
       guard let table = tableView else {
            return []
        }
        if let source = table.analyzerDataSource {
            let events = source.provideClickEvent(for: path)
            if !events.isEmpty {
                return events
            }
        }
        guard let cell = table.cellForRow(at: path) else {
            return []
        }
        guard let observable = cell as? AnalyzerAbleProtocol else {
            return []
        }
        return observable.analyzerClickEvents
    }
    func analyzeShowEvent() -> [AnalyzerEvent]{
        guard let table = tableView else {
            return []
        }
        guard table.isVisible() else {
            return []
        }
        let visibleIndexPath = table.indexPathsForVisibleRows ?? []
        if visibleIndexPath.isEmpty {
            return []
        }
        let provider = table.analyzerDataSource
        var result: [AnalyzerEvent] = []
        for indexpath in visibleIndexPath {
            guard let cell = table.cellForRow(at: indexpath), cell.isVisible() else {
                continue
            }
            guard let obserable = cell as? AnalyzerAbleProtocol, obserable.analyzerReady else {
                continue
            }
            if let source = provider {
                let events = source.provideShowEvent(for: indexpath)
                if !events.isEmpty {
                    result.append(contentsOf: events)
                    continue
                }
            }
            result.append(contentsOf: obserable.analyzerShowEvents)
        }
        
        return result
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
