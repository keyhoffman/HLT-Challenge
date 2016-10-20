//
//  Operators.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - MonadicPrecedence Group

precedencegroup MonadicPrecedenceLeft {
    associativity: left
    lowerThan:     LogicalDisjunctionPrecedence
    higherThan:    AssignmentPrecedence
}

precedencegroup ApplicativePrecedence {
    associativity: left
    higherThan:    LogicalConjunctionPrecedence
    lowerThan:     NilCoalescingPrecedence
}

// MARK: - Operator Declarations

infix operator >>- : MonadicPrecedenceLeft
infix operator <*> : ApplicativePrecedence


// MARK: - Operator Implementations

func >>- <A, B>(_ a: Result<A>, _ f: (A) -> Result<B>) -> Result<B> {
    return a.flatMap(f)
}

func >>- <A, B>(_ a: A?, _ f: (A) -> B?) -> B? {
    return a.flatMap(f)
}

func <*> <A, B>(_ f: ((A) -> B)?, _ a: A?) -> B? {
    return a.apply(f)
}

// MARK: - Non-Monadic Operators

precedencegroup PipePrecedenceLeft {
    associativity: left
    higherThan:    LogicalDisjunctionPrecedence
    lowerThan:     NilCoalescingPrecedence
}

precedencegroup PipePrecedenceRight {
    associativity: right
    higherThan:    LogicalDisjunctionPrecedence
    lowerThan:     NilCoalescingPrecedence
}

precedencegroup CompositionPrecedence {
    associativity: right
    higherThan:    BitwiseShiftPrecedence
}

infix operator •  : CompositionPrecedence
infix operator <| : PipePrecedenceLeft
infix operator |> : PipePrecedenceLeft

public func <| <A, B>(_ f: (A) -> B, _ a: A) -> B {
    return f(a)
}

public func |> <A, B>(_ a: A, _ f: (A) -> B) -> B {
    return f(a)
}

public func • <T, U, V>(f: @escaping (U) -> V, g: @escaping (T) -> U) -> (T) -> V {
    return compose(f, g)
}

public func compose<T, U, V>(_ f: @escaping (U) -> V, _ g: @escaping (T) -> U) -> (T) -> V {
    return { x in f(g(x)) }
}


