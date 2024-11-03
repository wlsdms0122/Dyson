//
//  Dyson+Helper.swift
//  
//
//  Created by JSilver on 2023/06/20.
//

import XCTest
import Dyson

extension XCTestCase {
    func request(
        spec: some Spec,
        dataTask: MockNetworkProvider.DataTaskHandler? = nil,
        uploadTask: MockNetworkProvider.UploadTaskHandler? = nil,
        downloadTask: MockNetworkProvider.DownloadTaskHandler? = nil,
        responser: any Responser = .default
    ) async throws -> (Data, URLResponse) {
        let dyson = Dyson(
            provider: .mock(
                dataTask: dataTask,
                uploadTask: uploadTask,
                downloadTask: downloadTask
            )
        )
        
        return try await dyson.response(spec)
    }
}
