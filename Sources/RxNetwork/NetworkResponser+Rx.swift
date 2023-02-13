//
//  NetworkResponser+Rx.swift
//  
//
//  Created by jsilver on 2022/02/01.
//

import Foundation
import Network
import RxSwift

public extension NetworkResponser {
    func request<T: Target>(
        _ target: T,
        sessionTask: (any TargetSessionTask)? = nil,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil
    ) -> Single<T.Result> {
        .create { emitter in
            let task = request(
                target,
                sessionTask: sessionTask,
                progress: progress,
                requestModifier: requestModifier
            ) {
                emitter($0)
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
