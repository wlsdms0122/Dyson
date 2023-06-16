//
//  NetworkTests.swift
//
//
//  Created by jsilver on 2021/06/06.
//

import XCTest
@testable import Aim

final class NetworkTests: XCTestCase {
    // MARK: - Property
    private var accessToken: String?
    
    private lazy var aim = Aim(
        provider: .url(),
        interceptors: [
            AuthorizationInterceptor { [weak self] in
                guard let accessToken = self?.accessToken else { return nil }
                return "Bearer \(accessToken)"
            },
            LogInterceptor(),
            JWTInterceptor { [weak self] in
                self?.accessToken = $0
            }
        ],
        responser: NTResponser()
    )
    
    // MARK: - Lifecycle
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Test
    func test_that_nested_target() async throws {
        // Given
        let expectation = expectation(description: "")
        let target = AuthPingTarget(.init())
        
        // When
        let task = aim.request(target) {
            switch $0 {
            case .success((_, _)):
                expectation.fulfill()
             
            case .failure:
                assertionFailure()
            }
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 3)
    }
    
    func test_that_network() async throws {
        // Given
        guard let url = Bundle.module.url(forResource: "cat", withExtension: "jpg") else {
            XCTFail("Fail to load resource data.")
            return
        }
        
        let data = try Data(contentsOf: url)
        
        let uploadTarget = UploadTarget(.init(data: data))
        
        // When
        let _ = try await aim.request(uploadTarget)
        
        // Then
    }
}
