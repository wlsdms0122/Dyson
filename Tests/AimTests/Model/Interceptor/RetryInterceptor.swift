//
//  RetryInterceptor.swift
//
//
//  Created by JSilver on 2023/06/13.
//

import Foundation
import Aim

//struct RetryInterceptor: Interceptor {
//    func response(
//        _ response: Aim.Response<(Data, URLResponse)>,
//        aim: Aim,
//        target: some Target,
//        sessionTask: ContainerSessionTask,
//        completion: @escaping (Result<Aim.Response<(Data, URLResponse)>, any Error>) -> Void
//    ) {
//        guard case .failure = response else {
//            completion(.success(response))
//            return
//        }
//        
//        let retryCount = sessionTask.state["retryCount", to: Int.self] ?? 0
//        guard retryCount < 3 else {
//            completion(.failure(NetworkError.unknown))
//            return
//        }
//        
//        sessionTask.state["retryCount"] = retryCount + 1
//        
//        sessionTask.addChild(
//            aim.request(target) {
//                completion(.success($0))
//            }
//        )
//    }
//}
