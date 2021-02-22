//
//  Proxy.swift
//  MVTimeAnalyzer
//
//  Created by mac on 2021/1/19.
//


import UIKit

protocol ProxyDelegate: NSObjectProtocol {
    func proxyViewClickAtIndex(indexPath: IndexPath, _ view: UIView)
    func proxyViewShowFor(view: UIView)
    func proxyViewClickAtLocation(location: CGPoint, _ view: UIView)
}

extension UIView {
    var viewProxy:  ViewProxy {
        if let collection = self as? UICollectionView {
            return CollectionDelegateProxy(view: collection)
        }
        if let table = self as? UITableView {
            return TableDelegateProxy(view: table)
        }
        if let scrollView = self as? UIScrollView {
            return ScrollViewProxy(view: scrollView)
        }
        fatalError()
    }
}


class  ViewProxy: NSObject {
    weak var proxyDelegate: ProxyDelegate?
    
    init(view: UIView) {
        super.init()
        if let  scrollView = view as? UIScrollView {
            bindGesture(view: scrollView)
            bindOffSet(view: scrollView)
        } else {
            fatalError()
        }
    }
    
    var contentOffSet: NSKeyValueObservation?
    
    func bindGesture(view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(gesture:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func bindOffSet(view: UIScrollView) {
        contentOffSet = view.observe(\UIScrollView.contentOffset, options: .new, changeHandler: { (scrollView, value) in
            if scrollView.isDragging {
                return
            }
            self.proxyDelegate?.proxyViewShowFor(view: scrollView)
        })
    }
    @objc func handleTapGesture(gesture: UITapGestureRecognizer) {}
}

class ScrollViewProxy: ViewProxy {
    override func handleTapGesture(gesture: UITapGestureRecognizer) {
        guard let scrollView = gesture.view as? UIScrollView else {
            return
        }
        self.proxyDelegate?.proxyViewClickAtLocation(location: gesture.location(in: scrollView), scrollView)
    }
}


class CollectionDelegateProxy: ViewProxy {
    override func handleTapGesture(gesture: UITapGestureRecognizer) {
        guard let collectionView = gesture.view as? UICollectionView else {
            return
        }
        guard let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
            return
        }
        self.proxyDelegate?.proxyViewClickAtIndex(indexPath: indexPath, collectionView)
    }
}

class TableDelegateProxy: ViewProxy {
    override func handleTapGesture(gesture: UITapGestureRecognizer) {
        guard let tableView = gesture.view as? UITableView else {
            return
        }
        guard let indexPath = tableView.indexPathForRow(at: gesture.location(in: tableView)) else {
            return
        }
        self.proxyDelegate?.proxyViewClickAtIndex(indexPath: indexPath, tableView)
    }
    
}



