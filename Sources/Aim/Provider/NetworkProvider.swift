//
//  NetworkProvider.swift
//
//
//  Created by JSilver on 2023/06/13.
//

import Foundation

public protocol NetworkProvider {
    func dataTask(
        with request: URLRequest,
        completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void
    ) -> any SessionTask
    func uploadTask(
        with request: URLRequest,
        from data: Data,
        completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void
    ) -> any SessionTask
    func downloadTask(
        with request: URLRequest,
        completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void
    ) -> any SessionTask
}

// MARK: - Extension
public extension NetworkProvider where Self == URLNetworkProvider {
    static func url(session: URLSession = .shared) -> Self { URLNetworkProvider(session: session) }
}
