//
//  OptionalError.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - OptionalError

enum OptionalError<T>: Error, CustomDebugStringConvertible, ErrorMessageSender {
    case nonExistantValue(T)
}

// MARK: - CustomStringConvertible Conformance

extension OptionalError {
    var description: String {
        switch self {
        case let .nonExistantValue(value): return messagePrefix + "No value exists for" + String(describing: value)
        }
    }
}

// MARK: - CustomDebugStringConvertible Conformance

extension OptionalError {
    var debugDescription: String {
        switch self {
        case .nonExistantValue: return "ERROR:" + description
        }
    }
}
