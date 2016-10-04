//
//  Curry.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

/**
 These functions are an implementation of the `Curry` open-source library by Thoughtbot.
 For more information visit the Github repo at https://github.com/thoughtbot/Curry
 */

func curry<A, B>(_ f: @escaping (A) -> B) -> (A) -> B {
    return { a -> (B) in f(a) }
}

func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a -> (B) -> C in { b -> C in f(a, b) } }
}

func curry<A, B, C, D>(_ f: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> D {
    return { a -> (B) -> (C) -> D in { b -> (C) -> D in { c -> D in f(a, b, c) } } }
}

func curry<A, B, C, D, E>(_ f: @escaping (A, B, C, D) -> E) -> (A) -> (B) -> (C) -> (D) -> E {
    return { a -> (B) -> (C) -> (D) -> E in { b -> (C) -> (D) -> E in { c -> (D) -> E in { d -> E in f(a, b, c, d) } } } }
}

func curry<A, B, C, D, E, F>(_ f: @escaping (A, B, C, D, E) -> F) -> (A) -> (B) -> (C) -> (D) -> (E) -> F {
    return { a -> (B) -> (C) -> (D) -> (E) -> F in { b -> (C) -> (D) -> (E) -> F in { c -> (D) -> (E) -> F in { d -> (E) -> F in { e -> F in f(a, b, c, d, e) } } } } }
}

func curry<A, B, C, D, E, F, G>(_ function: @escaping (A, B, C, D, E, F) -> G) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> G {
    return { a -> (B) -> (C) -> (D) -> (E) -> (F) -> G in { b -> (C) -> (D) -> (E) -> (F) -> G in { c -> (D) -> (E) -> (F) -> G in { d -> (E) -> (F) -> G in { e -> (F) -> G in { f -> G in function(a, b, c, d, e, f) } } } } } }
}

func curry<A, B, C, D, E, F, G, H>(_ function: @escaping (A, B, C, D, E, F, G) -> H) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> H {
    return { a -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> H in { b -> (C) -> (D) -> (E) -> (F) -> (G) -> H in { c -> (D) -> (E) -> (F) -> (G) -> H in { d -> (E) -> (F) -> (G) -> H in { e -> (F) -> (G) -> H in { f -> (G) -> H in { g -> H in function(a, b, c, d, e, f, g) } } } } } } }
}
