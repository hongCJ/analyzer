//
//  TestCollectionViewCell.swift
//  Analyzer
//
//  Created by 郑红 on 2020/12/10.
//  Copyright © 2020 com.zhenghong. All rights reserved.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell {
    var titleLabel: UILabel
    
    var indexPath: IndexPath?
    
    override init(frame: CGRect) {
        titleLabel = UILabel(frame: CGRect(x: 0, y: 30, width: frame.width, height: 44))
        titleLabel.textColor = .yellow
        titleLabel.font = .systemFont(ofSize: 16)
        super.init(frame: frame)
        self.backgroundColor = .blue
        self.contentView.addSubview(titleLabel)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TestCollectionViewCell: AnalyzerAbleProtocol {
    var analyzerReady: Bool {
        return true
    }

//    var analyzerClickEvents: [AnalyzerEvent] {
//        let e = AnalyzerEvent(name: "click", parameter: [
//            "click" : "eee"
//        ], time: .everyTime)
//        return [e]
//    }
//
//    var analyzerShowEvents: [AnalyzerEvent] {
//        let e = AnalyzerEvent(name: "show", parameter: [
//            "show" : "eee"
//        ], time: .everyTime)
//        return [e]
//    }


}
