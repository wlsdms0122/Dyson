//
//  URLSessionDataTask.swift
//
//
//  Created by JSilver on 2023/02/12.
//

import Foundation

public final class URLDataSessionTask: DataSessionTask {
    // MARK: - Property
    private let _request: URLRequest
    public var request: URLRequest? { _request }
    
    public var progress: Progress? { sessionTask?.progress }
    
    private let session: URLSession
    private var sessionTask: URLSessionTask?
    
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
                completion(.failure(DSError.unknown))
            }
        }
        
        sessionTask.resume()
        
        self.sessionTask = sessionTask
    }
    
    public func cancel() {
        sessionTask?.cancel()
    }
    
    // MARK: - Private
}

public final class URLUploadDataSessionTask: DataSessionTask {
    // MARK: - Property
    private let _request: URLRequest
    public var request: URLRequest? { _request }
    public var progress: Progress? { sessionTask?.progress }
    
    private let session: URLSession
    private var sessionTask: URLSessionTask?
    
    private let data: Data
    
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
                completion(.failure(DSError.unknown))
            }
        }
        
        sessionTask.resume()
        
        self.sessionTask = sessionTask
    }
    
    public func cancel() {
        sessionTask?.cancel()
    }
    
    // MARK: - Private
}

public final class URLDownloadDataSessionTask: DataSessionTask {
    // MARK: - Property
    private let _request: URLRequest
    public var request: URLRequest? { _request }
    public var progress: Progress? { sessionTask?.progress }
    
    private let session: URLSession
    private var sessionTask: URLSessionTask?
    
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
                    completion(.failure(DSError.failedToLoadData))
                }
            } else {
                completion(.failure(DSError.unknown))
            }
        }
        
        sessionTask.resume()
        
        self.sessionTask = sessionTask
    }
    
    public func cancel() {
        sessionTask?.cancel()
    }
    
    // MARK: - Private
}
