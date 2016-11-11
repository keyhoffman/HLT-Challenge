//
//  FlickrPhotoMetadataCollection.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/25/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - FlickrPhotoMetadataCollection

struct FlickrPhotoMetadataCollection: FlickrCollection {
    let elements: Set<FlickrPhotoMetadata>
}

// MARK: - EmptyInitializable Conformance

extension FlickrPhotoMetadataCollection {
    init() {
        elements = .empty
    }
    
    init(from array: [FlickrPhotoMetadata]) {
        elements = Set(array)
    }
}

// MARK: - FlickrCollection Conformance

extension FlickrPhotoMetadataCollection {
    static let urlQueryParameters: URLParameters = urlGeneralQueryParameters + [
        FlickrConstants.Parameters.Keys.MetadataCollection.method:          FlickrConstants.Parameters.Values.MetadataCollection.Method.getRecent.rawValue,
        FlickrConstants.Parameters.Keys.MetadataCollection.extras:          FlickrConstants.Parameters.Values.MetadataCollection.extras,
        FlickrConstants.Parameters.Keys.MetadataCollection.safeSearch:      FlickrConstants.Parameters.Values.MetadataCollection.SafeSearch.moderate.rawValue,
        FlickrConstants.Parameters.Keys.MetadataCollection.picturesPerPage: FlickrConstants.Parameters.Values.MetadataCollection.picturesPerPage
    ]
    
    static func create(from dict: JSONDictionary) -> Result<FlickrPhotoMetadataCollection> {
        guard let photosDict  = dict[FlickrConstants.Response.Keys.MetadataCollection.photoDictionary]  >>- _JSONDictionary,
              let status      = dict[FlickrConstants.Response.Keys.General.status]                      >>- JSONString,
              let photosArray = photosDict[FlickrConstants.Response.Keys.MetadataCollection.photoArray] >>- JSONArray,
              status == FlickrConstants.Response.Values.Status.success else { return Result(CreationError.Flickr.metadata) }
        return photosArray.map(FlickrPhotoMetadata.create).inverted <^> FlickrPhotoMetadataCollection.init
    }
}

// MARK: - Module Static API

extension FlickrPhotoMetadataCollection {
    static func getPhotosStream(startingAt index: Int = 0, withBlock block: @escaping ResultBlock<FlickrPhoto>) {
        pageNumber(for: index) <^> { pageNumber in
            ¿get <| [FlickrConstants.Parameters.Keys.MetadataCollection.pageNumber: pageNumber]
                 <| { metadataCollectionResults in _ = metadataCollectionResults >>- { metadataCollection in Result.init
                 <| metadataCollection.elements.map { metadata in metadata.getFlickrPhoto
                 <| block } } }
        }
    }
}

// MARK: - Fileprivate Static API

fileprivate extension FlickrPhotoMetadataCollection {
    fileprivate static func pageNumber(for index: Int) -> Result<String> {
        func calculatePage(picturesPerPage: Int) -> Int {
            return (index + picturesPerPage) / picturesPerPage
        }
        return (Int(FlickrConstants.Parameters.Values.MetadataCollection.picturesPerPage) >>- (calculatePage |>> String.init))
            .toResult <| URLRequestError.invalidURL(parameters: [FlickrConstants.Parameters.Keys.MetadataCollection.picturesPerPage: FlickrConstants.Parameters.Values.MetadataCollection.picturesPerPage])
    }
}
