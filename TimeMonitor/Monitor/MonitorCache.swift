//
//  MonitorCache.swift
//  TimeMonitor
//
//  Created by mac on 2020/11/29.
//

import UIKit


class AnalyzerCache: NSObject {
    private var memoryCache: [String : Bool] = [:]
    private var diskCache = UserDefaults.standard
    
     static let shared = AnalyzerCache()
    
    func checkEventSend(event: MonitorEvent) -> Bool {
        switch event.time {
        case .everyTime:
            return false
        case .memoryOnce:
            return memoryCache[event.key] ?? false
        case .diskOnce:
            return diskCache.bool(forKey: event.key)
        }
    }
    
    func setEventSend(event: MonitorEvent, value: Bool) {
        switch event.time {
        case .everyTime:
            return
        case .memoryOnce:
            memoryCache[event.key] = true
        case .diskOnce:
            diskCache.setValue(value, forKey: event.key)
        }
    }
}
