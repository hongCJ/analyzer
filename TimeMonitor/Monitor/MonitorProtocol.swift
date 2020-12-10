//
//  MonitorProtocol.swift
//  TimeMonitor
//
//  Created by mac on 2020/11/28.
//

import UIKit

enum AnalyzerEventType {
    case show
    case click(path: IndexPath)
}

enum AnalyzerEventTime {
    case everyTime
    case memoryOnce
    case diskOnce
}


struct AnalyzerEvent {
    var name: String
    var parameter: [String : String]
    var time: AnalyzerEventTime
}

extension AnalyzerEvent {
    var key: String {
        return "k_\(name.hash)_\(parameter.hashValue)"
    }
}

protocol MonitorObservable {
    var clickMonitorEvent: [AnalyzerEvent]  {get}
    var showMonitorEvent: [AnalyzerEvent] {get}
}


