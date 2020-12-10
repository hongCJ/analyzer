//
//  TableViewController.swift
//  TimeMonitor
//
//  Created by mac on 2020/12/10.
//

import UIKit

class MyCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyCell: MonitorObservable {
    var clickMonitorEvent: [AnalyzerEvent] {
        let event = AnalyzerEvent(name: "click", parameter: [
            "click" : "llll"
        ], time: .everyTime)
        return [event]
    }
    
    var showMonitorEvent: [AnalyzerEvent] {
        let event = AnalyzerEvent(name: "click", parameter: [
            "table" : "llll"
        ], time: .everyTime)
        return [event]
    }
    
}

class TableViewController: UIViewController {
    
    var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        table = UITableView(frame: view.bounds)
        table.delegate = self
        table.dataSource = self
        table.register(MyCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(table)
        table.startMonitor()
    }
    
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.section)__\(indexPath.row)"
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("aaadashk")
    }
}
