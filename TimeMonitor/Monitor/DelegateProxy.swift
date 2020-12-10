//
//  DelegateProxy.swift
//  TimeMonitor
//
//  Created by mac on 2020/11/29.
//

import UIKit

protocol ScrollViewProxyDelegate: NSObjectProtocol {
    func scrollViewClickAtIndex(indexPath: IndexPath, _ view: UIView)
    func scrollViewShowFor(view: UIView)
}

extension UIView {
    var viewProxy:  ViewProxy {
        if let collection = self as? UICollectionView {
            let result  = CollectionDelegateProxy(proxy: collection.delegate)
            collection.delegate = result
            return result
        }
        if let table = self as? UITableView {
            let result = TableDelegateProxy(proxy: table.delegate)
            table.delegate = result
            return result
        }
        if let scrollView = self as? UIScrollView {
            let result = ScrollViewProxy(proxy: scrollView.delegate)
            scrollView.delegate = result
            return result
        }
        return ViewProxy()
    }
}


class  ViewProxy: NSObject {
    weak var proxyDelegate: ScrollViewProxyDelegate?
}

class ScrollViewProxy: ViewProxy, UIScrollViewDelegate {
    weak var delegate: UIScrollViewDelegate?
    init(proxy: UIScrollViewDelegate?) {
        super.init()
        delegate = proxy
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        return delegate?.responds(to: aSelector) ?? false
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return delegate
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        proxyDelegate?.scrollViewShowFor(view: scrollView)
        if delegate?.responds(to: #selector(scrollViewDidEndDragging(_:willDecelerate:)))  ?? false {
            delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        }
    }
    
}


class CollectionDelegateProxy: ViewProxy, UICollectionViewDelegate {
    weak var delegate: UICollectionViewDelegate?
     init(proxy: UICollectionViewDelegate?) {
        super.init()
        self.delegate = proxy
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        let didClick  = #selector(collectionView(_:didSelectItemAt:))
        let endDrag = #selector(scrollViewDidEndDragging(_:willDecelerate:))
        if aSelector == didClick || aSelector == endDrag {
            return true
        }
        return delegate?.responds(to: aSelector) ?? false
    }
    
    override  func forwardingTarget(for aSelector: Selector!) -> Any? {
        return delegate
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        proxyDelegate?.scrollViewClickAtIndex(indexPath: indexPath, collectionView)
        if delegate?.responds(to: #selector(collectionView(_:didSelectItemAt:))) ?? false {
            delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        proxyDelegate?.scrollViewShowFor(view: scrollView)
        if delegate?.responds(to: #selector(scrollViewDidEndDragging(_:willDecelerate:)))  ?? false {
            delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        }
    }
}

class TableDelegateProxy: ViewProxy, UITableViewDelegate {
    weak var delegate: UITableViewDelegate?
     init(proxy: UITableViewDelegate?) {
        super.init()
        self.delegate = proxy
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        let didClick  = #selector(tableView(_:didSelectRowAt:))
        let endDrag = #selector(scrollViewDidEndDragging(_:willDecelerate:))
        if aSelector == didClick || aSelector == endDrag {
            return true
        }
        return delegate?.responds(to: aSelector) ?? false
    }
    
    override  func forwardingTarget(for aSelector: Selector!) -> Any? {
        return delegate
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        proxyDelegate?.scrollViewClickAtIndex(indexPath: indexPath, tableView)
        if delegate?.responds(to: #selector(tableView(_:didSelectRowAt:))) ?? false {
            delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        proxyDelegate?.scrollViewShowFor(view: scrollView)
        if delegate?.responds(to: #selector(scrollViewDidEndDragging(_:willDecelerate:))) ?? false {
            delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        }
    }
    
}


