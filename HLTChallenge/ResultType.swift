//
//  ResultType.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/8/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - ResultType Protocol

protocol ResultType {
    associatedtype Value: ResultRepresentable
    
    func toOptional() -> Value?
    func flatMap(_ f: (Value) -> Self) -> Self
    
    init(_ value: Value)
    init(_ error: Error)
    init(_ error: Error?, _ value: Value?)
}
