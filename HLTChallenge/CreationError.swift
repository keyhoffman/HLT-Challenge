//
//  CreationError.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - CreationError

enum CreationError {
    
    enum Flickr: Error, CustomDebugStringConvertible, ErrorMessageSender {
        case metadata
        case comment
        case photo(forURL: String)
    }
}

// MARK: - CustomStringConvertible Conformance

extension CreationError.Flickr {
    var description: String {
        switch self {
        case .metadata: return messagePrefix + "Unable to retrieve photos!"
        case .comment:  return messagePrefix + "Unable to load comments!"
        case .photo:    return messagePrefix + "Unable to download photo"
        }
    }
}

// MARK: - CustomDebugStringConvertible Conformance

extension CreationError.Flickr {
    var debugDescription: String {
        switch self {
        case .metadata:       return "ERROR: Invalid JSONDictionary for type FlickrPhotoMetadata"
        case .comment:        return "ERROR: Invalid JSONDictionary for type FlickrPhotoComment"
        case .photo(let url): return "ERROR: Unable to load photo for URL:\n" + url
        }
    }
}
