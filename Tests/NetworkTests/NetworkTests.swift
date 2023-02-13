//
//  NetworkTests.swift
//
//
//  Created by jsilver on 2021/06/06.
//

import XCTest
import UIKit
@testable import Network

final class NetworkTests: XCTestCase {
    // MARK: - Property
    private var accessToken: String?
    
    private lazy var networkResponser: any NetworkResponser = NTNetworkResponser(
        provider: URLNetworkProvider(
            interceptors: [
                LogInterceptor(),
                AuthorizationInterceptor { [weak self] in
                    guard let accessToken = self?.accessToken else { return nil }
                    return "Bearer \(accessToken)"
                },
                JWTInterceptor { [weak self] in
                    self?.accessToken = $0
                }
            ]
        )
    )
    
    // MARK: - Lifecycle
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Test
    func test_that_network() async throws {
        // Given
        let listTarget = ListTarget(.init())
        
        // When
        let _ = try await networkResponser.request(listTarget)
        
        // Then
    }
}
