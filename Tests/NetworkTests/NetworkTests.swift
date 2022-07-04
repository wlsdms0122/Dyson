//
//  NetworkTests.swift
//
//
//  Created by jsilver on 2021/06/06.
//

import Quick
import Nimble
@testable import Network

@MainActor
final class NetworkTests: QuickSpec {
    override func spec() {
        describe("NetworkResponser에") {
            let networkResponser: NetworkResponser = GitHubNetworkResponser(
                networkProvider: NetworkProvider()
            )
            
            context("Target으로 요청하면") {
                it("closure로 응답값이 와야한다") {
                    // Given
                    let target = GitHubTarget(.init(id: "wlsdms0122"))
                    
                    // When
                    
                    // Then
                    waitUntil { done in
                        networkResponser.request(target) { result in
                            switch result {
                            case .success:
                                break
                                
                            case .failure:
                                fail()
                            }
                            
                            done()
                        }
                    }
                }
                
                it ("await으로 응답값이 와야한다") {
                    // Given
                    let target = GitHubTarget(.init(id: "wlsdms0122"))
                    
                    // When
                    
                    // Then
                    waitUntil { done in
                        _Concurrency.Task {
                            do {
                                try await networkResponser.request(target)
                                done()
                            } catch {
                                fail()
                            }
                        }
                            
                    }
                }
            }
        }
    }
}
