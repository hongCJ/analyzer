//
//  Analyzer.Dispatcher.swift
//  Analyzer
//
//  Created by 郑红 on 2020/12/10.
//  Copyright © 2020 com.zhenghong. All rights reserved.
//

import Foundation

protocol TaskDispatchAble {
    associatedtype Value
    func perform() -> Value
}

class TaskDispatcher {
    private var runLoopObserver: CFRunLoopObserver?
    private var tasks: [AnalyzerTask] = []
    
    func enque(task: AnalyzerTask, after time: TimeInterval = 0) {
        if time == 0 {
            tasks.append(task)
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                self.tasks.append(task)
            }
        }
    }
    
    func start() {
        addObserver()
    }
    
    func stop() {
        removeObserver()
    }
    
    private func runTask() {
        guard !tasks.isEmpty else {
            return
        }
        
        let copyTasks = tasks.unique { (task) -> String in
            task.view.key
        }
        tasks.removeAll()
        for task in copyTasks {
            task.view.checker.startCheck(kind: task.kind)
        }
    }

    private func removeObserver() {
        guard let observer = runLoopObserver else {
            return
        }
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, CFRunLoopMode.defaultMode)
    }
    
    private func addObserver() {
        removeObserver()
        let info = Unmanaged<TaskDispatcher>.passUnretained(self).toOpaque()
        var context = CFRunLoopObserverContext(version: 0, info: info, retain: nil, release: nil, copyDescription: nil)
        runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, CFRunLoopActivity.beforeWaiting.rawValue, true, 0, runLoopObserverCallBack(), &context)
        CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, CFRunLoopMode.defaultMode)
    }
    
    private func runLoopObserverCallBack() -> CFRunLoopObserverCallBack {
        return { observer, activity, info in
            guard let context = info else {
                return
            }
            let weakSelf = Unmanaged<TaskDispatcher>.fromOpaque(context).takeUnretainedValue()
            weakSelf.runTask()
        }
    }
}
