//
//  FlickrPhotoCommentCollection.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/25/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - FlickrPhotoCommentCollection

struct FlickrPhotoCommentCollection: FlickrCollection {
    let elements: Set<FlickrPhotoComment>
}

// MARK: - EmptyInitializable Conformance

extension FlickrPhotoCommentCollection {
    init() {
        elements = .empty
    }
    
    init(from array: [FlickrPhotoComment]) {
        elements = Set(array)
    }
}

// MARK: - FlickrCollection Conformance

extension FlickrPhotoCommentCollection {
    static let urlQueryParameters = urlGeneralQueryParameters + [
        FlickrConstants.Parameters.Keys.CommentCollection.method: FlickrConstants.Parameters.Values.CommentCollection.method
    ]
    
    static func create(from dict: JSONDictionary) -> Result<FlickrPhotoCommentCollection> {
        guard let commentsDict = dict[FlickrConstants.Response.Keys.CommentCollection.commentDictionary] >>- _JSONDictionary,
              let status       = dict[FlickrConstants.Response.Keys.General.status]                      >>- JSONString,
              status == FlickrConstants.Response.Values.Status.success else { return Result(CreationError.Flickr.comment) }
        guard let commentsArray = commentsDict[FlickrConstants.Response.Keys.CommentCollection.commentArray] >>- JSONArray else { return Result.init <| .empty }
        return commentsArray.map(FlickrPhotoComment.create).inverted <^> FlickrPhotoCommentCollection.init
    }
}
