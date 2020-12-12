//
//  Analyzer.Task.swift
//  Analyzer
//
//  Created by 郑红 on 2020/12/10.
//  Copyright © 2020 com.zhenghong. All rights reserved.
//

import UIKit

struct AnalyzerTask {
    var view: UIView
    var kind: AnalyzerEvent.Kind
}

extension AnalyzerTask {
    func dispatch() -> [AnalyzerEvent] {
        return view.checker.startCheck(kind: kind)
    }
}

