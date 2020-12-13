//
//  Analyzer.Provider.swift
//  Analyzer
//
//  Created by 郑红 on 2020/12/12.
//  Copyright © 2020 com.zhenghong. All rights reserved.
//

import UIKit

protocol AnalyzerEventsDataSource: NSObjectProtocol {
    func provideShowEvent(for indexPath: IndexPath) -> [AnalyzerEvent]
    func provideClickEvent(for indexPath: IndexPath) -> [AnalyzerEvent]
}

class WeakWrapper: NSObject {
    weak var source: AnalyzerEventsDataSource?
}

extension UIScrollView {
    
    var analyzerSourceKey: UnsafeRawPointer {
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
