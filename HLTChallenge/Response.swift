//
//  Response.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

struct Response {
    let data:       Data
    let statusCode: Int
    
    init?(data: Data?, urlResponse: URLResponse?) {
        guard let data = data else { return nil }
        self.data  = data
        statusCode = (urlResponse as? HTTPURLResponse)?.statusCode ?? 500
    }
}
