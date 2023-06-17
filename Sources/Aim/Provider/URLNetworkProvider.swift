//
//  URLNetworkProvider.swift
//
//
//  Created by JSilver on 2023/06/15.
//

import Foundation

public struct URLNetworkProvider: NetworkProvider {
    // MARK: - Property
    private let session: URLSession
    
    // MARK: - Initializer
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Lifecycle
    public func dataTask(
        with request: URLRequest,
        completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void
    ) -> any SessionTask {
        let sessionTask = session.dataTask(with: request) { data, response, error in
            let result: Result<(Data, URLResponse), any Error>
            if let error {
                result = .failure(error)
            } else if let data, let response {
                result = .success((data, response))
            } else {
                result = .failure(NetworkError.unknown)
            }
            
            completion(result)
        }
        
        sessionTask.resume()
        
        return DataSessionTask(request: request, sessionTask: sessionTask)
    }
    
    public func uploadTask(
        with request: URLRequest,
        from data: Data,
        completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void
    ) -> any SessionTask {
        let sessionTask = session.uploadTask(with: request, from: data) { data, response, error in
            let result: Result<(Data, URLResponse), any Error>
            if let error {
                result = .failure(error)
            } else if let data, let response {
                result = .success((data, response))
            } else {
                result = .failure(NetworkError.unknown)
            }
            
            completion(result)
        }
        
        sessionTask.resume()
        
        return DataSessionTask(request: request, sessionTask: sessionTask)
    }
    
    public func downloadTask(
        with request: URLRequest,
        completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void
    ) -> any SessionTask {
        fatalError()
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
