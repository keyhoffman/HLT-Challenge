//
//  CreationError.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

enum CreationError: Error, CustomDebugStringConvertible, ErrorMessageSender {
    case flickrImage
}

extension CreationError {
    var description: String {
        switch self {
        case .flickrImage: return messagePrefix + "Unable to retrieve photos!"
        }
    }
}

extension CreationError {
    var debugDescription: String {
        switch self {
        case .flickrImage: return "Invalid JSONDictionary"
        }
    }
}
