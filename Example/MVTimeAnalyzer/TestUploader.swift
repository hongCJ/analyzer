//
//  TestUploader.swift
//  MVTimeAnalyzer_Example
//
//  Created by mac on 2021/1/29.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import MVTimeAnalyzer

struct MyUploader {}

extension MyUploader: MVAnalyzerUploader {
    func uploadEvent(event: AnalyzerEvent) {
        print("\(event.name)_\(event.parameter)")
    }
}
