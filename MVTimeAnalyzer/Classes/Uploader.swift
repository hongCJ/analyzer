//
//  Uploader.swift
//  MVTimeAnalyzer
//
//  Created by mac on 2021/1/19.
//

import Foundation

public protocol MVAnalyzerUploader {
    func uploadEvent(event: AnalyzerEvent)
}

