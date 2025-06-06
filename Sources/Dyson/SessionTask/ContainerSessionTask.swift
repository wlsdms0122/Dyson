//
//  ContainerSessionTask.swift
//
//
//  Created by JSilver on 2023/06/18.
//

import Foundation

final class ContainerSessionTask: DataSessionTask, StateSessionTask, DelegatedSessionTask {
    // MARK: - Property
    private var children: [any SessionTask] = []
    
    private var currentTask: (any SessionTask)? {
        (children.last as? ContainerSessionTask)?.currentTask ?? children.last
    }
    
    public var state = SessionState()
    
    public var request: URLRequest? { currentTask?.request }
    public var progress: Progress? { currentTask?.progress }
    
    public weak var delegate: (any SessionTaskDelegate)?
    
    private let _progress: ((Progress) -> Void)?
    private var progressObservation: NSKeyValueObservation?
    
    // MARK: - Initialzer
    init(progress: ((Progress) -> Void)?) {
        self._progress = progress
    }
    
    // MARK: - Public
    func resume(completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void) {
        guard let task = currentTask as? DataSessionTask else { return }
        
        task.resume { [weak self] result in
            completion(result)
            
            self?.delegate?.sessionTaskDidComplete(task)
        }
        
        delegate?.sessionTaskDidResume(task)
        
        observe(task: task)
    }
    
    public func addChild(_ task: any SessionTask) {
        children.append(task)
        
        if let task = task as? StateSessionTask {
            state.merge(task.state)
            task.state = state
        }
        
        if let task = task as? DelegatedSessionTask {
            task.delegate = self
        }
    }
    
    public func cancel() {
        guard let task = currentTask else { return }
        
        task.cancel()
        delegate?.sessionTaskDidCancel(task)
    }
    
    // MARK: - Private
    private func observe(task: any SessionTask) {
        guard let progress = task.progress else { return }
        
        progressObservation = progress.observe(\.fractionCompleted) { [weak self] progress, _ in
            self?._progress?(progress)
            self?.delegate?.sessionTask(
                task,
                didSend: progress.completedUnitCount,
                totalBytes: progress.totalUnitCount
            )
        }
    }
}

extension ContainerSessionTask: SessionTaskDelegate {
    func sessionTaskDidResume(_ sessionTask: any SessionTask) {
        delegate?.sessionTaskDidResume(sessionTask)
    }

    func sessionTaskDidCancel(_ sessionTask: any SessionTask) {
        delegate?.sessionTaskDidCancel(sessionTask)
    }

    func sessionTask(_ sessionTask: any SessionTask, didSend bytes: Int64, totalBytes: Int64) {
        delegate?.sessionTask(sessionTask, didSend: bytes, totalBytes: totalBytes)
    }

    func sessionTaskDidComplete(_ sessionTask: any SessionTask) {
        delegate?.sessionTaskDidComplete(sessionTask)
    }
}
