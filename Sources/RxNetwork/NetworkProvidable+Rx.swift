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
    func request(_ target: some Target) -> Single<(Data, URLResponse)> {
        .create { [weak self] emitter in
            let task = self?.request(target) {
                emitter($0)
            }
            
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
