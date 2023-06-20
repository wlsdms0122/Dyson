//
//  ContainerSessionTask.swift
//
//
//  Created by JSilver on 2023/06/18.
//

import Foundation

final public class ContainerSessionTask: SessionTask {
    // MARK: - Property
    public private(set) var tasks: [any SessionTask] = []
    private var currentTask: (any SessionTask)? {
        tasks.flatMap { $0.tasks.isEmpty ? [$0] : $0.tasks }
            .last
    }
    
    public var request: URLRequest? { currentTask?.request }
    public var progress: Progress? { currentTask?.progress }
    
    public var state = SessionTaskState()
    
    public weak var delegate: (any SessionTaskDelegate)?
    
    private var _progress: ((Progress) -> Void)?
    
    // MARK: - Initialzer
    init(progress: ((Progress) -> Void)?) {
        self._progress = progress
    }
    
    // MARK: - Lifecycle
    public func sessionTask(_ sessionTask: SessionTask, didSend bytes: Int64, totalBytes: Int64) {
        delegate?.sessionTask(sessionTask, didSend: bytes, totalBytes: totalBytes)
        
        guard let progress = sessionTask.progress else { return }
        _progress?(progress)
    }
    
    // MARK: - Public
    public func addChild(_ task: any SessionTask) {
        task.state = state.merging(task.state)
        task.delegate = self
        
        tasks.append(task)
    }
    
    public func cancel() {
        currentTask?._cancel()
    }
    
    // MARK: - Private
}

public extension ContainerSessionTask {
    func callAsFunction(_ child: () -> any SessionTask) {
        addChild(child())
    }
}
