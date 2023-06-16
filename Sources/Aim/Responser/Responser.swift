//
//  Responser.swift
//  
//
//  Created by jsilver on 2022/01/22.
//

import Foundation

public protocol Responser {
    func response<T: Target>(
        _ response: Result<(Data, URLResponse), any Error>,
        target: T
    ) throws -> T.Result
}
