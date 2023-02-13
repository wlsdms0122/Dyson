//
//  NTNetworkResponser.swift
//  
//
//  Created by jsilver on 2022/01/23.
//

import Foundation
import Network

struct NTNetworkResponser: NetworkResponser {
    // MARK: - Property
    let provider: NetworkProvider
    
    // MARK: - Initializer
    init(provider: NetworkProvider) {
        self.provider = provider
    }
    
    // MARK: - Lifecycle
    func response<T: Target>(
        target: T,
        result: Response,
        handler: (Result<T.Result, Error>) -> Void
    ) {
        switch result {
        case let .success((data, response)):
            guard let response = response as? HTTPURLResponse else {
                handler(.failure(NetworkError.unknown))
                return
            }
            
            guard (200..<300).contains(response.statusCode) else {
                handler(.failure(NetworkError.unknown))
                return
            }
            
            do {
                if let error = try? target.error.map(data) {
                    handler(.failure(error))
                } else {
                    let result = try target.result.map(data)
                    handler(.success(result))
                }
            } catch {
                handler(.failure(error))
            }
            
        case let .failure(error):
            handler(.failure(error))
        }
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
