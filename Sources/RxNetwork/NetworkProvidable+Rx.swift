//
//  NetworkProvidable+Rx.swift
//  
//
//  Created by jsilver on 2022/01/31.
//

import Foundation
import Network
import RxSwift

public extension NetworkProvider {
    func request(
        _ target: some Target,
        sessionTask: (any TargetSessionTask)? = nil,
        progress: ((Progress) -> Void)? = nil,
        requestModifier: ((URLRequest) -> URLRequest)? = nil
    ) -> Single<(Data, URLResponse)> {
        .create { [weak self] emitter in
            let task = self?.request(
                target,
                sessionTask: sessionTask,
                progress: progress,
                requestModifier: requestModifier
            ) {
                emitter($0)
            }
            
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
