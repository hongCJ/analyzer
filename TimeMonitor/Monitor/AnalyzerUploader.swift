//
//  MonitorEventUploader.swift
//  TimeMonitor
//
//  Created by mac on 2020/12/10.
//

import UIKit

class AnalyzerUploader {
    class func uploadEvent(event: AnalyzerEvent) {
        guard !AnalyzerCache.shared.checkEventSend(event: event) else {
            return
        }
        print(event.parameter)
        AnalyzerCache.shared.setEventSend(event: event, value: true)
    }
}
