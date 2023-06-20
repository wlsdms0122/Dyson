//
//  URLNetworkProvider.swift
//
//
//  Created by JSilver on 2023/06/15.
//

import Foundation

public class URLNetworkProvider: NetworkProvider {
    // MARK: - Property
    private let session: URLSession
    
    // MARK: - Initializer
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Lifecycle
    public func dataTask(with request: URLRequest) -> any DataSessionTask {
        URLDataSessionTask(session: session, request: request)
    }
    
    public func uploadTask(with request: URLRequest, from data: Data) -> any DataSessionTask {
        URLUploadSessionTask(session: session, request: request, data: data)
    }
    
    public func downloadTask(with request: URLRequest) -> any DataSessionTask {
        fatalError()
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
