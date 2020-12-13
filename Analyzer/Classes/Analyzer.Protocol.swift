//
//  Analyzer.Protocol.swift
//  Analyzer
//
//  Created by 郑红 on 2020/12/12.
//  Copyright © 2020 com.zhenghong. All rights reserved.
//

import UIKit

protocol AnalyzerAbleProtocol {
    var analyzerReady: Bool { get }
    var analyzerClickEvents: [AnalyzerEvent]  {get}
    var analyzerShowEvents: [AnalyzerEvent] {get}
}

extension AnalyzerAbleProtocol {
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

extension UIView {
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
            PBNAnalyzer.shared.analyze(view: view, delay: delay)
        }
//        if !PBNAnalyzer.shared.strictMode {
//            return
//        }
//        
//        if let collection = view as?  UICollectionView {
////            let cell = collection.indexPath(for: <#T##UICollectionViewCell#>)
//        }
    }
}
