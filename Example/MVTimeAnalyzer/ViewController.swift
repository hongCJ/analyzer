//
//  ViewController.swift
//  MVTimeAnalyzer
//
//  Created by zhenghong on 01/19/2021.
//  Copyright (c) 2021 zhenghong. All rights reserved.
//

import UIKit
import MVTimeAnalyzer
class ViewController: UIViewController {

    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 150, height: 150)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.sectionInset = .init(top: 20, left: 20, bottom: 20, right: 20)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(TestCollectionCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
        MVTimeAnalyzer.shared.addUploader(uploader: MyUploader())
        collectionView.analyzerDataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TestCollectionCell
        cell.testLabel.text = "\(indexPath.section)__\(indexPath.row)"
        cell.backgroundColor = .systemPink
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let testCell = cell as? TestCollectionCell else {
            return
        }
        testCell.bindData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select\(indexPath.section)_\(indexPath.row)")
    }
}

extension ViewController: AnalyzerEventsDataSource {
    func provideShowEvent(for indexPath: IndexPath) -> [AnalyzerEvent] {
        guard indexPath.section < 2 else {
            return []
        }
        guard 0..<30 ~= indexPath.row else {
            return []
        }
        let event = AnalyzerEvent(name: "show_event", parameter: ["key":"\(indexPath.section)_\(indexPath.row)"], time: .memoryOnce)
        return [event]
    }
    
    func provideClickEvent(for indexPath: IndexPath) -> [AnalyzerEvent] {
        guard indexPath.section < 2 else {
            return []
        }
        guard 0..<30 ~= indexPath.row else {
            return []
        }
        let event = AnalyzerEvent(name: "click_event", parameter: ["key":"\(indexPath.section)_\(indexPath.row)"], time: .everyTime)
        
        let event2 = AnalyzerEvent(name: "show_event", parameter: ["key":"\(indexPath.section)_\(indexPath.row)"], time: .everyTime)
        return [event, event2]
    }
}
