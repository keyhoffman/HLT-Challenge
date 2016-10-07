//
//  FlickrImage.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

struct FlickrImageMetadata: RESTGetable, ResultRepresentable {
    let id:      String
    let ownerID: String
    let url:     String
}

func ==(_ lhs: FlickrImageMetadata, _ rhs: FlickrImageMetadata) -> Bool {
    return lhs.id == rhs.id && lhs.ownerID == rhs.ownerID && lhs.url == rhs.url
}

extension FlickrImageMetadata {
    static let urlQueryParameters = [
        FlickrConstants.ParameterKeys.apiKey:          FlickrConstants.ParameterValues.apiKey,
        FlickrConstants.ParameterKeys.method:          FlickrConstants.ParameterValues.searchMethod,
        FlickrConstants.ParameterKeys.extras:          FlickrConstants.ParameterValues.mediumURL,
        FlickrConstants.ParameterKeys.format:          FlickrConstants.ParameterValues.responseFormat,
        FlickrConstants.ParameterKeys.noJSONCallback:  FlickrConstants.ParameterValues.disableJSONCallback,
        FlickrConstants.ParameterKeys.safeSearch:      FlickrConstants.ParameterValues.safeSearchOn,
        FlickrConstants.ParameterKeys.picturesPerPage: FlickrConstants.ParameterValues.picturesPerPage,
        FlickrConstants.ParameterKeys.text:            FlickrConstants.ParameterValues.generalSearch
    ]
    
    static let urlAddressParameters = [
        FlickrImageMetadata.host:   FlickrConstants.API.host,
        FlickrImageMetadata.path:   FlickrConstants.API.path,
        FlickrImageMetadata.scheme: FlickrConstants.API.scheme
    ]

}

extension FlickrImageMetadata {
    static func create(from dict: JSONDictionary) -> Result<FlickrImageMetadata> {
        guard let id      = dict[FlickrConstants.ResponseKeys.id]        as? String,
              let ownerId = dict[FlickrConstants.ResponseKeys.ownerID]   as? String,
              let url     = dict[FlickrConstants.ResponseKeys.mediumURL] as? String else { return Result(CreationError.flickrImage) }
        return curry(Result.init) <^> FlickrImageMetadata(id: id, ownerID: ownerId, url: url)
    }
}

extension FlickrImageMetadata {
    static func getAll(from dict: JSONDictionary) -> Result<[FlickrImageMetadata]> {
        guard let photosDict  = dict[FlickrConstants.ResponseKeys.photos]      as? JSONDictionary,
              let photosArray = photosDict[FlickrConstants.ResponseKeys.photo] as? [JSONDictionary] else { return Result(CreationError.flickrImage) }
        return photosArray.map(FlickrImageMetadata.create).invert()
    }
}

extension FlickrImageMetadata {
    func image(withBlock block: @escaping (Result<UIImage>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let data = URL(string: self.url).flatMap { try? Data(contentsOf:$0) }
            DispatchQueue.main.async {
                block <^> data.flatMap(UIImage.init).toResult()
            }
        }
    }
}





