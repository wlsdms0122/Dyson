//
//  SessionTask.swift
//  
//
//  Created by JSilver on 2023/02/12.
//

import Foundation

public protocol SessionTask: AnyObject, SessionTaskDelegate {
    var tasks: [any SessionTask] { get }
    
    var state: SessionTaskState { get set }
    
    var request: URLRequest? { get }
    var progress: Progress? { get }
    
    var delegate: (any SessionTaskDelegate)? { get set }
    
    func cancel()
}

public extension SessionTask {
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

extension SessionTask {
    func _cancel() {
        cancel()
        delegate?.sessionTaskDidCancel(self)
    }
}

public protocol DataSessionTask: SessionTask {
    func resume(completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void)
    func resume() async throws -> (Data, URLResponse)
}

public extension DataSessionTask {
    var tasks: [SessionTask] { [] }
    
    func resume(completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void) {
        Task {
            do {
                completion(.success(try await resume()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func resume() async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            resume { result in
                switch result {
                case let .success(response):
                    continuation.resume(returning: response)
                    
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func observe(progress: Progress, updateHandler: ((Progress) -> Void)? = nil) -> NSKeyValueObservation {
        progress.observe(\.fractionCompleted) { [weak self] progress, _ in
            updateHandler?(progress)
            
            if let self {
                self.delegate?.sessionTask(
                    self,
                    didSend: progress.completedUnitCount,
                    totalBytes: progress.totalUnitCount
                )
            }
        }
    }
}

extension DataSessionTask {
    func _resume(completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void) {
        resume { [weak self] result in
            completion(result)
            
            if let self {
                self.delegate?.sessionTaskDidComplete(self)
            }
        }
        
        delegate?.sessionTaskDidResume(self)
    }
}

public protocol SessionTaskDelegate: AnyObject {
    func sessionTaskDidResume(_ sessionTask: any SessionTask)
    func sessionTask(_ sessionTask: any SessionTask, didSend bytes: Int64, totalBytes: Int64)
    func sessionTaskDidCancel(_ sessionTask: any SessionTask)
    func sessionTaskDidComplete(_ sessionTask: any SessionTask)
}
