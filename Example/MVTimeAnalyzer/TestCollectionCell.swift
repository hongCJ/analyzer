//
//  TestCollectionCell.swift
//  MVTimeAnalyzer_Example
//
//  Created by mac on 2021/1/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import MVTimeAnalyzer

class TestCollectionCell: UICollectionViewCell {
    
    lazy var testLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        contentView.addSubview(label)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        testLabel.frame = contentView.bounds
    }
    
    func bindData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tryAnalyze(delay: 1.0)
        }
    }
}

extension TestCollectionCell: MVTimeAnalyzerAble {
    
    var analyzerReady: Bool {
        return true
    }
}
