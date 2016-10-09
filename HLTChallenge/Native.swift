//
//  Native.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/8/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - Dictionary Addition

func +<A, B>(_ lhs: Dictionary<A,B>, _ rhs: Dictionary<A,B>) -> Dictionary<A,B> {
    var dict = lhs // FIXME: GIT RID OF THIS MUTABLE VARIABLE
    for (key, value) in rhs { // FIXME: GIT RID OF THIS FOR-LOOP
        dict.updateValue(value, forKey: key)
    }
    return dict
}
