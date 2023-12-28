//
//  AsyncOperation.swift
//  Operation_ДЗ
//
//  Created by Илья Кузнецов on 28.12.2023.
//

import Foundation

class AsyncOperation: Operation {

    private let lockQueue = DispatchQueue(label: "lock.example", attributes: .concurrent)

    override var isAsynchronous: Bool { return true }

    private var _isFinished = false
    override private(set) var isFinished: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isFinished
            }
        }
        set {
            willChangeValue(for: \.isFinished)
            lockQueue.sync(flags: .barrier) {
                _isFinished = newValue
            }
            didChangeValue(for: \.isFinished)
        }
    }

    private var _isExecuting = false
    override private(set) var isExecuting: Bool {
        get {
            return lockQueue.sync { () -> Bool in
                return _isExecuting
            }
        }
        set {
            willChangeValue(for: \.isExecuting)
            lockQueue.sync(flags: .barrier) {
                _isExecuting = newValue
            }
            didChangeValue(for: \.isExecuting)
        }
    }

    override func main() {
        fatalError("Should be implemented in child classes")
    }
    
    override func start() {
        guard !isCancelled else {
            finish()
            return
        }

        isFinished = false
        isExecuting = true

        print("Started")

        main()
    }

    func finish() {
        print("finished")
        isExecuting = false
        isFinished = true
    }
}
