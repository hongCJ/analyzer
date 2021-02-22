//
//  Event.swift
//  MVTimeAnalyzer
//
//  Created by mac on 2021/1/19.
//


import UIKit


public struct AnalyzerEvent {
    public var name: String
    public var parameter: [String : String]
    public var time: Time
    
    public var identifier: String = ""
    
    public init(name: String, parameter: [String : String], time: Time) {
        self.name = name
        self.parameter = parameter
        self.time = time
    }
    
    public enum Time {
        case everyTime
        case memoryOnce
        case diskOnce
    }
    public enum Click {
        case location(location: CGPoint)
        case indexPath(path: IndexPath)
    }
    public enum Kind {
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


