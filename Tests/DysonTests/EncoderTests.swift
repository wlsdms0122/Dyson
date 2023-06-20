//
//  EncoderTests.swift
//
//
//  Created by JSilver on 2023/06/20.
//

import XCTest
@testable import Dyson

final class EncoderTests: XCTestCase {
    // MARK: - Property
    
    // MARK: - Lifecycle
    override func setUp() { }
    
    override func tearDown() { }
    
    // MARK: - Test
    func test_that_none_encoder_succeed_in_encoding_with_data() async throws {
        // Given
        let data = "dyson".data(using: .utf8)!
        let sut: Encoder<Data> = .none
        
        // When
        let encodedData = try sut.encode(data)
        
        // Then
        XCTAssertEqual(encodedData, data)
    }
    
    func test_that_codable_encoder_succeed_in_encoding_with_encodable_data() async throws {
        // Given
        let person = Person(name: "dyson")
        let sut: Encoder<Person> = .codable
        
        // When
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(person)
        
        let encodedData = try sut.encode(person)
        
        // Then
        XCTAssertEqual(encodedData, data)
    }
}
