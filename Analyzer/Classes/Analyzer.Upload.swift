//
//  Analyzer.Upload.swift
//  Analyzer
//
//  Created by 郑红 on 2020/12/10.
//  Copyright © 2020 com.zhenghong. All rights reserved.
//

import Foundation

class AnalyzerUploader {
    class func uploadEvent(event: AnalyzerEvent) {
        guard !AnalyzerCache.shared.checkEventSend(event: event) else {
            return
        }
        print(event.parameter)
        AnalyzerCache.shared.setEventSend(event: event, value: true)
    }
}
