//
//  URLRequestError.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

enum URLRequestError: Error, CustomDebugStringConvertible, ErrorMessageSender {
    case invalidURL(parameters: URLParameters)
    case invalidResponseStatus(code: Int)
    case couldNotParseJSON
}

extension URLRequestError {
    var description: String {
        switch self {
        case .invalidURL(parameters: _):             return messagePrefix + "Invalid URL Request"
        case .invalidResponseStatus(code: let code): return messagePrefix + "Invalid Response Code:\n" + String(code)
        case .couldNotParseJSON:                     return messagePrefix + "Invalid data"
        }
    }
}

extension URLRequestError {
    var debugDescription: String {
        switch self {
        case .invalidURL(parameters: let params):    return "ERROR: Invalid URL Request from parameters:\n" + String(describing: params)
        case .invalidResponseStatus(code: let code): return "ERROR: Invalid Response Code:\n" + String(code)
        case .couldNotParseJSON:                     return "ERROR: Could not parse JSON DATA"
        }
    }
}





