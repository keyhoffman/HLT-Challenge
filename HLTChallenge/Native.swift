//
//  Native.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/8/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - Dictionary Addition

func + <A, B>(_ lhs: Dictionary<A, B>, _ rhs: Dictionary<A, B>) -> Dictionary<A, B> {
    guard let first = rhs.first else { return lhs }
    
    var newLeft  = lhs // FIXME: GET RID OF MUTABLE VARIABLES!!!!
    var newRight = rhs
    
    newLeft.updateValue(first.value, forKey: first.key)
    newRight[first.key] = nil
    
    return newLeft + newRight
}
