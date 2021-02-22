//
//  Provider.swift
//  MVTimeAnalyzer
//
//  Created by mac on 2021/1/19.
//


import UIKit

public protocol AnalyzerEventsDataSource: NSObjectProtocol {
    func provideShowEvent(for indexPath: IndexPath) -> [AnalyzerEvent]
    func provideClickEvent(for indexPath: IndexPath) -> [AnalyzerEvent]
}

public extension AnalyzerEventsDataSource {
    func provideShowEvent(for indexPath: IndexPath) -> [AnalyzerEvent] {
        return []
    }
    func provideClickEvent(for indexPath: IndexPath) -> [AnalyzerEvent] {
        return []
    }
}

class WeakWrapper: NSObject {
    weak var source: AnalyzerEventsDataSource?
}

public extension UIScrollView {
    
    private var analyzerSourceKey: UnsafeRawPointer {
        return UnsafeRawPointer(bitPattern: "analyzer_data_source".hashValue)!
    }
    
    var analyzerDataSource: AnalyzerEventsDataSource? {
        get {
            guard let wrapper = objc_getAssociatedObject(self, analyzerSourceKey) as? WeakWrapper else {
                return nil
            }
            return wrapper.source
        }
        set {
            if let wrapper = objc_getAssociatedObject(self, analyzerSourceKey) as? WeakWrapper {
                wrapper.source = newValue
            } else {
                let wrapper = WeakWrapper()
                wrapper.source = newValue
                objc_setAssociatedObject(self, analyzerSourceKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

