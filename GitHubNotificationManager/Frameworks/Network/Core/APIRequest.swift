//
//  APIRequest.swift
//  GitHubNotificationManager
//
//  Created by Yudai.Hirose on 2019/06/05.
//  Copyright © 2019 bannzai. All rights reserved.
//

import Foundation

public protocol APIRequest {
    associatedtype Response
    
    var host: String { get }
    var path: URLPathConvertible { get }
    var authorizationHeader: AuthorizationHeader? { get }
    var query: Query? { get }
    var header: HTTPHeader? { get }
    var body: HTTPBody? { get }
    var method: HTTPMethod { get }
}

public extension APIRequest {
    func urlRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        header?.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        authorizationHeader.map {
            request.setValue($0.header, forHTTPHeaderField: "Authorization")
        }
        
        if let (data, type) = try body?.body() {
            request.httpBody = data
            request.setValue(type, forHTTPHeaderField: "Content-Type")
        }
        
        return request as URLRequest
    }
    
    var url: URL {
        let encodedQuery = query?.urlEncoded ?? ""
        let queryString = encodedQuery.isEmpty ? "" : "?" + encodedQuery
        let urlString = "https://\(host)/\(path.urlPath)\(queryString)"
        return URL(string: urlString)!
    }
}