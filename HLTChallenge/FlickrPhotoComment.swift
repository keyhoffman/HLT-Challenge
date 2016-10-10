//
//  FlickrPhotoComment.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/9/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - FlickrPhotoComment

struct FlickrPhotoComment: FlickrAPIGetable {
    let id:       String
    let author:   String
    let content:  String
}

// MARK: - Equatable Conformance

func ==(_ lhs: FlickrPhotoComment, _ rhs: FlickrPhotoComment) -> Bool {
    return lhs.id == rhs.id && lhs.author == rhs.author && lhs.content == rhs.content
}

// MARK: - FlickrAPIGetable Conformance

extension FlickrPhotoComment {
    static let urlQueryParameters = urlGeneralQueryParameters + [
        FlickrConstants.Parameters.Keys.PhotoComments.method: FlickrConstants.Parameters.Values.PhotoComments.method
    ]
    
    static func create(from dict: JSONDictionary) -> Result<FlickrPhotoComment> {
        guard let id      = dict[FlickrConstants.Response.Keys.PhotoComments.id]      as? String,
              let author  = dict[FlickrConstants.Response.Keys.PhotoComments.author]  as? String,
              let content = dict[FlickrConstants.Response.Keys.PhotoComments.content] as? String else { return Result(CreationError.Flickr.comment) }
        return curry(Result.init) <^> FlickrPhotoComment(id: id, author: author, content: content)
    }
    
    static func extract(from dict: JSONDictionary) -> Result<[FlickrPhotoComment]> {
        guard let commentsDict = dict[FlickrConstants.Response.Keys.PhotoComments.comments]         as? JSONDictionary,
              let stat = dict[FlickrConstants.Response.Keys.General.status]                         as? String,
              let commentsArray = commentsDict[FlickrConstants.Response.Keys.PhotoComments.comment] as? [JSONDictionary] else { return Result(CreationError.Flickr.comment) }
        return commentsArray.map(FlickrPhotoComment.create).invert()
    }
}
