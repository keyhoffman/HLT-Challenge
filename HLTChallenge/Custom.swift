//
//  Operators.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - CurryPrecedence Group

precedencegroup CurryPrecedence {
    associativity: left
    higherThan:    LogicalDisjunctionPrecedence
    lowerThan:     NilCoalescingPrecedence
}

// MARK: - MonadicPrecedence Group

precedencegroup MonadicPrecedence {
    associativity: left
    higherThan:    DefaultPrecedence
}

// MARK: - Operator Declarations

infix operator <^> : CurryPrecedence
infix operator >>- : MonadicPrecedence
infix operator <*> : MonadicPrecedence

// MARK: - Operator Implementations


/// (A -> B, A) -> B
func <^> <A, B>(_ f: (A) -> B, _ a: A) -> B {
    return f(a)
}

/// (Result<A>, A -> Result<B>) -> Result<B>
func >>- <A, B>(_ a: Result<A>, _ f: (A) -> Result<B>) -> Result<B> { // >>>
    return a.flatMap(f)
}

/// (A, A -> B?) -> B?
func >>- <A, B>(_ a: A?, _ f: (A) -> B?) -> B? { // >>>
    return a.flatMap(f)
}

/// ((A -> B)?, A?) -> B?
func <*> <A, B>(_ f: ((A) -> B)?, _ a: A?) -> B? {
    guard let x = a, let fx = f else { return nil }
    return fx(x)
}

