//
//  NetworkProvidable.swift
//  
//
//  Created by jsilver on 2022/01/09.
//

import Foundation

public protocol NetworkProvidable: AnyObject {
    @discardableResult
    func request<T: Target>(
        _ target: T,
        progress: ((Progress) -> Void)?,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionTask?
}

public extension NetworkProvidable {
    @discardableResult
    func request<T: Target>(
        _ target: T,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionTask? {
        request(target, progress: nil, completion: completion)
    }
}
