//
//  Operators.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - Applicative Operators

precedencegroup ApplicativePrecedence {
    associativity: left
    higherThan:    LogicalConjunctionPrecedence
    lowerThan:     NilCoalescingPrecedence
}

infix operator <*> : ApplicativePrecedence
infix operator <^> : ApplicativePrecedence

// MARK: Optional

func <^> <A, B>(_ f: (A) -> B, _ a: A?) -> B? {
    return a.map(f)
}

func <*> <A, B>(_ f: ((A) -> B)?, _ a: A?) -> B? {
    return a.apply(f)
}

// MARK: Result

func <^> <A, B>(_ f: (A) -> B, _ a: Result<A>) -> Result<B> {
    return a.map(f)
}

func <*> <A, B>(_ f: Result<(A) -> B>, _ a: Result<A>) -> Result<B> {
    return a.apply(f)
}

// MARK: Array

func <^> <A, B>(_ f: (A) -> B, _ `as`: [A]) -> [B] {
    return `as`.map(f)
}

func <*> <A, B>(_ fs: [(A) -> B], _ `as`: [A]) -> [B] {
    return `as`.apply(fs)
}

// MARK: - Monadic Operators

precedencegroup MonadicPrecedenceLeft {
    associativity: left
    lowerThan:     LogicalDisjunctionPrecedence
    higherThan:    AssignmentPrecedence
}

precedencegroup MonadicPrecedenceRight {
    associativity: left
    lowerThan:     LogicalDisjunctionPrecedence
    higherThan:    AssignmentPrecedence
}

infix operator >>- : MonadicPrecedenceLeft
infix operator -<< : MonadicPrecedenceRight
infix operator >-> : MonadicPrecedenceRight
infix operator <-< : MonadicPrecedenceLeft

// MARK: Optional

func >>- <A, B>(_ a: A?, _ f: (A) -> B?) -> B? {
    return a.flatMap(f)
}

func -<< <A, B>(_ f: (A) -> B?, _ a: A?) -> B? {
    return a.flatMap(f)
}

func >-> <A, B, C>(_ f: @escaping (A) -> B?, _ g: @escaping (B) -> C?) -> (A) -> C? {
    return { a in f(a) >>- g }
}

func <-< <A, B, C>(_ f: @escaping (B) -> C?, _ g: @escaping (A) -> B?) -> (A) -> C? {
    return { a in g(a) >>- f }
}

// MARK: Result

func >>- <A, B>(_ a: Result<A>, _ f: (A) -> Result<B>) -> Result<B> {
    return a.flatMap(f)
}

func -<< <A, B>(_ f: (A) -> Result<B>, _ a: Result<A>) -> Result<B> {
    return a.flatMap(f)
}

func >-> <A, B, C>(_ f: @escaping (A) -> Result<B>, _ g: @escaping (B) -> Result<C>) -> (A) -> Result<C> {
    return { a in f(a) >>- g }
}

func <-< <A, B, C>(_ f: @escaping (B) -> Result<C>, _ g: @escaping (A) -> Result<B>) -> (A) -> Result<C> {
    return { a in g(a) >>- f }
}

// MARK: Array

func >>- <A, B>(_ a: [A], _ f: (A) -> [B]) -> [B] {
    return a.flatMap(f)
}

// MARK: - Non-Monadic Operators

precedencegroup PipePrecedenceLeft {
    associativity: left
    higherThan:    ApplicativePrecedence
    lowerThan:     NilCoalescingPrecedence
}

precedencegroup PipePrecedenceRight {
    associativity: right
    higherThan:    LogicalDisjunctionPrecedence
    lowerThan:     NilCoalescingPrecedence
}

precedencegroup CompositionPrecedenceRight {
    associativity: right
    higherThan:    BitwiseShiftPrecedence
}

precedencegroup CompositionPrecedenceLeft {
    associativity: right
    higherThan:    BitwiseShiftPrecedence
}

infix operator <|  : PipePrecedenceLeft
infix operator |>  : PipePrecedenceLeft
infix operator <<| : CompositionPrecedenceRight
infix operator |>> : CompositionPrecedenceLeft

public func <| <A, B>(_ f: (A) -> B, _ a: A) -> B {
    return f(a)
}

public func |> <A, B>(_ a: A, _ f: (A) -> B) -> B {
    return f(a)
}

public func <<| <T, U, V>(_ f: @escaping (U) -> V, _ g: @escaping (T) -> U) -> (T) -> V {
    return compose(f, g)
}

public func |>> <T, U, V>(_ f: @escaping (T) -> U, _ g: @escaping (U) -> V) -> (T) -> V {
    return compose(g, f)
}

public func compose<T, U, V>(_ f: @escaping (U) -> V, _ g: @escaping (T) -> U) -> (T) -> V {
    return { x in f(g(x)) }
}


