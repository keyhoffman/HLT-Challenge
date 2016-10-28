//
//  EmptyMakable.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/27/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

protocol EmptyMakeable {
    init()
}

extension EmptyMakeable {
    static var empty: Self {
        return Self()
    }
}

extension String:     EmptyMakeable {}
extension Dictionary: EmptyMakeable {}
extension Set:        EmptyMakeable {}
