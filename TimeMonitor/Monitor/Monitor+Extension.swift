//
//  Monitor+Extension.swift
//  TimeMonitor
//
//  Created by mac on 2020/11/28.
//

import UIKit



class EventHandler<T>: NSObject {
    var event: AnalyzerEvent!
    
    var closure: (T) -> Void
    
    init(e: AnalyzerEvent, c: @escaping (T) -> Void) {
        event = e
        closure = c
        super.init()
    }
    
   @objc func handleEvent() {
        
    }
}


extension UIButton {
    func on(action: UIControl.Event,  event: AnalyzerEvent, closure: @escaping (UIButton) -> Void) {
        let eventHandler = EventHandler<UIButton>(e: event, c: closure)
        addTarget(eventHandler, action: #selector(EventHandler<UIButton>.handleEvent), for: action)
        objc_setAssociatedObject(self, event.key, eventHandler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}


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
    
    var key: String {
        return "key_\(hash)"
    }
}



extension UICollectionViewCell {
    var collectionView: UICollectionView? {
        return findSuperView(aClass: UICollectionView.self) as? UICollectionView
    }
    func startMonitor() {
        Monitor.shared.register(cell: self)
    }
}

extension UITableViewCell {
    var tableView: UITableView? {
        return findSuperView(aClass: UITableView.self) as? UITableView
    }
    func startMonitor() {
        Monitor.shared.register(cell: self)
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

