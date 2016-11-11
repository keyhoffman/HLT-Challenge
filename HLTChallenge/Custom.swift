//
//  Operators.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - Applicative Operators

precedencegroup ApplicativePrecedence { associativity: left higherThan: LogicalConjunctionPrecedence lowerThan: NilCoalescingPrecedence }

infix operator <*> : ApplicativePrecedence
infix operator <^> : ApplicativePrecedence

public func <^> <A, B>(_ f:           (A) -> B, _ xs: [A])       -> [B]       { return xs.map(f) }
public func <^> <A, B>(_ f:           (A) -> B, _ x:  A?)        -> B?        { return x.map(f) }
public func <^> <A, B>(_ f: @escaping (A) -> B, _ x:  Result<A>) -> Result<B> { return x.map(f) }

@discardableResult public func <^> <A, B>(_ xs: [A],       _ f:           (A) -> B) -> [B]       { return xs.map(f) }
@discardableResult public func <^> <A, B>(_ x:  A?,        _ f:           (A) -> B) -> B?        { return x.map(f) }
@discardableResult public func <^> <A, B>(_ x:  Result<A>, _ f: @escaping (A) -> B) -> Result<B> { return x.map(f) }

public func <*> <A, B>(_ fs: [(A) -> B],       _ xs: [A]) ->       [B]       { return xs.apply(fs) }
public func <*> <A, B>(_ f:  ((A) -> B)?,      _ x:  A?) ->        B?        { return x.apply(f) }
public func <*> <A, B>(_ f:  Result<(A) -> B>, _ x:  Result<A>) -> Result<B> { return x.apply(f) }

// MARK: - Monadic Operators

precedencegroup MonadicPrecedenceLeft  { associativity: left lowerThan: LogicalDisjunctionPrecedence higherThan: AssignmentPrecedence }
precedencegroup MonadicPrecedenceRight { associativity: left lowerThan: LogicalDisjunctionPrecedence higherThan: AssignmentPrecedence }

infix operator >>- : MonadicPrecedenceLeft
infix operator -<< : MonadicPrecedenceRight
infix operator >-> : MonadicPrecedenceRight
infix operator <-< : MonadicPrecedenceLeft

public func >>- <A, B>(_ xs: [A],       _ f: (A) -> [B]) ->       [B]       { return xs.flatMap(f) }
public func >>- <A, B>(_ x:  A?,        _ f: (A) -> B?) ->        B?        { return x.flatMap(f) }
public func >>- <A, B>(_ x:  Result<A>, _ f: (A) -> Result<B>) -> Result<B> { return x.flatMap(f) }

public func -<< <A, B>(_ f: (A) -> B?,        _ x: A?) ->        B?        { return x.flatMap(f) }
public func -<< <A, B>(_ f: (A) -> Result<B>, _ x: Result<A>) -> Result<B> { return x.flatMap(f) }

public func >-> <A, B, C>(_ f: @escaping (A) -> B?,        _ g: @escaping (B) -> C?) ->        (A) -> C?        { return { f($0) >>- g } }
public func >-> <A, B, C>(_ f: @escaping (A) -> Result<B>, _ g: @escaping (B) -> Result<C>) -> (A) -> Result<C> { return { f($0) >>- g } }

public func <-< <A, B, C>(_ f: @escaping (B) -> C?,        _ g: @escaping (A) -> B?) ->        (A) -> C?        { return { g($0) >>- f } }
public func <-< <A, B, C>(_ f: @escaping (B) -> Result<C>, _ g: @escaping (A) -> Result<B>) -> (A) -> Result<C> { return { g($0) >>- f } }

// MARK: - Non-Monadic Operators

precedencegroup PipePrecedenceLeft  { associativity: left  higherThan: ApplicativePrecedence        lowerThan: NilCoalescingPrecedence }
precedencegroup PipePrecedenceRight { associativity: right higherThan: LogicalDisjunctionPrecedence lowerThan: NilCoalescingPrecedence }

precedencegroup CompositionPrecedenceRight { associativity: right higherThan: BitwiseShiftPrecedence }
precedencegroup CompositionPrecedenceLeft  { associativity: right higherThan: BitwiseShiftPrecedence }

infix operator <|  : PipePrecedenceLeft
infix operator |>  : PipePrecedenceLeft
infix operator <<| : CompositionPrecedenceRight
infix operator |>> : CompositionPrecedenceLeft

public func <| <A, B>(_ f: (A) -> B, _ x: A) -> B { return f(x) }
public func |> <A, B>(_ x: A, _ f: (A) -> B) -> B { return f(x) }

public func <<| <T, U, V>(_ f: @escaping (U) -> V, _ g: @escaping (T) -> U) -> (T) -> V { return compose(f, g) }
public func |>> <T, U, V>(_ f: @escaping (T) -> U, _ g: @escaping (U) -> V) -> (T) -> V { return compose(g, f) }

public func compose<T, U, V>(_ f: @escaping (U) -> V, _ g: @escaping (T) -> U) -> (T) -> V { return { f(g($0)) } }
