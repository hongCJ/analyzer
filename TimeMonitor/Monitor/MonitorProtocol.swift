//
//  MonitorProtocol.swift
//  TimeMonitor
//
//  Created by mac on 2020/11/28.
//

import UIKit

enum MonotorEventType {
    case show
    case click
}

struct MonitorEvent {
    var type: MonotorEventType
    var category: String
    var action: String
    var label: String
}

protocol MonitorObservable {
    var monitorEvents: [MonitorEvent] {get}
    var isMonitorAble: Bool { get }
}

