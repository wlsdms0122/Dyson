//
//  GitHubNetworkResponser.swift
//  
//
//  Created by jsilver on 2022/01/23.
//

import Foundation
import Network

class GitHubNetworkResponser: NetworkResponser {
    // MARK: - Property
    let networkProvider: NetworkProvidable
    
    // MARK: - Initializer
    init(networkProvider: NetworkProvidable) {
        self.networkProvider = networkProvider
    }
    
    // MARK: - Lifecycle
    func response<T: Target>(
        target: T,
        data: Data?,
        response: URLResponse?,
        error: Error?,
        handler: (Result<T.Result, Error>) -> Void
    ) {
        if let error = error {
            handler(.failure(error))
            return
        }
        
        guard let response = response as? HTTPURLResponse else {
            handler(.failure(NetworkError.emptyResponse))
            return
        }
        
        guard (200..<300).contains(response.statusCode) else {
            handler(.failure(NetworkError.invalidStatusCode(response.statusCode)))
            return
        }
        
        guard let data = data else {
            handler(.failure(NetworkError.emptyData))
            return
        }
        
        do {
            let result = try target.result.map(data)
            handler(.success(result))
        } catch {
            handler(.failure(error))
        }
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
