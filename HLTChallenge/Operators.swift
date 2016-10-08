//
//  Operators.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

precedencegroup CurryPrecedence {
    associativity: left
    higherThan:    LogicalDisjunctionPrecedence
}

precedencegroup FlatMapPrecedence {
    associativity: left
    higherThan: DefaultPrecedence
}


infix operator <^> : CurryPrecedence
infix operator |>  : FlatMapPrecedence
infix operator >>= : FlatMapPrecedence


func <^> <A, B>(_ f: (A) -> B, _ a: A) -> B {
    return f(a)
}

func |> <T, U>(x: T, f: (T) -> U) -> U {
    return f(x)
}

func >>= <A, B>(a: Result<A>, f: (A) -> Result<B>) -> Result<B> {
    return a.flatMap(f)
}

func >>= <A, B>(a: A?, f: (A) -> B?) -> B? {
    return a.flatMap(f)
}

//func >>= <A, B>(a: A?, f: (A) -> Result<B>) -> Result<B> {
//    return a.toResult()
//}


