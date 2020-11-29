//
//  Monitor+Extension.swift
//  TimeMonitor
//
//  Created by mac on 2020/11/28.
//

import UIKit

extension UIView {
    var key: String {
        return "key_\(hash)"
    }
}

extension UICollectionViewCell {
    func startMonitor() {
        Monitor.shared.register(cell: self)
    }
}

extension UITableViewCell {
    func startMonitor() {
        Monitor.shared.register(cell: self)
    }
}


