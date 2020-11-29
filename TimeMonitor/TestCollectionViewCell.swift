//
//  TestCollectionViewCell.swift
//  TimeMonitor
//
//  Created by mac on 2020/11/28.
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

extension TestCollectionViewCell: MonitorObservable {
    var monitorEvents: [MonitorEvent] {
        guard let path = indexPath else {
            return []
        }
        let e = MonitorEvent(type: .show, category: "shhh", action: "show", label: "\(path.section)==\(path.row)")
        return [e]
    }
    
    var isMonitorAble: Bool {
        return true
    }
    
    
}
