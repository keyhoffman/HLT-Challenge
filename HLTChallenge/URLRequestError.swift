//
//  URLRequestError.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

enum URLRequestError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    case invalidURL(parameters: URLParameters)
    
}

extension URLRequestError {
    var description: String {
        switch self {
        case .invalidURL(parameters: _): return "Invalid URL Request"
        }
    }
}

extension URLRequestError {
    var debugDescription: String {
        switch self {
        case .invalidURL(parameters: let params): return "ERROR: Invalid URL Request from parameters\n" + String(describing: params)
        }
    }
}





