//
//  Analyzer.Event.swift
//  Analyzer
//
//  Created by 郑红 on 2020/12/10.
//  Copyright © 2020 com.zhenghong. All rights reserved.
//

import UIKit


enum AnalyzerEventTime {
    case everyTime
    case memoryOnce
    case diskOnce
}


struct AnalyzerEvent {
    var name: String
    var parameter: [String : String]
    var time: AnalyzerEventTime
    
    enum Kind {
        case show
        case click(path: IndexPath)
    }
}

extension AnalyzerEvent {
    var key: String {
        return "k_\(name.hash)_\(parameter.hashValue)"
    }
}

protocol AnalyzerAbleProtocol {
    var analyzerClickEvents: [AnalyzerEvent]  {get}
    var analyzerShowEvents: [AnalyzerEvent] {get}
}


