//
//  Result.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - Result

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
        else { self = Result.init <| OptionalError.nonExistantValue(ofType: value) }
    }
}

extension Result {
    func flatMap<U>(_ f: (Value) -> Result<U>) -> Result<U> {
        switch self {
        case let .error(error): return .error(error)
        case let .value(value): return f(value)
        }
    }
    
//    func apply<U>(_ f: Result<(Value) -> U>) -> Result<U> {
//        return <#value#>
//    }
}

extension Result {
    func toOptional() -> Value? {
        switch self {
        case .error:            return nil
        case .value(let value): return value
        }
    }
}

extension Result {
    func unwrap() -> Value {
        switch self {
        case .error:            fatalError(FatalError.couldNotUnwrapResult.debugDescription)
        case .value(let value): return value
        }
    }
}

