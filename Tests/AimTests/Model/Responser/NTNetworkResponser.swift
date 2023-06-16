//
//  NTNetworkResponser.swift
//  
//
//  Created by jsilver on 2022/01/23.
//

import Foundation
import Aim

struct NTResponser: Responser {
    // MARK: - Property
    
    // MARK: - Initializer
    
    // MARK: - Lifecycle
    func response<T: Target>(
        _ response: Result<(Data, URLResponse), any Error>,
        target: T
    ) throws -> T.Result {
        switch response {
        case let .success((data, _)):
            do {
                if let error = try? target.error.map(data) {
                    throw error
                } else {
                    return try target.result.map(data)
                }
            } catch {
                throw error
            }
            
        case let .failure(error):
            throw error
        }
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
