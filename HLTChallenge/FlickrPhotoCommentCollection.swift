//
//  FlickrPhotoCommentCollection.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/25/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

struct FlickrPhotoCommentCollection: FlickrAPIGetableCollection {
    let elements: Set<FlickrPhotoComment>
}

extension FlickrPhotoCommentCollection {
    init() {
        elements = .empty
    }
    
    init(from array: [FlickrPhotoComment]) {
        elements = Set(array)
    }
}

extension FlickrPhotoCommentCollection {
    static let urlQueryParameters = urlGeneralQueryParameters + [
        FlickrConstants.Parameters.Keys.PhotoComments.method: FlickrConstants.Parameters.Values.PhotoComments.method
    ]
    
    static func create(from dict: JSONDictionary) -> Result<FlickrPhotoCommentCollection> {
        guard let commentsDict = dict[FlickrConstants.Response.Keys.PhotoComments.comments] >>- _JSONDictionary,
              let status       = dict[FlickrConstants.Response.Keys.General.status]         >>- JSONString,
              status == FlickrConstants.Response.Values.Status.success else { return Result(CreationError.Flickr.comment) }
        guard let commentsArray = commentsDict[FlickrConstants.Response.Keys.PhotoComments.comment] >>- JSONArray else { return Result.init <| .empty }
        return commentsArray.map(FlickrPhotoComment.create).inverted <^> FlickrPhotoCommentCollection.init
    }
}
