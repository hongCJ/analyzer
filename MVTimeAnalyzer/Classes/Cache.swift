//
//  Cache.swift
//  MVTimeAnalyzer
//
//  Created by mac on 2021/1/19.
//

import Foundation

class AnalyzerCache {
    enum CacheType {
        case memory
        case disk
    }
    
    private var memoryCache: [String : Bool] = [:]
    private var diskCache = UserDefaults.standard
    
    
    func set(value: Bool, for key: String, to type: CacheType) {
        guard !key.isEmpty else {
            return
        }
        switch type {
        case .disk:
            diskCache.setValue(value, forKey: key)
        case .memory:
            memoryCache[key] = value
        }
    }
    
    func get(for key: String, from type: CacheType) -> Bool {
        guard !key.isEmpty else {
            return false
        }
        switch type {
        case .disk:
            return diskCache.bool(forKey: key)
        case .memory:
            return memoryCache[key] ?? false
        }
    }
}
