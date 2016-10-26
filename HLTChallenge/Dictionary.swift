//
//  Dictionary.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/10/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - Dictionary Extension

extension Dictionary {
    static var empty: Dictionary {
        return [:]
    }
}

//extension Dictionary: Hashable {
//    public var hashValue: Int {
//        return keys.map { $0.hashValue }.reduce(0, ^)
//    }
//}
//
//// MARK: - Equatable Conformance
//
//public func == <A, B>(_ lhs: Dictionary<A, B>, _ rhs: Dictionary<A, B>) -> Bool {
//    return lhs.hashValue == rhs.hashValue
//}
