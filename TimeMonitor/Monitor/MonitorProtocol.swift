//
//  MonitorProtocol.swift
//  TimeMonitor
//
//  Created by mac on 2020/11/28.
//

import UIKit

enum MonotorEventType {
    case show
    case click(section: Int, row: Int)
}

enum MonitorEventTime {
    case everyTime
    case memoryOnce
    case diskOnce
}

struct MonitorEvent {
    var category: String
    var action: String
    var label: String
    var time: MonitorEventTime
}

extension MonitorEvent {
    var key: String {
        return "m_\(category)_\(action)_\(label)"
    }
}

protocol MonitorObservable {
    var clickMonitorEvent: [MonitorEvent]  {get}
    var showMonitorEvent: [MonitorEvent] {get}
}


