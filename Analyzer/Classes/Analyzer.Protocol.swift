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
    var analyzerReady: Bool { get set}
}

extension AnalyzerAbleProtocol where Self: UITableViewCell {
    func readyAnalyze(delay: TimeInterval = 1.0) {
        if let table = tableView {
            PBNAnalyzer.shared.setReady(object: self)
            PBNAnalyzer.shared.analyze(view: table, delay: delay)
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
            PBNAnalyzer.shared.setReady(object: self)
            PBNAnalyzer.shared.analyze(view: table, delay: delay)
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
        PBNAnalyzer.shared.setReady(object: self)
        PBNAnalyzer.shared.analyze(view: scrollView, delay: delay)
    }
}


