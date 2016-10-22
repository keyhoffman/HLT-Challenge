//
//  Result.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - Result

enum Result<T>: ResultType { //, Equatable {
    typealias Value = T
    
    case value(Value)
    case error(Error)
    
    init(_ value: Value) { self = .value(value) }
    init(_ error: Error) { self = .error(error) }
}

extension Result {
    init(_ value: Value?, _ error: Error?) {
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
    
    func map<U>(_ f: (Value) -> U) -> Result<U> {
        return flatMap { .value(f($0)) }
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

//// MARK: - Equatable Conformance
//
//func == <U>(_ lhs: Result<U>, _ rhs: Result<U>) -> Bool where U: Equatable {
//    switch (lhs, rhs) {
//    case (.value(let a), .value(let b)): return a == b
//    case (.error, .value): return false
//    case (.value, .error): return false
//    case (.error, .error): return false
//    }
//}
