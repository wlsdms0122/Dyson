//
//  Dyson.swift
//  
//
//  Created by jsilver on 2022/01/09.
//

import Foundation

open class Dyson {
    // MARK: - Property
    private let provider: any NetworkProvider
    
    public let defaultHeaders: HTTPHeaders
    public let interceptors: [any Interceptor]
    
    // MARK: - Initializer
    public init(
        provider: any NetworkProvider,
        defaultHeaders: HTTPHeaders = [:],
        interceptors: [any Interceptor] = []
    ) {
        self.provider = provider
        self.defaultHeaders = defaultHeaders
        self.interceptors = interceptors
    }
    
    // MARK: - Public
    @discardableResult
    open func response(
        _ spec: some Spec,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil,
        completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void
    ) -> any SessionTask {
        // Request network with spec.
        request(
            spec: spec,
            dyson: self,
            defaultHeaders: defaultHeaders,
            interceptors: interceptors,
            progress: progress,
            requestModifier: requestModifier
        ) { [weak self] task, response in
            guard let self else {
                completion(.failure(DysonError.unknown))
                return
            }
            
            // Handle response.
            self.response(
                response,
                task: task,
                spec: spec,
                dyson: self,
                interceptors: self.interceptors,
                completion: completion
            )
        }
    }
    
    @discardableResult
    open func data<S: Spec>(
        _ spec: S,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil,
        completion: @escaping (Result<S.Result, any Error>) -> Void
    ) -> any SessionTask {
        // Request network with spec.
        request(
            spec: spec,
            dyson: self,
            defaultHeaders: defaultHeaders,
            interceptors: interceptors,
            progress: progress,
            requestModifier: requestModifier
        ) { [weak self] task, response in
            guard let self else {
                completion(.failure(DysonError.unknown))
                return
            }
            
            // Handle response.
            self.response(
                response,
                task: task,
                spec: spec,
                dyson: self,
                interceptors: self.interceptors
            ) { [weak self] response in
                guard let self else {
                    completion(.failure(DysonError.unknown))
                    return
                }
                
                // Responser handle response.
                self.response(
                    response,
                    task: task,
                    spec: spec,
                    dyson: self,
                    interceptors: self.interceptors,
                    completion: completion
                )
            }
        }
    }
    
    // MARK: - Private
    private func request(
        spec: some Spec,
        dyson: Dyson,
        defaultHeaders: HTTPHeaders,
        interceptors: [any Interceptor],
        progress: ((Progress) -> Void)?,
        requestModifier: ((URLRequest) -> URLRequest)?,
        completion: @escaping (ContainerSessionTask, Result<(Data, URLResponse), any Error>) -> Void
    ) -> any SessionTask {
        // Create new container session task for current request.
        let task = ContainerSessionTask(progress: progress)
        
        // Make request.
        request(
            spec: spec,
            task: task,
            dyson: dyson,
            defaultHeaders: defaultHeaders,
            interceptors: interceptors,
            requestModifier: requestModifier
        ) { [weak self] result in
            guard let self else {
                completion(task, .failure(DysonError.unknown))
                return
            }
            
            switch result {
            case let .success(request):
                // Perform request
                let sessionTask = self.request(
                    request,
                    with: spec
                )

                task.addChild(sessionTask)
                
                sessionTask._resume { response in
                    completion(task, response)
                }
                
            case let .failure(error):
                // Pre-request failed.
                completion(task, .failure(error))
            }
        }
        
        return task
    }
    
    private func request(
        spec: some Spec,
        task: ContainerSessionTask,
        dyson: Dyson,
        defaultHeaders: HTTPHeaders,
        interceptors: [any Interceptor],
        requestModifier: ((URLRequest) -> URLRequest)?,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        guard let url = spec.url else {
            // Validate URL.
            completion(.failure(DysonError.invalidURL))
            return
        }
        
        do {
            // Make url request.
            var request = try spec.request(url: url)
            // Method
            request.httpMethod = spec.method.rawValue
            // Header
            request.allHTTPHeaderFields = defaultHeaders.merging(spec.headers) { _, new in new }
            
            // Traversal all request interceptors before request.
            intercept(
                interceptors,
                initialValue: request
            ) { interceptor, request, completion in
                interceptor.request(
                    request,
                    dyson: dyson,
                    spec: spec,
                    sessionTask: task,
                    continuation: .init(completion)
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
        with spec: some Spec
    ) -> any DataSessionTask {
        switch spec.transaction {
        case .data:
            return provider.dataTask(with: request)
            
        case let .upload(data):
            return provider.uploadTask(with: request, from: data)
            
        case .download:
            return provider.downloadTask(with: request)
        }
    }
    
    private func response(
        _ response: Result<(Data, URLResponse), any Error>,
        task: ContainerSessionTask,
        spec: some Spec,
        dyson: Dyson,
        interceptors: [any Interceptor],
        completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void
    ) {
        // Traversal all response interceptors after request.
        intercept(
            interceptors,
            initialValue: response
        ) { interceptor, response, completion in
            interceptor.response(
                response,
                dyson: dyson,
                spec: spec,
                sessionTask: task,
                continuation: .init(completion)
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
    
    private func response<S: Spec>(
        _ response: Result<(Data, URLResponse), any Error>,
        task: ContainerSessionTask,
        spec: S,
        dyson: Dyson,
        interceptors: [any Interceptor],
        completion: @escaping (Result<S.Result, any Error>) -> Void
    ) {
        guard let responser = spec.responser else {
            completion(.failure(DysonError.responserDoseNotExist))
            return
        }
        
        // Process network response through an reponser.
        let result: Result<S.Result, any Error>
        do {
            result = .success(try responser.response(response, spec: spec))
        } catch {
            result = .failure(error)
        }
        
        // Traversal all result interceptors.
        intercept(
            interceptors,
            initialValue: result
        ) { interceptor, response, completion in
            interceptor.result(
                response,
                dyson: dyson,
                spec: spec,
                sessionTask: task,
                continuation: .init(completion)
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
