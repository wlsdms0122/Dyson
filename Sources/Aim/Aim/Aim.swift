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
    
    public let responser: any Responser
    
    public let defaultHeaders: HTTPHeaders
    public let interceptors: [any Interceptor]
    
    // MARK: - Initializer
    public init(
        provider: any NetworkProvider,
        responser: any Responser,
        defaultHeaders: HTTPHeaders = [:],
        interceptors: [any Interceptor] = []
    ) {
        self.provider = provider
        self.responser = responser
        self.defaultHeaders = defaultHeaders
        self.interceptors = interceptors
    }
    
    // MARK: - Public
    @discardableResult
    open func request(
        _ spec: some Spec,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil,
        completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void
    ) -> any SessionTask {
        // Request network with spec.
        request(
            spec: spec,
            aim: self,
            defaultHeaders: defaultHeaders,
            interceptors: interceptors,
            requestModifier: requestModifier
        ) { [weak self] task, response in
            guard let self else {
                completion(.failure(NetworkError.unknown))
                return
            }
            
            // Handle response.
            self.response(
                response,
                task: task,
                spec: spec,
                aim: self,
                interceptors: self.interceptors,
                completion: completion
            )
        }
    }
    
    @discardableResult
    open func request<S: Spec>(
        _ spec: S,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil,
        completion: @escaping (Result<S.Result, any Error>) -> Void
    ) -> any SessionTask {
        // Request network with spec.
        request(
            spec: spec,
            aim: self,
            defaultHeaders: defaultHeaders,
            interceptors: interceptors,
            requestModifier: requestModifier
        ) { [weak self] task, response in
            guard let self else {
                completion(.failure(NetworkError.unknown))
                return
            }
            
            // Handle response.
            self.response(
                response,
                task: task,
                spec: spec,
                aim: self,
                interceptors: self.interceptors
            ) { [weak self] response in
                guard let self else {
                    completion(.failure(NetworkError.unknown))
                    return
                }
                
                // Responser handle response.
                self.response(
                    response,
                    responser: self.responser,
                    task: task,
                    spec: spec,
                    aim: self,
                    interceptors: self.interceptors,
                    completion: completion
                )
            }
        }
    }
    
    // MARK: - Private
    private func request(
        spec: some Spec,
        aim: Aim,
        defaultHeaders: HTTPHeaders,
        interceptors: [any Interceptor],
        requestModifier: ((URLRequest) -> URLRequest)?,
        completion: @escaping (any SessionTask, Result<(Data, URLResponse), any Error>) -> Void
    ) -> any SessionTask {
        // Create new container session task for current request.
        let task = ContainerSessionTask()
        
        // Make request.
        request(
            spec: spec,
            task: task,
            aim: aim,
            defaultHeaders: defaultHeaders,
            interceptors: interceptors,
            requestModifier: requestModifier
        ) { [weak self] result in
            guard let self else {
                completion(task, .failure(NetworkError.unknown))
                return
            }
            
            switch result {
            case let .success(request):
                // Perform request
                task {
                    self.request(request, with: spec) { response in
                        completion(task, response)
                    }
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
        task: any SessionTask,
        aim: Aim,
        defaultHeaders: HTTPHeaders,
        interceptors: [any Interceptor],
        requestModifier: ((URLRequest) -> URLRequest)?,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        guard let url = spec.url else {
            // Validate URL.
            completion(.failure(NetworkError.invalidURL))
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
                    aim: aim,
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
        with spec: some Spec,
        completion: @escaping (Result<(Data, URLResponse), any Error>) -> Void
    ) -> SessionTask {
        switch spec.transaction {
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
        task: any SessionTask,
        spec: some Spec,
        aim: Aim,
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
                aim: aim,
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
        responser: any Responser,
        task: any SessionTask,
        spec: S,
        aim: Aim,
        interceptors: [any Interceptor],
        completion: @escaping (Result<S.Result, any Error>) -> Void
    ) {
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
                aim: aim,
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
