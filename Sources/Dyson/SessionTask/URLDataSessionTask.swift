//
//  URLDataSessionTask.swift
//  
//
//  Created by JSilver on 2023/02/12.
//

import Foundation

final public class URLDataSessionTask: DataSessionTask {
    // MARK: - Property
    public var state = SessionTaskState()
    
    public var request: URLRequest? { _request }
    public var progress: Progress? { sessionTask?.progress }
    
    public weak var delegate: (any SessionTaskDelegate)?
    
    private let session: URLSession
    private let _request: URLRequest
    
    private var sessionTask: URLSessionTask?
    
    private var progressObservation: NSKeyValueObservation?
    
    // MARK: - Initialzer
    public init(
        session: URLSession,
        request: URLRequest
    ) {
        self.session = session
        self._request = request
    }
    
    // MARK: - Public
    public func resume(completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void) {
        let sessionTask = session.dataTask(with: _request) { data, response, error in
            if let error {
                completion(.failure(error))
            } else if let data, let response {
                completion(.success((data, response)))
            } else {
                completion(.failure(DysonError.unknown))
            }
        }
        
        progressObservation = observe(progress: sessionTask.progress)
        
        self.sessionTask = sessionTask
        
        sessionTask.resume()
    }
    
    public func cancel() {
        sessionTask?.cancel()
    }
    
    // MARK: - Private
}

final public class URLUploadSessionTask: DataSessionTask {
    // MARK: - Property
    public var state = SessionTaskState()
    
    public var request: URLRequest? { _request }
    public var progress: Progress? { sessionTask?.progress }
    
    public weak var delegate: (any SessionTaskDelegate)?
    
    private let session: URLSession
    
    private let _request: URLRequest
    private let data: Data
    
    private var sessionTask: URLSessionTask?
    
    private var progressObservation: NSKeyValueObservation?
    
    // MARK: - Initialzer
    public init(
        session: URLSession,
        request: URLRequest,
        data: Data
    ) {
        self.session = session
        self._request = request
        self.data = data
    }
    
    // MARK: - Public
    public func resume(completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void) {
        let sessionTask = session.uploadTask(with: _request, from: data) { data, response, error in
            if let error {
                completion(.failure(error))
            } else if let data, let response {
                completion(.success((data, response)))
            } else {
                completion(.failure(DysonError.unknown))
            }
        }
        
        progressObservation = observe(progress: sessionTask.progress)
        
        sessionTask.resume()
        
        self.sessionTask = sessionTask
    }
    
    public func cancel() {
        sessionTask?.cancel()
    }
    
    // MARK: - Private
}

final public class URLDownloadSessionTask: DataSessionTask {
    // MARK: - Property
    public var state = SessionTaskState()
    
    public var request: URLRequest? { _request }
    public var progress: Progress? { sessionTask?.progress }
    
    public weak var delegate: (any SessionTaskDelegate)?
    
    private let session: URLSession
    
    private let _request: URLRequest
    
    private var sessionTask: URLSessionTask?
    
    private var progressObservation: NSKeyValueObservation?
    
    // MARK: - Initialzer
    public init(
        session: URLSession,
        request: URLRequest
    ) {
        self.session = session
        self._request = request
    }
    
    // MARK: - Public
    public func resume(completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void) {
        let sessionTask = session.downloadTask(with: _request) { url, response, error in
            if let error {
                completion(.failure(error))
            } else if let url, let response {
                do {
                    let data = try Data(contentsOf: url)
                    completion(.success((data, response)))
                } catch {
                    completion(.failure(DysonError.failedToLoadData))
                }
            } else {
                completion(.failure(DysonError.unknown))
            }
        }
        
        progressObservation = observe(progress: sessionTask.progress)
        
        sessionTask.resume()
        
        self.sessionTask = sessionTask
    }
    
    public func cancel() {
        sessionTask?.cancel()
    }
    
    // MARK: - Private
}
