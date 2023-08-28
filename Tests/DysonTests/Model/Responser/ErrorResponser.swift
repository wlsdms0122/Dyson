//
//  ErrorResponser.swift
//
//
//  Created by jsilver on 2022/01/23.
//

import Foundation
import Dyson

extension Responser {
    static func error(_ error: any Error) -> Self where Self == ErrorResponser { ErrorResponser(error) }
}

struct ErrorResponser: Responser {
    // MARK: - Property
    private let error: any Error
    
    // MARK: - Initializer
    init(_ error: any Error) {
        self.error = error
    }
    
    // MARK: - Lifecycle
    func response<S: Spec>(
        _ response: Result<(Data, URLResponse), any Error>,
        spec: S
    ) throws -> S.Result {
        throw error
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
