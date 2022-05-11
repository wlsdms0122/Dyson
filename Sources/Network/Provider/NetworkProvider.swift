//
//  NetworkProvider.swift
//
//
//  Created by jsilver on 2022/01/09.
//

import Foundation
import Alamofire

open class NetworkProvider: NetworkProvidable {
    // MARK: - Property
    private let _session: Session
    private var session: URLSession { _session.session }
    
    public var defaultHeaders: HTTPHeaders
    public var interceptors: [Interceptor]
    
    // MARK: - Initializer
    public init(
        session: Session = AF,
        defaultHeaders: HTTPHeaders = [:],
        interceptors: [Interceptor] = []
    ) {
        self._session = session
        self.defaultHeaders = defaultHeaders
        self.interceptors = interceptors
    }
    
    // MARK: - Public
    @discardableResult
    public func request<T: Target>(
        _ target: T,
        progress: ((Progress) -> Void)? = nil,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionTask? {
        guard let url = URL(string: target.url) else {
            completion(nil, nil, NetworkError.invalidURL(target.url))
            return nil
        }
        
        do {
            // Make url request.
            var request = try target.request(url: url)
            // Method
            request.httpMethod = target.method.rawValue
            // Header
            request.allHTTPHeaderFields = defaultHeaders.merging(target.headers) { _, new in new }
            
            // Interceptors process request before send.
            request = interceptors.reduce(request) {
                $1.request($0, session: session, target: target)
            }
            
            // Perform request
            switch target.task {
            case .data:
                return dataTask(
                    target: target,
                    request: request,
                    progress: progress,
                    completion: completion
                )
                
            case .upload:
                fatalError("Upload task not implemented.")
//                return uploadTask(
//                    data: data,
//                    request: request,
//                    progress: progress,
//                    completion: completion
//                )
                
            case .download:
                fatalError("Download task not implemented.")
            }
        } catch {
            completion(nil, nil, error)
        }
        
        return nil
    }
    
    // MARK: - Private
    private func dataTask<T: Target>(
        target: T,
        request: URLRequest,
        progress: ((Progress) -> Void)?,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionTask? {
        return _session.request(request)
            .downloadProgress(closure: {
                progress?($0)
            })
            .response { [weak self] response in
                guard let self = self else {
                    completion(nil, nil, NetworkError.unknown)
                    return
                }
                
                // Interceptors process response before completion.
                self.interceptors.forEach {
                    $0.response(
                        response.response,
                        data: response.data,
                        error: response.error,
                        session: self.session,
                        target: target
                    )
                }
                
                completion(
                    response.data,
                    response.response,
                    response.error
                )
            }
            .task
    }
    
    private func uploadTask<T: Target>(
        target: T,
        data: Data,
        request: URLRequest,
        progress: ((Progress) -> Void)?,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionTask? {
        _session.upload(data, with: request)
            .uploadProgress {
                progress?($0)
            }
            .response { [weak self] response in
                guard let self = self else {
                    completion(nil, nil, NetworkError.unknown)
                    return
                }
                
                // Interceptors process response before completion.
                self.interceptors.forEach {
                    $0.response(
                        response.response,
                        data: response.data,
                        error: response.error,
                        session: self.session,
                        target: target
                    )
                }
                
                completion(
                    response.data,
                    response.response,
                    response.error
                )
            }
            .task
    }
}
