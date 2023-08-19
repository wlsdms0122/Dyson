//
//  MockNetworkProvider.swift
//
//
//  Created by JSilver on 2023/06/16.
//

import Foundation
import Dyson

extension NetworkProvider where Self == MockNetworkProvider {
    static func mock(
        dataTask: MockNetworkProvider.DataTaskHandler? = nil,
        uploadTask: MockNetworkProvider.UploadTaskHandler? = nil,
        downloadTask: MockNetworkProvider.DownloadTaskHandler? = nil
    ) -> Self {
        MockNetworkProvider(
            dataTask: dataTask,
            uploadTask: uploadTask,
            downloadTask: downloadTask
        )
    }
}

struct MockNetworkProvider: NetworkProvider {
    typealias DataTaskHandler = (URLRequest, @escaping (Result<(Data, URLResponse), any Error>) -> Void) -> Void
    typealias UploadTaskHandler = (URLRequest, Data, @escaping (Result<(Data, URLResponse), any Error>) -> Void) -> Void
    typealias DownloadTaskHandler = (URLRequest, @escaping (Result<(Data, URLResponse), any Error>) -> Void) -> Void
    
    private let _dataTask: DataTaskHandler?
    private let _uploadTask: UploadTaskHandler?
    private let _downloadTask: DownloadTaskHandler?
    
    init(
        dataTask: DataTaskHandler? = nil,
        uploadTask: UploadTaskHandler? = nil,
        downloadTask: DownloadTaskHandler? = nil
    ) {
        self._dataTask = dataTask
        self._uploadTask = uploadTask
        self._downloadTask = downloadTask
    }
    
    func dataTask(with request: URLRequest) -> any DataSessionTask {
        MockDataSessionTask(data: request) { data, completion in
            _dataTask?(data, completion)
        }
    }
    
    func uploadTask(with request: URLRequest, from data: Data) -> any DataSessionTask {
        MockDataSessionTask(data: (request, data)) { data, completion in
            _uploadTask?(data.0, data.1, completion)
        }
    }
    
    func downloadTask(with request: URLRequest) -> any DataSessionTask {
        MockDataSessionTask(data: (request)) { data, completion in
            _downloadTask?(data, completion)
        }
    }
}
