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
    lowerThan:     LogicalDisjunctionPrecedence
    higherThan:    AssignmentPrecedence
}

infix operator <^> : CurryPrecedence

func <^> <A, B>(_ f: (A) -> B, _ a: A) -> B {
    return f(a)
}
