//
//  JWTInterceptor.swift
//  
//
//  Created by JSilver on 2022/10/30.
//

import Foundation
import Aim

struct JWTInterceptor: Interceptor {
    private let accessToken: (String) -> Void
    
    init(accessToken: @escaping (String) -> Void) {
        self.accessToken = accessToken
    }
    
    func response(
        _ response: Result<(Data, URLResponse), any Error>,
        aim: Aim,
        target: some Target,
        sessionTask: ContainerSessionTask,
        completion: @escaping (Result<Result<(Data, URLResponse), any Error>, any Error>) -> Void
    ) {
        guard case let .success((_, httpsResponse)) = response else {
            completion(.success(response))
            return
        }
        
        guard let httpResponse = httpsResponse as? HTTPURLResponse else {
            completion(.success(response))
            return
        }
        
        guard httpResponse.statusCode == 401 else {
            completion(.success(response))
            return
        }
        
        let retryCount = sessionTask.state["retryCount", to: Int.self] ?? 0
        guard retryCount < 2 else {
            completion(.failure(NetworkError.unknown))
            return
        }
        
        sessionTask.state["retryCount"] = retryCount + 1
        
        let authRefreshTarget = AuthRefreshTarget(.init())
        sessionTask.addChild(
            aim.response(authRefreshTarget) {
                    switch $0 {
                    case let .success(result):
                        accessToken(result.token)
                        
                        sessionTask.addChild(
                            aim.request(target) {
                                completion(.success($0))
                            }
                        )
                        
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
        )
    }
}
