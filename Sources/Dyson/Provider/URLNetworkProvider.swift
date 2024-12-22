//
//  URLNetworkProvider.swift
//
//
//  Created by JSilver on 2023/06/15.
//

import Foundation

open class URLNetworkProvider: NetworkProvider {
    // MARK: - Property
    private let session: URLSession
    
    // MARK: - Initializer
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Lifecycle
    open func dataTask(with request: URLRequest) -> any DataSessionTask {
        URLDataSessionTask(session: session, request: request)
    }
    
    open func uploadTask(with request: URLRequest, from data: Data) -> any DataSessionTask {
        URLUploadSessionTask(session: session, request: request, data: data)
    }
    
    open func downloadTask(with request: URLRequest) -> any DataSessionTask {
        URLDownloadSessionTask(session: session, request: request)
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
