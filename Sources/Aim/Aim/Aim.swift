//
//  Aim.swift
//  
//
//  Created by jsilver on 2022/01/09.
//

import Foundation

open class Aim {
    // MARK: - Property
    private let provider: any NetworkProvider
    
    open var defaultHeaders: HTTPHeaders
    open var interceptors: [any Interceptor]
    
    open var responser: any Responser
    
    // MARK: - Initializer
    public init(
        provider: any NetworkProvider,
        defaultHeaders: HTTPHeaders = [:],
        interceptors: [any Interceptor] = [],
        responser: any Responser
    ) {
        self.provider = provider
        self.defaultHeaders = defaultHeaders
        self.interceptors = interceptors
        self.responser = responser
    }
    
    // MARK: - Public
    @discardableResult
    open func request(
        _ target: some Target,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil,
        completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void
    ) -> any SessionTask {
        let task = ContainerSessionTask()
        
        request(
            task: task,
            target: target,
            aim: self,
            defaultHeaders: defaultHeaders,
            interceptors: interceptors,
            requestModifier: requestModifier
        ) { [weak self] result in
            guard let self else {
                completion(.failure(NetworkError.unknown))
                return
            }
            
            switch result {
            case let .success(request):
                // Perform request
                task {
                    self.request(request, with: target) { response in
                        self.response(
                            response,
                            task: task,
                            target: target,
                            aim: self,
                            interceptors: self.interceptors,
                            completion: completion
                        )
                    }
                }
                
            case let .failure(error):
                // Pre-request failed.
                completion(.failure(error))
            }
        }
        
        return task
    }
    
    @discardableResult
    open func response<T: Target>(
        _ target: T,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil,
        completion: @escaping (Result<T.Result, any Error>) -> Void
    ) -> any SessionTask {
        let responser = responser
        
        return request(
            target,
            progress: progress,
            requestModifier: requestModifier
        ) { response in
            do {
                let result = try responser.response(response, target: target)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private
    private func request(
        task: ContainerSessionTask,
        target: some Target,
        aim: Aim,
        defaultHeaders: HTTPHeaders,
        interceptors: [any Interceptor],
        requestModifier: ((URLRequest) -> URLRequest)?,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        guard let url = target.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        do {
            // Make url request.
            var request = try target.request(url: url)
            // Method
            request.httpMethod = target.method.rawValue
            // Header
            request.allHTTPHeaderFields = defaultHeaders.merging(target.headers) { _, new in new }
            
            intercept(
                interceptors,
                initialValue: request
            ) { interceptor, request, completion in
                interceptor.request(
                    request,
                    aim: aim,
                    target: target,
                    sessionTask: task,
                    completion: completion
                )
            } completion: { result in
                switch result {
                case var .success(request):
                    // Modify the request after the interceptor job completes.
                    request = requestModifier?(request) ?? request
                    completion(.success(request))
                    
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    private func request(
        _ request: URLRequest,
        with target: some Target,
        completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void
    ) -> SessionTask {
        switch target.transaction {
        case .data:
            return provider.dataTask(
                with: request,
                completion: completion
            )
            
        case let .upload(data):
            return provider.uploadTask(
                with: request,
                from: data,
                completion: completion
            )
            
        case .download:
            return provider.downloadTask(
                with: request,
                completion: completion
            )
        }
    }
    
    private func response(
        _ response: Result<(Data, URLResponse), any Error>,
        task: ContainerSessionTask,
        target: some Target,
        aim: Aim,
        interceptors: [any Interceptor],
        completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void
    ) {
        // Interceptors process response before completion.
        intercept(
            interceptors,
            initialValue: response
        ) { interceptor, response, completion in
            interceptor.response(
                response,
                aim: aim,
                target: target,
                sessionTask: task,
                completion: completion
            )
        } completion: { result in
            switch result {
            case let .success(response):
                completion(response)
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func response<T: Target>(
        _ response: Result<(Data, URLResponse), any Error>,
        responser: any Responser,
        task: ContainerSessionTask,
        target: T,
        aim: Aim,
        interceptors: [any Interceptor],
        completion: @escaping (Result<T.Result, any Error>) -> Void
    ) {
        let result: Result<T.Result, any Error>
        do {
            result = .success(try responser.response(response, target: target))
        } catch {
            result = .failure(error)
        }
            
        intercept(
            interceptors,
            initialValue: result
        ) { interceptor, response, completion in
            interceptor.data(
                response,
                aim: aim,
                target: target,
                sessionTask: task,
                completion: completion
            )
        } completion: { result in
            switch result {
            case let .success(response):
                completion(response)
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func intercept<Value>(
        _ interceptors: [any Interceptor],
        initialValue: Value,
        intercept: @escaping (any Interceptor, Value, @escaping (Result<Value, any Error>) -> Void) -> Void,
        completion: @escaping (Result<Value, Error>) -> Void
    ) {
        TaskQueue(initialValue) { queue in
            interceptors.forEach { interceptor in
                queue.append { value, completion in
                    intercept(interceptor, value, completion)
                }
            }
        } completion: { result in
            completion(result)
        }
    }
}

// MARK: - async/await
public extension Aim {
    @discardableResult
    func request(
        _ target: some Target,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil
    ) async throws -> (Data, URLResponse) {
        try await withUnsafeThrowingContinuation { continuation in
            request(
                target,
                progress: progress,
                requestModifier: requestModifier
            ) { result in
                switch result {
                case let .success(result):
                    continuation.resume(returning: result)
                    
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    @discardableResult
    func response<T: Target>(
        _ target: T,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil
    ) async throws -> T.Result {
        try await withUnsafeThrowingContinuation { continuation in
            response(
                target,
                progress: progress,
                requestModifier: requestModifier
            ) { result in
                switch result {
                case let .success(result):
                    continuation.resume(returning: result)
                    
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}