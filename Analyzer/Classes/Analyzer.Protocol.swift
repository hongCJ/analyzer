//
//  Analyzer.Protocol.swift
//  Analyzer
//
//  Created by 郑红 on 2020/12/12.
//  Copyright © 2020 com.zhenghong. All rights reserved.
//

import UIKit

protocol AnalyzerAbleProtocol {
    var analyzerClickEvents: [AnalyzerEvent]  {get}
    var analyzerShowEvents: [AnalyzerEvent] {get}
}

extension AnalyzerAbleProtocol {
    func setReady() {
        for event in analyzerShowEvents {
            BaseCache.shared.setEventReady(event: event)
        }
        for event in analyzerClickEvents {
            BaseCache.shared.setEventReady(event: event)
        }
    }
}

extension AnalyzerAbleProtocol where Self: UITableViewCell {
    func readyAnalyze(delay: TimeInterval = 1.0) {
        if let table = tableView {
            setReady()
            Analyzer.shared.analyze(view: table, delay: delay)
            return
        }
        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
                self.readyAnalyze(delay: 0)
            }
        }
    }
}

extension AnalyzerAbleProtocol where Self: UICollectionViewCell {
    func readyAnalyze(delay: TimeInterval = 1.0) {
        if let table = collectionView {
            setReady()
            Analyzer.shared.analyze(view: table, delay: delay)
            return
        }
        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
                self.readyAnalyze(delay: 0)
            }
        }
    }
}

extension AnalyzerAbleProtocol where Self: UIView {
    func tryAnalyze(delay: TimeInterval = 1.0) {
        guard let view = superview else { return }
        guard let scrollView = view as? UIScrollView else { return }
        setReady()
        Analyzer.shared.analyze(view: scrollView, delay: delay)
    }
}

