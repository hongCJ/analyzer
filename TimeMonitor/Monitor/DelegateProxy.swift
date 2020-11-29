//
//  DelegateProxy.swift
//  TimeMonitor
//
//  Created by mac on 2020/11/29.
//

import UIKit

//class ScrollViewProxy<Target: UIScrollViewDelegate>: NSObject, UIScrollViewDelegate {
//    weak var target: Target?
//
//
//    override func responds(to aSelector: Selector!) -> Bool {
//        let endDrag = #selector(scrollViewDidEndDragging(_:willDecelerate:))
//        if endDrag == aSelector {
//            return true
//        }
//        return target?.responds(to: aSelector) ?? false
//    }
//
//    override  func forwardingTarget(for aSelector: Selector!) -> Any? {
//        return target
//    }
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        target?.scrollViewDidScroll?(scrollView)
//    }
//
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        target?.scrollViewDidZoom?(scrollView)
//    }
//
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        target?.scrollViewWillBeginDragging?(scrollView)
//    }
//
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        target?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
//    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("end drag")
//        target?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
//    }
//
//    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        target?.scrollViewWillBeginDecelerating?(scrollView)
//    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        target?.scrollViewDidEndDecelerating?(scrollView)
//    }
//
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        target?.scrollViewDidEndScrollingAnimation?(scrollView)
//    }
//
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return target?.viewForZooming?(in: scrollView)
//    }
//
//    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
//        target?.scrollViewWillBeginZooming?(scrollView, with: view)
//    }
//
//    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//        target?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
//    }
//
//    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
//        return target?.scrollViewShouldScrollToTop?(scrollView) ?? true
//    }
//
//    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
//        target?.scrollViewDidScrollToTop?(scrollView)
//    }
//
//    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
//        target?.scrollViewDidChangeAdjustedContentInset?(scrollView)
//    }
    
//}

//protocol ScrollViewProxy: NSObjectProtocol {
//    associatedtype Delegate: UIScrollViewDelegate
//
//    weak var delegate: Delegate? {get set}
//}

class  ScrollViewProxy: NSObject {}


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
        print("click at")
        if delegate?.responds(to: #selector(collectionView(_:didSelectItemAt:))) ?? false {
            delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
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
        if delegate?.responds(to: #selector(tableView(_:didSelectRowAt:))) ?? false {
            delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if delegate?.responds(to: #selector(scrollViewDidEndDragging(_:willDecelerate:))) ?? false {
            delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        }
    }
    
}


