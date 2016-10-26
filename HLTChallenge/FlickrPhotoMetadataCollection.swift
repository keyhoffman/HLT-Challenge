//
//  FlickrPhotoMetadataCollection.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/25/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

struct FlickrPhotoMetadataCollection: FlickrAPIGetableCollection {
    let elements: Set<FlickrPhotoMetadata>
}

extension FlickrPhotoMetadataCollection {
    init(from array: [FlickrPhotoMetadata]) {
        elements = Set(array)
    }
}

extension FlickrPhotoMetadataCollection {
    static let urlQueryParameters: URLParameters = urlGeneralQueryParameters + [
        FlickrConstants.Parameters.Keys.Metadata.method:          FlickrConstants.Parameters.Values.Metadata.Method.getRecent.rawValue,
        FlickrConstants.Parameters.Keys.Metadata.extras:          FlickrConstants.Parameters.Values.Metadata.extras,
        FlickrConstants.Parameters.Keys.Metadata.safeSearch:      FlickrConstants.Parameters.Values.Metadata.SafeSearch.moderate.rawValue,
        FlickrConstants.Parameters.Keys.Metadata.picturesPerPage: FlickrConstants.Parameters.Values.Metadata.picturesPerPage
    ]
    
    static func create(from dict: JSONDictionary) -> Result<FlickrPhotoMetadataCollection> {
        guard let photosDict  = dict[FlickrConstants.Response.Keys.Metadata.photos]      >>- _JSONDictionary,
              let status      = dict[FlickrConstants.Response.Keys.General.status]       >>- JSONString,
              let photosArray = photosDict[FlickrConstants.Response.Keys.Metadata.photo] >>- JSONArray,
              status == FlickrConstants.Response.Values.Status.success else { return Result(CreationError.Flickr.metadata) }
        
        return photosArray.map(FlickrPhotoMetadata.create).invert() <^> FlickrPhotoMetadataCollection.init
    }
}

extension FlickrPhotoMetadataCollection {
    static func getPhotosStream(startingAt index: Int = 0, withBlock block: @escaping ResultBlock<FlickrPhoto>) {
        pageNumber(for: index) <^> { pageNumber in
            ¿get <| [FlickrConstants.Parameters.Keys.Metadata.pageNumber: pageNumber]
                 <| { metadataCollectionResults in _ = metadataCollectionResults >>- { metadataCollection in Result.init
                 <| metadataCollection.elements.map { metadata in metadata.getFlickrPhoto
                 <| block } } }
        }
    }
    
    static private func pageNumber(for index: Int) -> Result<String> {
        func calculatePage(picturesPerPage: Int) -> Int {
            return (index + picturesPerPage) / picturesPerPage
        }
        return (Int(FlickrConstants.Parameters.Values.Metadata.picturesPerPage) >>- (calculatePage |>> String.init))
            .toResult <| URLRequestError.invalidURL(parameters: [FlickrConstants.Parameters.Keys.Metadata.picturesPerPage: FlickrConstants.Parameters.Values.Metadata.picturesPerPage])
    }
}
