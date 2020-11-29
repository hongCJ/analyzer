//
//  Monitor+Util.swift
//  TimeMonitor
//
//  Created by mac on 2020/11/28.
//

import UIKit

extension UIView {
    func findSuperView(aClass: AnyClass) -> UIView? {
        var _view = self
        while let _superView = _view.superview {
            if _superView.isKind(of: aClass) {
                return _superView
            }
            _view = _superView
        }
        return nil
    }
    
    func isVisible() -> Bool {
        if isHidden {
            return false
        }
        guard let _superView = self.superview,
              let window = self.window  else {
            return false
        }
        let toFrame = _superView.convert(frame, to: window)
        return window.bounds.contains(toFrame)
    }
}



extension UICollectionViewCell {
    var collectionView: UICollectionView? {
        return findSuperView(aClass: UICollectionView.self) as? UICollectionView
    }
}

extension UITableViewCell {
    var tableView: UITableView? {
        return findSuperView(aClass: UITableView.self) as? UITableView
    }
}

extension Array {
    func unique(closure: (Element) -> String) -> [Element] {
        var result: [Element] = []
        var dic: [String : Bool] = [:]
        for item in self {
            let k = closure(item)
            if let _ = dic[k] {
                continue
            }
            dic[k] = true
            result.append(item)
        }
        return result
    }
}
