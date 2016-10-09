//
//  URLRequestError.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - URLRequestError

enum URLRequestError: Error, CustomDebugStringConvertible, ErrorMessageSender {
    case invalidURL(parameters: URLParameters)
    case invalidURLPath(path: String?)
    case invalidResponseStatus(code: Int)
    case couldNotParseJSON
}

// MARK: - CustomStringConvertible Conformance

extension URLRequestError {
    var description: String {
        switch self {
        case .invalidURL(_):                         return messagePrefix + "Invalid URL Request"
        case .invalidURLPath(path: let path):        return messagePrefix + "Invalid URL Path:\n" + String(describing: path)
        case .invalidResponseStatus(code: let code): return messagePrefix + "Invalid Response Code:\n" + String(code)
        case .couldNotParseJSON:                     return messagePrefix + "Invalid data"
        }
    }
}

// MARK: - CustomDebugStringConvertible Conformance

extension URLRequestError {
    var debugDescription: String {
        switch self {
        case .invalidURL(parameters: let parameters): return "ERROR: Invalid URL Request from parameters:\n" + String(describing: parameters)
        case .invalidURLPath(path: let path):         return "ERROR: Could not create `URLComponents` instance variable `path` with given path:\n" + String(describing: path)
        case .invalidResponseStatus(code: let code):  return "ERROR: Invalid Response Code:\n" + String(code)
        case .couldNotParseJSON:                      return "ERROR: Could not parse JSON DATA"
        }
    }
}





