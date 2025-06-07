//
//  NetworkProvider.swift
//
//
//  Created by JSilver on 2023/06/13.
//

import Foundation

public protocol NetworkProvider: Sendable {
    func dataTask(with request: URLRequest) -> any DataSessionTask
    func uploadTask(with request: URLRequest, from data: Data) -> any DataSessionTask
    func downloadTask(with request: URLRequest) -> any DataSessionTask
}

// MARK: - Extension
public extension NetworkProvider where Self == URLNetworkProvider {
    static func url(session: URLSession = .shared) -> Self { URLNetworkProvider(session: session) }
}
