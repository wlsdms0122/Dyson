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
    func request<T: Target>(_ target: T) -> Single<T.Result> {
        .create { [weak self] emitter in
            let task = self?.request(target) { result in
                switch result {
                case let .success(result):
                    emitter(.success(result))
                    
                case let .failure(error):
                    emitter(.failure(error))
                }
            }
            
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
