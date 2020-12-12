//
//  Analyzer.Event.swift
//  Analyzer
//
//  Created by 郑红 on 2020/12/10.
//  Copyright © 2020 com.zhenghong. All rights reserved.
//

import UIKit


struct AnalyzerEvent {
    var name: String
    var parameter: [String : String]
    var time: Time
    
    var identifier: String = ""
    
    enum Time {
        case everyTime
        case memoryOnce
        case diskOnce
    }
    enum Click {
        case location(location: CGPoint)
        case indexPath(path: IndexPath)
    }
    enum Kind {
        case show
        case click(path: Click)
    }
}

extension AnalyzerEvent {
    var key: String {
        if identifier.isEmpty {
            let strings = parameter.map { (k, v) -> String in
                return "\(k)_\(v)"
                }.sorted().joined(separator: "&")
            let key = "\(name)_\(strings)"
            return key.md5
        }
        return identifier
    }
}

