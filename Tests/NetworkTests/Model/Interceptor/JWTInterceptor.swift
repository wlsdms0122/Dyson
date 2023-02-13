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
        _ response: Result<(Data, URLResponse), any Error>,
        provider: any NetworkProvider,
        target: some Target,
        sessionTask: TargetSessionTask,
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
        
        sessionTask {
            let authrefreshTarget = AuthRefreshTarget(.init())
            
            return NTNetworkResponser(provider: provider)
                .request(authrefreshTarget) {
                    switch $0 {
                    case let .success(result):
                        accessToken(result.accessToken)
                        
                        sessionTask {
                            provider.request(target) {
                                completion(.success($0))
                            }
                        }
                        
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
        }
    }
}
