//
//  EmptyMakable.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/27/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

protocol EmptyInitializable {
    init()
}

extension EmptyInitializable {
    static var empty: Self {
        return Self()
    }
}

extension String:     EmptyInitializable {}
extension Dictionary: EmptyInitializable {}
extension Set:        EmptyInitializable {}
