//
//  RunLoopManager.swift
//  LabelH
//
//  Created by 李鹏跃 on 2018/7/9.
//  Copyright © 2018年 李鹏跃. All rights reserved.
//

import UIKit

//@objc protocol RunLoopManagerTimerProtocol: NSObjectProtocol {
//    @objc optional func runLoopManagerTimerCallBack()
//}

class RunLoopManager: NSObject {
    override init() {
        super.init()
        createTimerIfNotTimer()
        openRunloopManager()
    }
    static let defult = RunLoopManager()
    
    /// 缓存的tasks
    var taskArray:[()->()] { return taskArray_private }
    
    /// 超过taskArray最大count后，从taskArray删除的task 集合
    var taskArrayNotExecute = [()->()]()
    
    /// 每个运行循环最大运行数
    var loopMaxConcurrency: NSInteger = 100
    
    /// taskArray 最大的count
    var taskArrayMaxCount: NSInteger = NSInteger.max
    
    /// timer
    var timer: Timer? { get { return createTimerIfNotTimer() } }
    
    /// close loopManager
    var isCloseLoopManager = false {
        didSet {
            isCloseLoopManagerFunc()
        }
    }
   
    /// 最短时长 默认为0.1s 如果 minSecondDuration <= 0 那么默认为0.1s
    var minSecondDuration: CGFloat {
        get { return minSecondDuration_private }
        set {
            timer_prevate = nil
            minSecondDuration_private = newValue <= 0 ? 0.1 : newValue
        }
    }
    
    /// 添加task 如果manager处于关闭状态，那么将自动 开启 “if !isCloseLoopManager { isCloseLoopManager = false }”
    ///
    /// - Parameters:
    ///   - task: task
    func addTask(task:(()->())?) -> () {
        if !isCloseLoopManager { isCloseLoopManager = false }
        if taskArray.count > taskArrayMaxCount && taskArray.count > 0 {
            let element = taskArray_private.remove(at: 0)
            taskArrayNotExecute.append(element)
        }
        if let task = task {
            taskArray_private.append(task)
        }
    }
    
    /// 完成
    func completeFunc(complete: (()->())?) { self.complete = complete }
    
    /// 删除所有的tasks
    func deleteAllTask() {
        taskArray_private.removeAll()
        taskArrayNotExecute.removeAll()
    }
    
    /// 完成后的block
    private var complete:(()->())?
    private var timer_prevate: Timer?
    private var taskArray_private = [()->()]()
    private var minSecondDuration_private: CGFloat = 0.1 { didSet {createTimerIfNotTimer()} }
    
    @discardableResult
    private func createTimerIfNotTimer() -> Timer? {
        if timer_prevate == nil {
            timer_prevate = Timer.scheduledTimer(timeInterval: 1,
                                                 target: self,
                                                 selector: #selector(timerCallBackFunc),
                                                 userInfo: nil,
                                                 repeats: true)
            RunLoop.current.add(timer_prevate!, forMode: RunLoopMode.commonModes)
        }
        return timer_prevate
    }
   
    @objc private func timerCallBackFunc() {
        
    }
    
    /// 开启runLoop
    private func openRunloopManager() {
        let runloop = CFRunLoopGetCurrent()
        let unsafeBit = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)
        var context = CFRunLoopObserverContext(version: 0,
                                               info: unsafeBit,
                                               retain: nil,
                                               release: nil,
                                               copyDescription: nil)
        
        if   let observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                    CFRunLoopActivity.beforeWaiting.rawValue,
                                                    true,
                                                    0,
                                                    self.observerCallbackFunc(),
                                                    &context){
            
            //添加当前RunLoop的观察者
            CFRunLoopAddObserver(runloop, observer, .commonModes);
        }
    }

    ///回调函数
    private func observerCallbackFunc() -> CFRunLoopObserverCallBack {
        return {(observer, activity, context) -> Void in
            //如果没有取到  直接返回
            if context == nil { return }
            //取出上下文 就是当前的runloopManager
            let manager = unsafeBitCast(context, to: RunLoopManager.self)
            //取出任务
            if manager.taskArray_private.count <= 0 {
                return
            }
            for _ in 0 ... manager.loopMaxConcurrency {
                if manager.taskArray_private.count <= 0 {
                    manager.complete?()
                    break
                }
                manager.taskArray_private[0]()
                let _ = manager.taskArray_private.remove(at: 0)
            }
           
        }
    }
    private func isCloseLoopManagerFunc() {
        isCloseLoopManager ? sleepTimer() : weakUpTimer()
    }
    private func sleepTimer() {
        timer_prevate?.fireDate = Date.distantFuture
    }
    private func weakUpTimer() {
        timer_prevate?.fireDate = NSDate.init() as Date
    }

}
