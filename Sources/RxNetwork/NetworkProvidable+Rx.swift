//
//  NetworkProvidable+Rx.swift
//  
//
//  Created by jsilver on 2022/01/31.
//

import Foundation
import Network
import RxSwift

public extension NetworkProvidable {
    func request<T: Target>(_ target: T) -> Single<(Data?, URLResponse?)> {
        .create { [weak self] emitter in
            let task = self?.request(target) { data, response, error in
                if let error = error {
                    emitter(.failure(error))
                    return
                }
                
                emitter(.success((data, response)))
            }
            
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
