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
    case couldNotUnwrapResult
}

// MARK: - CustomDebugStringConvertible Conformance

extension FatalError {
    var debugDescription: String {
        switch self {
        case .couldNotDequeueCell(let id): return "Failed to dequeue resuable cell with identifier:" + id
        case .couldNotUnwrapResult:        return "Attempted to unwrap a Result"
        }
    }
}
