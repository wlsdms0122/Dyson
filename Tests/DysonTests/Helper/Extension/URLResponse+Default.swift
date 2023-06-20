//
//  URLResponse+Default.swift
//
//
//  Created by JSilver on 2023/06/17.
//

import Foundation

extension URLResponse {
    static func http(_ request: URLRequest, status: Int, headerField: [String: String]? = nil) -> URLResponse {
        guard let url = request.url else { return URLResponse() }
        return HTTPURLResponse(
            url: url,
            statusCode: status,
            httpVersion: nil,
            headerFields: headerField
        ) ?? URLResponse()
    }
}
