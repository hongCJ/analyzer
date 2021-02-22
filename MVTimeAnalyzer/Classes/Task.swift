//
//  Task.swift
//  MVTimeAnalyzer
//
//  Created by mac on 2021/1/19.
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


