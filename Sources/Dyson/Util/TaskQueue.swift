//
//  TaskQueue.swift
//  
//
//  Created by jsilver on 2022/10/16.
//

import Foundation

struct TaskQueue<Success, Failure: Error> {
    typealias Task = (_ value: Success, _ completion: @escaping (Result<Success, Failure>) -> Void) -> Void
    
    // MARK: - Property
    
    // MARK: - Initializer
    
    // MARK: - Public
    
    // MARK: - Private
    private func run(
        value: Success,
        tasks: inout [Task],
        _ completion: ((Result<Success, Failure>) -> Void)?
    ) {
        guard !tasks.isEmpty else {
            // Complete with success when queue is empty.
            completion?(.success(value))
            return
        }
        
        // Get task.
        var tasks = tasks
        let task = tasks.removeFirst()
        
        // Run task.
        task(value) {
            switch $0 {
            case let .success(value):
                run(
                    value: value,
                    tasks: &tasks,
                    completion
                )
                
            case let .failure(error):
                completion?(.failure(error))
            }
        }
    }
}

extension TaskQueue where Failure == Error {
    @discardableResult
    init(
        _ initialValue: Success = Void(),
        _ tasks: (_ queue: inout [Task]) -> Void,
        completion: ((Result<Success, Failure>) -> Void)? = nil
    ) {
        // Create task queue.
        var queue: [Task] = []
        tasks(&queue)
        
        // Run task queue.
        run(
            value: initialValue,
            tasks: &queue,
            completion
        )
    }
}
