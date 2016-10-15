//
//  URLComponents.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/15/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - URLComponents Extension

extension URLComponents {
    init?(path: String?, scheme: String?, host: String?, queryItems: [URLQueryItem]) {
        self.init()
        guard let path = path else { return nil }
        self.path       = path
        self.scheme     = scheme
        self.host       = host
        self.queryItems = queryItems
    }
}
