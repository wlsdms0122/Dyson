//
//  URLNetworkProvider.swift
//
//
//  Created by jsilver on 2022/01/09.
//

//import Foundation
//
//open class URLNetworkProvider: Aim {
//    // MARK: - Property
//    private let session: URLSession
//    
//    public var defaultHeaders: HTTPHeaders
//    public var interceptors: [any Interceptor]
//    
//    // MARK: - Initializer
//    public init(
//        session: URLSession = .shared,
//        defaultHeaders: HTTPHeaders = [:],
//        interceptors: [any Interceptor] = []
//    ) {
//        self.session = session
//        self.defaultHeaders = defaultHeaders
//        self.interceptors = interceptors
//    }
//    
//    // MARK: - Public
//    @discardableResult
//    public func request<T: Target>(
//        _ target: T,
//        progress: ((Progress) -> Void)?,
//        requestModifier: ((URLRequest) -> URLRequest)?,
//        completion: @escaping (Response) -> Void
//    ) -> any SessionTask {
//        let task = ContainerSessionTask()
//        
//        let headers = defaultHeaders.merging(target.headers) { _, new in new }
//        
//        request(
//            task: task,
//            target: target,
//            headers: headers,
//            provider: self,
//            interceptors: interceptors,
//            progress: progress,
//            requestModifier: requestModifier
//        ) { [weak self] in
//            guard let self else { return }
//            
//            switch $0 {
//            case let .success(request):
//                // Perform request
//                switch target.transaction {
//                case .data:
//                    self.dataTask(
//                        task: task,
//                        target: target,
//                        request: request,
//                        provider: self,
//                        interceptors: self.interceptors,
//                        progress: progress
//                    ) {
//                        completion($0)
//                    }
//                    
//                case let .upload(data):
//                    self.uploadTask(
//                        task: task,
//                        target: target,
//                        data: data,
//                        request: request,
//                        provider: self,
//                        interceptors: self.interceptors,
//                        progress: progress
//                    ) {
//                        completion($0)
//                    }
//                    
//                case .download:
//                    fatalError("Download task not implemented.")
//                }
//                
//            case let .failure(error):
//                // Pre-request failed.
//                completion(.failure(error))
//            }
//        }
//        
//        return task
//    }
//    
//    // MARK: - Private
//    private func request(
//        task: ContainerSessionTask,
//        target: some Target,
//        headers: HTTPHeaders,
//        provider: any Aim,
//        interceptors: [any Interceptor],
//        progress: ((Progress) -> Void)?,
//        requestModifier: ((URLRequest) -> URLRequest)?,
//        completion: @escaping (Result<URLRequest, Error>) -> Void
//    ) {
//        guard let url = target.url else {
//            completion(.failure(NetworkError.invalidURL))
//            return
//        }
//        
//        do {
//            // Make url request.
//            var request = try target.request(url: url)
//            // Method
//            request.httpMethod = target.method.rawValue
//            // Header
//            request.allHTTPHeaderFields = headers
//            
//            TaskQueue(request) { queue in
//                interceptors.forEach { interceptor in
//                    queue.append { request, completion in
//                        interceptor.request(
//                            request,
//                            provider: provider,
//                            target: target,
//                            sessionTask: task,
//                            completion: {
//                                completion($0)
//                            }
//                        )
//                    }
//                }
//            } completion: {
//                switch $0 {
//                case var .success(request):
//                    // Modify the request after the interceptor job completes.
//                    request = requestModifier?(request) ?? request
//                    completion(.success(request))
//                    
//                case let .failure(error):
//                    completion(.failure(error))
//                }
//            }
//        } catch {
//            completion(.failure(error))
//        }
//    }
//    
//    private func dataTask(
//        task: ContainerSessionTask,
//        target: some Target,
//        request: URLRequest,
//        provider: any Aim,
//        interceptors: [any Interceptor],
//        progress: ((Progress) -> Void)?,
//        completion: @escaping (Response) -> Void
//    ) {
//        let sessionTask = session.dataTask(with: request) { data, response, error in
//            let result: Result<(Data, URLResponse), any Error>
//            if let error {
//                result = .failure(error)
//            } else if let data, let response {
//                result = .success((data, response))
//            } else {
//                result = .failure(NetworkError.unknown)
//            }
//            
//            // Interceptors process response before completion.
//            TaskQueue(result) { queue in
//                interceptors.forEach { interceptor in
//                    queue.append { response, completion in
//                        interceptor.response(
//                            response,
//                            provider: provider,
//                            target: target,
//                            sessionTask: task,
//                            completion: {
//                                completion($0)
//                            }
//                        )
//                    }
//                }
//            } completion: {
//                switch $0 {
//                case let .success(response):
//                    completion(response)
//                    
//                case let .failure(error):
//                    completion(.failure(error))
//                }
//            }
//        }
//        
//        task.addChild(
//            DataSessionTask(
//                request: request,
//                sessionTask: sessionTask
//            )
//        )
//        
//        sessionTask.resume()
//    }
//    
//    private func uploadTask<T: Target>(
//        task: ContainerSessionTask,
//        target: T,
//        data: Data,
//        request: URLRequest,
//        provider: any Aim,
//        interceptors: [any Interceptor],
//        progress: ((Progress) -> Void)?,
//        completion: @escaping (Response) -> Void
//    ) {
//        let sessionTask = session.uploadTask(with: request, from: data) { data, response, error in
//            let result: Result<(Data, URLResponse), any Error>
//            if let error {
//                result = .failure(error)
//            } else if let data, let response {
//                result = .success((data, response))
//            } else {
//                result = .failure(NetworkError.unknown)
//            }
//            
//            // Interceptors process response before completion.
//            TaskQueue(result) { queue in
//                interceptors.forEach { interceptor in
//                    queue.append { response, completion in
//                        interceptor.response(
//                            response,
//                            provider: provider,
//                            target: target,
//                            sessionTask: task,
//                            completion: {
//                                completion($0)
//                            }
//                        )
//                    }
//                }
//            } completion: {
//                switch $0 {
//                case let .success(response):
//                    completion(response)
//                    
//                case let .failure(error):
//                    completion(.failure(error))
//                }
//            }
//        }
//        
//        task.addChild(
//            DataSessionTask(
//                request: request,
//                sessionTask: sessionTask
//            )
//        )
//        
//        sessionTask.resume()
//    }
//}
