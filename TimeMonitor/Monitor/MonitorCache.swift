//
//  MonitorCache.swift
//  TimeMonitor
//
//  Created by mac on 2020/11/29.
//

import UIKit

class MonitorCache: NSObject {

    
    func checkCache(key: String, type: MonitorEventTime) -> Bool {
        if type == .everyTime {
            return true
        }
        if type == .memoryOnce {
            
        }
        if type == .diskOnce {
            
        }
        return false
    }
}
