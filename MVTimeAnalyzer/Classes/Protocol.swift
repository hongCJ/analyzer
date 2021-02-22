//
//  Protocol.swift
//  MVTimeAnalyzer
//
//  Created by mac on 2021/1/19.
//

import UIKit

public protocol MVTimeAnalyzerAble {
    var analyzerReady: Bool { get }
    var analyzerClickEvents: [AnalyzerEvent]  {get}/// 不推荐使用这种方式，建议使用AnalyzerEventsDataSource 的方式
    var analyzerShowEvents: [AnalyzerEvent] {get}
}

public extension MVTimeAnalyzerAble {
    var analyzerReady: Bool {
        return true
    }
    var analyzerClickEvents: [AnalyzerEvent]  {
        return []
    }
    var analyzerShowEvents: [AnalyzerEvent] {
        return []
    }
}

public extension UIView {
    func tryAnalyze(delay: TimeInterval = 1.0) {
        guard let view = superview else {
            if delay > 0 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
                    self.tryAnalyze(delay: 0)
                }
            }
            return
        }
        if view is UIScrollView {
            DispatchQueue.main.async {
                MVTimeAnalyzer.shared.analyze(view: view, delay: delay)
            }
        }
    }
}
