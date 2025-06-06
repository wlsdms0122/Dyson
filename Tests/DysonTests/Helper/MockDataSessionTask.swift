//
//  MockDataSessionTask.swift
//
//
//  Created by JSilver on 2023/06/16.
//

import Foundation
import Dyson

public class MockDataSessionTask<T>: DataSessionTask {
    // MARK: - Property
    public var request: URLRequest?
    public var progress: Progress?
    
    private let data: T
    private let _cancel: (() -> Void)?
    private let _resume: (T, @escaping (Result<(Data, URLResponse), Error>) -> Void) -> Void
    
    // MARK: - Initiailzer
    public init(
        data: T,
        cancel: (() -> Void)? = nil,
        resume: @escaping (T, @escaping (Result<(Data, URLResponse), Error>) -> Void) -> Void
    ) {
        self.data = data
        self._cancel = cancel
        self._resume = resume
    }
    
    // MARK: - Public
    public func resume(completion: @escaping (Result<(Data, URLResponse), Error>) -> Void) {
        _resume(data, completion)
    }
    
    public func cancel() {
        _cancel?()
    }
    
    // MARK: - Private
}
