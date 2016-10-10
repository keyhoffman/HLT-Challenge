//
//  FatalError.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - FatalError

enum FatalError: Error, CustomDebugStringConvertible {
    case couldNotDequeueCell(identifier: String)
}

// MARK: - CustomDebugStringConvertible Conformance

extension FatalError {
    var debugDescription: String {
        switch self {
        case let .couldNotDequeueCell(id): return "Failed to dequeue resuable cell with identifier:" + id
        }
    }
}
