//
//  Result.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

enum Result<T> {
    typealias Value = T
    
    case value(Value)
    case error(Error)
    
    init(_ value: Value) { self = .value(value) }
    init(_ error: Error) { self = .error(error) }
}

extension Result {
    func flatMap<U>(_ f: (T) -> Result<U>) -> Result<U> {
        switch self {
        case let .error(error): return .error(error)
        case let .value(value): return f(value)
        }
    }
}
