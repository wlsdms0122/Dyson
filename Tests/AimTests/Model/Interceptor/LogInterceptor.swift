//
//  LogInterceptor.swift
//  
//
//  Created by jsilver on 2022/01/31.
//

import Foundation
import Aim

struct LogInterceptor: Interceptor {
    // MARK: - Property
    
    // MARK: - Initializer
    init() { }
    
    // MARK: - Lifeycle
    func request(
        _ request: URLRequest,
        aim: Aim,
        target: some Target,
        sessionTask: ContainerSessionTask,
        continuation: Continuation<URLRequest>
    ) {
        print("""
            
            📮 Request
               URL         : \(request.url?.absoluteString ?? "[\(target.url as Any)]")
               METHOD      : \(request.httpMethod ?? "[\(target.method.rawValue)]")
               HEADERS     : \(printPretty(request.allHTTPHeaderFields ?? [:], start: 3, indent: 2))
               BODY        :
                 \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "unknown")
            
            """
        )
        
        continuation(request)
    }
    
    func response(
        _ response: Result<(Data, URLResponse), any Error>,
        aim: Aim,
        target: some Target,
        sessionTask: ContainerSessionTask,
        continuation: Continuation<Result<(Data, URLResponse), any Error>>
    ) {
        var data: Data?
        var httpResponse: HTTPURLResponse?
        var error: Error?
        
        do {
            let (d, r) = try response.get()
            data = d
            httpResponse = r as? HTTPURLResponse
        } catch let e {
            error = e
        }
        
        print("""
            
            📭 Response
               URL         : \(httpResponse?.url?.absoluteString ?? "[\(target.url as Any)]")
               STATUS CODE : \((httpResponse?.statusCode ?? -1))
               HEADERS     : \(printPretty(httpResponse?.allHeaderFields ?? [:], start: 3, indent: 2))
               DATA        :
                 \(String(data: data ?? Data(), encoding: .utf8) ?? "unknown")
               ERROR       : \(String(describing: error))
            
            """
        )
        
        continuation(response)
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func printPretty(_ dictionary: [AnyHashable: Any], start: Int, indent: Int) -> String {
        let string = dictionary.map { key, value -> String in
            var value = value
            if let dictionary = value as? [AnyHashable: Any] {
                value = printPretty(dictionary, start: start + indent, indent: indent)
            }
            
            let indent = String(repeating: " ", count: indent)
            return "\(indent)\(key): \(value)"
        }
            .map { "\(String(repeating: " ", count: start))\($0)" }
            .joined(separator: "\n")
        
        return "\n\(string)"
    }
}
