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
        guard let id      = dict[FlickrConstants.Response.Keys.PhotoComments.id]      >>= JSONString,
              let author  = dict[FlickrConstants.Response.Keys.PhotoComments.author]  >>= JSONString,
              let content = dict[FlickrConstants.Response.Keys.PhotoComments.content] >>= JSONString else { return Result(CreationError.Flickr.comment) }
        return curry(Result.init) <^> FlickrPhotoComment(id: id, author: author, content: content)
    }

    static func extract(from dict: JSONDictionary) -> Result<[FlickrPhotoComment]> {
        guard let commentsDict = dict[FlickrConstants.Response.Keys.PhotoComments.comments] >>= _JSONDictionary,
              let status       = dict[FlickrConstants.Response.Keys.General.status]         >>= JSONString,
              status == FlickrConstants.Response.Values.Status.success else { return Result(CreationError.Flickr.comment) }
        
        guard let commentsArray = commentsDict[FlickrConstants.Response.Keys.PhotoComments.comment] >>= JSONArray else { return Result(.empty) }
        return commentsArray.map(FlickrPhotoComment.create).invert()
    }
}

extension FlickrPhotoComment {
    static func photoIDParameter(for metadata: FlickrPhotoMetadata) -> URLParameters {
        return [FlickrConstants.Parameters.Keys.PhotoComments.photoID: "29466047852"] // NOTE: This is a test id that has several comments
//        return [FlickrConstants.Parameters.Keys.PhotoComments.photoID: metadata.id]
    }
}
