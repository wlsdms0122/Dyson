//
//  Responser.swift
//  
//
//  Created by jsilver on 2022/01/22.
//

import Foundation

public protocol Responser: Sendable {
    func response<S: Spec>(
        _ response: Result<(Data, URLResponse), any Error>,
        spec: S
    ) throws -> S.Result
}
