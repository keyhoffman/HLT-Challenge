//
//  Response.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - Response

struct Response: Equatable {
    let data:       Data
    let statusCode: Int
}

extension Response {
    init?(data: Data?, urlResponse: URLResponse?) {
        guard let data = data else { return nil }
        self.data  = data
        statusCode = (urlResponse as? HTTPURLResponse)?.statusCode ?? 500
    }
}

extension Response {
    static let successRange = 200..<300
}

// MARK: - Equatable Conformance

func == (_ lhs: Response, _ rhs: Response) -> Bool {
    return lhs.statusCode == rhs.statusCode && lhs.data == rhs.data
}
