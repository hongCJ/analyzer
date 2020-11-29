//
//  DelegateProxy.swift
//  TimeMonitor
//
//  Created by mac on 2020/11/29.
//

import UIKit

protocol ScrollViewProxyDelegate: NSObjectProtocol {
    func scrollViewClickAtIndex(indexPath: IndexPath, viewKey key: String)
    func scrollViewShowFor(viewKey key: String)
}

class  ScrollViewProxy: NSObject {
    weak var proxyDelegate: ScrollViewProxyDelegate?
    
}
class CollectionDelegateProxy: ScrollViewProxy, UICollectionViewDelegate {
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
        proxyDelegate?.scrollViewClickAtIndex(indexPath: indexPath, viewKey: collectionView.key)
        if delegate?.responds(to: #selector(collectionView(_:didSelectItemAt:))) ?? false {
            delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        proxyDelegate?.scrollViewShowFor(viewKey: scrollView.key)
        if delegate?.responds(to: #selector(scrollViewDidEndDragging(_:willDecelerate:)))  ?? false {
            delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        }
    }
}



class TableDelegateProxy: ScrollViewProxy, UITableViewDelegate {
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
        proxyDelegate?.scrollViewClickAtIndex(indexPath: indexPath, viewKey: tableView.key)
        if delegate?.responds(to: #selector(tableView(_:didSelectRowAt:))) ?? false {
            delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        proxyDelegate?.scrollViewShowFor(viewKey: scrollView.key)
        if delegate?.responds(to: #selector(scrollViewDidEndDragging(_:willDecelerate:))) ?? false {
            delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        }
    }
    
}


