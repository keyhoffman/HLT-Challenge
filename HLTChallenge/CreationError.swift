//
//  CreationError.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - CreationError

enum CreationError: Error, CustomDebugStringConvertible, ErrorMessageSender {
    case flickrPhotoMetadata
    case flickrPhoto(forURL: String)
}

// MARK: - CustomStringConvertible Conformance

extension CreationError {
    var description: String {
        switch self {
        case .flickrPhotoMetadata: return messagePrefix + "Unable to retrieve photos!"
        case .flickrPhoto(_):      return messagePrefix + "Unable to download photo"
        }
    }
}

// MARK: - CustomDebugStringConvertible Conformance

extension CreationError {
    var debugDescription: String {
        switch self {
        case .flickrPhotoMetadata:          return "ERROR: Invalid JSONDictionary"
        case .flickrPhoto(forURL: let url): return "ERROR: Unable to load photo for URL:\n" + url
        }
    }
}
