//
//  NetworkTests.swift
//
//
//  Created by jsilver on 2021/06/06.
//

import XCTest
import Quick
import Nimble
@testable import Network

final class NetworkTests: QuickSpec {
    override func spec() {
        describe("NetworkResponser에") {
            let networkResponser: NetworkResponser = GitHubNetworkResponser(networkProvider: NetworkProvider())
            
            context("Target으로 요청하면") {
                let target = GitHubTarget(.init(id: "wlsdms0122"))
                
                it("응답값이 와야한다") {
                    // Given
                    
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
            }
        }
    }
}
