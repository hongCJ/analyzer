//
//  ViewController.swift
//  Analyzer
//
//  Created by 郑红 on 2020/12/10.
//  Copyright © 2020 com.zhenghong. All rights reserved.
//

import UIKit

struct BaseUploader: AnalyzerUploader {
    func uploadEvent(event: AnalyzerEvent) {
        print("\(event.name)_\(event.parameter)")
    }
}

class V: UIView {
    var index: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.tryAnalyze(delay: 1.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension V: AnalyzerAbleProtocol {
    var analyzerClickEvents: [AnalyzerEvent] {
        let e = AnalyzerEvent(name: "scroll_click", parameter: [
            "index" : "\(index)"
        ], time: .memoryOnce)
        return [e]
    }
    
    var analyzerShowEvents: [AnalyzerEvent] {
        let e = AnalyzerEvent(name: "scroll_show", parameter: [
            "index" : "\(index)"
        ], time: .memoryOnce)
        return [e]
    }
    
    
}

class ViewController: UIViewController {

    private var collectionView: UICollectionView!
    
    private var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: self.view.bounds)
        for i in 0...10 {
            let v = V(frame: CGRect(x: 0, y: 310 * i, width: 300, height: 300))
            v.index = i
            v.backgroundColor = .red
            scrollView.addSubview(v)
            
        }
        view.addSubview(scrollView)
        
        scrollView.contentSize = CGSize(width: 300, height: 310 * 10)
        
        PBNAnalyzer.shared.addQueue(queue: DispatchQueue(label: "my_queue"))
        PBNAnalyzer.shared.addUploader(uploader: BaseUploader())

        let g = UITapGestureRecognizer(target: self, action: #selector(handleTap(ges:)))
        scrollView.addGestureRecognizer(g)
        g.addTarget(self, action: #selector(handleTap2(ges:)))
        
//        let g2 = UITapGestureRecognizer(target: self, action: #selector(handleTap2(ges:)))
//        scrollView.addGestureRecognizer(g2)
        
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 100, height: 100)
//
//        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
//        collectionView.backgroundColor = UIColor.white
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(TestCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//        view.addSubview(collectionView)
    }
    
    @objc func handleTap(ges: UIGestureRecognizer) {
        print("11")
    }
    @objc func handleTap2(ges: UIGestureRecognizer) {
        print("22")
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let testCell = cell as? TestCollectionViewCell else {
            return
        }
        testCell.titleLabel.text = "\(indexPath.section) + \(indexPath.row)"
        testCell.indexPath = indexPath
        testCell.readyAnalyze(delay: 1.0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let v = TableViewController()
        navigationController?.pushViewController(v, animated: true)

    }
}

