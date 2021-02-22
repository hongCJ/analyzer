//
//  Dispatcher.swift
//  MVTimeAnalyzer
//
//  Created by mac on 2021/1/19.
//


import Foundation

protocol TaskDispatchDelegate: NSObjectProtocol {
    func dispatchDidFinishTask(tasks: [AnalyzerTask], events: [AnalyzerEvent])
}

class Dispatcher {
    private var runLoopObserver: CFRunLoopObserver?
    
    private var tasks: [AnalyzerTask] = []
    private var dateOfLastTask: TimeInterval = 0
    private var isRunning = false
    
    
    weak var delegate: TaskDispatchDelegate?
    
    func enque(task: AnalyzerTask, after time: TimeInterval = 0) {
        if !isRunning {
            start()
        }
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
        if tasks.isEmpty {
            let now = Date.timeIntervalSinceReferenceDate
            if dateOfLastTask > 0 && now - dateOfLastTask > 10 {
                stop()
            }
            return
        }
        
        let copyTasks = tasks.unique { (task) -> String in
            task.view.key
        }
        tasks.removeAll()
        let events = copyTasks.flatMap {
            $0.dispatch()
        }
        delegate?.dispatchDidFinishTask(tasks: copyTasks, events: events)
        dateOfLastTask = Date.timeIntervalSinceReferenceDate
    }

    private func removeObserver() {
        defer {
            isRunning = false
        }
        guard let observer = runLoopObserver else {
            return
        }
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, CFRunLoopMode.defaultMode)
    }
    
    private func addObserver() {
        defer {
            isRunning = true
        }
        removeObserver()
        let info = Unmanaged<Dispatcher>.passUnretained(self).toOpaque()
        var context = CFRunLoopObserverContext(version: 0, info: info, retain: nil, release: nil, copyDescription: nil)
        runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, CFRunLoopActivity.beforeWaiting.rawValue, true, 0, runLoopObserverCallBack(), &context)
        CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, CFRunLoopMode.defaultMode)
    }
    
    private func runLoopObserverCallBack() -> CFRunLoopObserverCallBack {
        return { observer, activity, info in
            guard let context = info else {
                return
            }
            let weakSelf = Unmanaged<Dispatcher>.fromOpaque(context).takeUnretainedValue()
            weakSelf.runTask()
        }
    }
}

