//
//  MonitorCache.swift
//  TimeMonitor
//
//  Created by mac on 2020/11/29.
//

import UIKit

class AnalyzerCache {
    static let shared = AnalyzerCache()
    
    
    private var memoryCache: [String : Bool] = [:]
    private var diskCache = UserDefaults.standard
    
    
    func checkEventSend(event: AnalyzerEvent) -> Bool {
        switch event.time {
        case .everyTime:
            return false
        case .memoryOnce:
            return memoryCache[event.key] ?? false
        case .diskOnce:
            return diskCache.bool(forKey: event.key)
        }
    }
    
    func setEventSend(event: AnalyzerEvent, value: Bool) {
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
