//
//  WatchingsRequest.swift
//  GitHubNotificationManager
//
//  Created by Yudai.Hirose on 2019/09/30.
//  Copyright © 2019 bannzai. All rights reserved.
//

import Foundation
 
public struct WatchingsRequest: GitHubAPIRequest {
    public var path: URLPathConvertible { ["user/subscriptions"] }
    public var method: HTTPMethod { .GET }
    public typealias Response = [WatchingElement]
    public var query: Query? { ["per_page": Self.perPage] }
    
    public static let perPage = 1000 // FIXME: All pages
    public init() { }
}