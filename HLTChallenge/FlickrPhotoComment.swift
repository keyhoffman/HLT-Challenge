//
//  FlickrPhotoComment.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/9/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - FlickrPhotoComment

struct FlickrPhotoComment: FlickrCollectionElement {
    let id:        String
    let ownerName: String
    let ownerID:   String
    let content:   String
}

// MARK: - FlickrAPIGetable Conformance

extension FlickrPhotoComment {
    static func create(from dict: JSONDictionary) -> Result<FlickrPhotoComment> {
        guard let id        = dict[FlickrConstants.Response.Keys.PhotoComments.id]        >>- JSONString,
              let ownerName = dict[FlickrConstants.Response.Keys.PhotoComments.ownerName] >>- JSONString,
              let ownerID   = dict[FlickrConstants.Response.Keys.PhotoComments.ownerID]   >>- JSONString,
              let content   = dict[FlickrConstants.Response.Keys.PhotoComments.content]   >>- JSONString else { return Result(CreationError.Flickr.comment) }
        return Result.init <| FlickrPhotoComment(id: id, ownerName: ownerName, ownerID: ownerID, content: content)
    }
}
