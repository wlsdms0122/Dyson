//
//  JWTInterceptor.swift
//  
//
//  Created by JSilver on 2022/10/30.
//

import Foundation
import Network

struct JWTInterceptor: Interceptor {
    private let accessToken: (String) -> Void
    
    init(accessToken: @escaping (String) -> Void) {
        self.accessToken = accessToken
    }
    
    func response(
        _ response: Response,
        provider: any NetworkProvider,
        target: some Target,
        sessionTask: any TargetSessionTask,
        completion: @escaping (Result<Response, any Error>) -> Void
    ) {
        guard case let .success((data, _)) = response else {
            completion(.success(response))
            return
        }
        
        guard let error = (try? target.error.map(data)) as? NTError else {
            completion(.success(response))
            return
        }
        
        guard error.code == "NT5001" else {
            completion(.success(response))
            return
        }
        
        let retryCount = sessionTask.state(
            forKey: "retryCount",
            to: Int.self
        ) ?? 0
        
        guard retryCount == 0 else {
            completion(.failure(NetworkError.unknown))
            return
        }
        
        sessionTask.setState(retryCount + 1, forKey: "retryCount")
        let authrefreshTarget = AuthRefreshTarget(.init())
        
        NTNetworkResponser(provider: provider)
            .request(authrefreshTarget, sessionTask: sessionTask) {
                switch $0 {
                case let .success(result):
                    accessToken(result.accessToken)
                    
                    provider.request(target, sessionTask: sessionTask) {
                        completion(.success($0))
                    }
                    
                case let .failure(error):
                    completion(.failure(error))
                }
            }
    }
}
