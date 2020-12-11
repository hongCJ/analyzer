//
//  Analyzer.Upload.swift
//  Analyzer
//
//  Created by 郑红 on 2020/12/10.
//  Copyright © 2020 com.zhenghong. All rights reserved.
//

import Foundation

protocol AnalyzerUploader {
    static func uploadEvent(event: AnalyzerEvent)
}

