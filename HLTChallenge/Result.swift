//
//  Result.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

protocol ResultType {
    associatedtype Value: ResultRepresentable
    
    func toOptional() -> Value?
    
    init(_ value: Value)
    init(_ error: Error)
    init(_ error: Error?, _ value: Value?)
}

enum Result<T: ResultRepresentable>: ResultType {
    typealias Value = T
    
    case value(Value)
    case error(Error)
    
    init(_ value: Value) { self = .value(value) }
    init(_ error: Error) { self = .error(error) }
}

extension Result {
    init(_ error: Error?, _ value: Value?) { 
             if let value = value { self = .value(value) }
        else if let error = error { self = .error(error) }
        else { self = curry(Result.init) <^> OptionalError.nonExistantValue(value) }
    }
}

extension Result {
    func flatMap<U>(_ f: (Value) -> Result<U>) -> Result<U> {
        switch self {
        case let .error(error): return .error(error)
        case let .value(value): return f(value)
        }
    }
}

extension Result {
    func toOptional() -> Value? {
        switch self {
        case .error(_):         return nil
        case .value(let value): return value
        }
    }
}
