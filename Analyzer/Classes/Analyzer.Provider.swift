//
//  Analyzer.Provider.swift
//  Analyzer
//
//  Created by 郑红 on 2020/12/12.
//  Copyright © 2020 com.zhenghong. All rights reserved.
//

import UIKit

protocol AnalyzerEventsDataSource {
    func provideShowEvents(for indexPaths: [IndexPath]) -> [AnalyzerEvent]
    func provideClickEvents(for indexPaths: [IndexPath]) -> [AnalyzerEvent]
}


protocol AnalyzerEventsProvider {
    func provideAnalyzerDataSource() -> AnalyzerEventsDataSource?
}

extension AnalyzerEventsProvider {
    func provideAnalyzerDataSource() -> AnalyzerEventsDataSource? {
        return nil
    }
}



extension NSObject: AnalyzerEventsProvider {}

