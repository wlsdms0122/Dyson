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
        continuation: Continuation<Result<(Data, URLResponse), any Error>>
    ) {
        guard case let .success((_, httpsResponse)) = response else {
            continuation(response)
            return
        }
        
        guard let httpResponse = httpsResponse as? HTTPURLResponse else {
            continuation(response)
            return
        }
        
        guard httpResponse.statusCode == 401 else {
            continuation(response)
            return
        }
        
        let retryCount = sessionTask.state["retryCount", to: Int.self] ?? 0
        guard retryCount < 2 else {
            continuation(throwing: NetworkError.unknown)
            return
        }
        
        sessionTask.state["retryCount"] = retryCount + 1
        
        let authRefreshTarget = AuthRefreshTarget(.init())
        sessionTask {
            aim.request(authRefreshTarget) {
                switch $0 {
                case let .success(result):
                    accessToken(result.token)
                    
                    sessionTask {
                        aim.request(target) {
                            continuation($0)
                        }
                    }
                    
                case let .failure(error):
                    continuation(throwing: error)
                }
            }
        }
    }
}
