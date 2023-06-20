//
//  DefaultResponser.swift
//
//
//  Created by jsilver on 2022/01/23.
//

import Foundation
import Dyson

extension Responser where Self == DefaultResponser {
    static var `default`: Self { DefaultResponser() }
}

struct DefaultResponser: Responser {
    // MARK: - Property
    
    // MARK: - Initializer
    
    // MARK: - Lifecycle
    func response<S: Spec>(
        _ response: Result<(Data, URLResponse), any Error>,
        spec: S
    ) throws -> S.Result {
        switch response {
        case let .success((data, _)):
            do {
                if let error = try? spec.error.map(data) {
                    throw error
                } else {
                    return try spec.result.map(data)
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
