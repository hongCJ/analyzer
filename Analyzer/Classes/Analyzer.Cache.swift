//
//  Analyzer.Cache.swift
//  Analyzer
//
//  Created by 郑红 on 2020/12/10.
//  Copyright © 2020 com.zhenghong. All rights reserved.
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


