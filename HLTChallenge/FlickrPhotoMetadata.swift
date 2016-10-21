//
//  FlickrImage.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrPhotoMetadata

struct FlickrPhotoMetadata: FlickrAPIGetable {
    let id:      String
    let url:     String
    let title:   String
    let ownerID: String
    let ownerName: String
}

// MARK: - Equatable Conformance

func == (_ lhs: FlickrPhotoMetadata, _ rhs: FlickrPhotoMetadata) -> Bool {
    return lhs.id == rhs.id && lhs.ownerID == rhs.ownerID && lhs.url == rhs.url && lhs.title == rhs.title
}

// MARK: - FlickrAPIGetable Conformance

extension FlickrPhotoMetadata {
    static let urlQueryParameters: URLParameters = urlGeneralQueryParameters + [
        FlickrConstants.Parameters.Keys.Metadata.method:          FlickrConstants.Parameters.Values.Metadata.Method.getRecent.rawValue,
        FlickrConstants.Parameters.Keys.Metadata.extras:          FlickrConstants.Parameters.Values.Metadata.extras,
        FlickrConstants.Parameters.Keys.Metadata.safeSearch:      FlickrConstants.Parameters.Values.Metadata.SafeSearch.moderate.rawValue,
        FlickrConstants.Parameters.Keys.Metadata.picturesPerPage: FlickrConstants.Parameters.Values.Metadata.picturesPerPage
    ]
    
    static func create(from dict: JSONDictionary) -> Result<FlickrPhotoMetadata> {
        guard let id      = dict[FlickrConstants.Response.Keys.Metadata.id]          >>- JSONString,
              let url     = dict[FlickrConstants.Response.Keys.Metadata.url]         >>- JSONString,
              let title   = dict[FlickrConstants.Response.Keys.Metadata.title]       >>- JSONString,
              let ownerId = dict[FlickrConstants.Response.Keys.Metadata.ownerID]     >>- JSONString,
              let ownerName = dict[FlickrConstants.Response.Keys.Metadata.ownerName] >>- JSONString else { return Result(CreationError.Flickr.metadata) }
        return Result.init <| FlickrPhotoMetadata(id: id, url: url, title: title, ownerID: ownerId, ownerName: ownerName)
    }
    
    // FIXME: MOVE THIS FUNCTIONALITY INSIDE `create` METHOD
    static func extract(from dict: JSONDictionary) -> Result<[FlickrPhotoMetadata]> {
        guard let photosDict  = dict[FlickrConstants.Response.Keys.Metadata.photos]      >>- _JSONDictionary,
              let status      = dict[FlickrConstants.Response.Keys.General.status]       >>- JSONString,
              let photosArray = photosDict[FlickrConstants.Response.Keys.Metadata.photo] >>- JSONArray,
              status == FlickrConstants.Response.Values.Status.success else { return Result(CreationError.Flickr.metadata) }
        return photosArray.map(FlickrPhotoMetadata.create).invert()
    }
}

// MARK: - Module Static API

extension FlickrPhotoMetadata {
    static func getPhotosStream(startingAt index: Int = 0, withBlock block: @escaping ResultBlock<FlickrPhoto>) {
        switch pageNumber(for: index) { // FIXME: GET RID OF THIS SWITCH STATEMENT
        case let .error(error):      block <| Result(error)
        case let .value(pageNumber): curry(getAll) <| [FlickrConstants.Parameters.Keys.Metadata.pageNumber: pageNumber]
                                                   <| { allMetadataResults in _ = allMetadataResults >>- { allMetadata in Result.init
                                                   <| allMetadata.map { metadata in metadata.getFlickrPhoto
                                                   <| block
                    }
                }
            }
        }
    }
}

// MARK: - Fileprivate Static API

extension FlickrPhotoMetadata {
    static fileprivate func pageNumber(for index: Int) -> Result<String> {
        func calculatePage(picturesPerPage: Int) -> Int {
            return (index + picturesPerPage) / picturesPerPage
        }
        return (Int(FlickrConstants.Parameters.Values.Metadata.picturesPerPage) >>- (calculatePage |>> String.init))
            .toResult <| URLRequestError.invalidURL(parameters: [FlickrConstants.Parameters.Keys.Metadata.picturesPerPage: FlickrConstants.Parameters.Values.Metadata.picturesPerPage])
    }
}

// MARK: - Fileprivate Instance API {

extension FlickrPhotoMetadata {
    fileprivate func getFlickrPhoto(withBlock block: @escaping ResultBlock<FlickrPhoto>) {
        DispatchQueue.global(qos: .userInitiated).async {
            let data = URL(string: self.url).flatMap { try? Data(contentsOf:$0) }
            DispatchQueue.main.async {
                switch (data >>- UIImage.init).toResult <| CreationError.Flickr.photo(forURL: self.url) { // FIXME: GET RID OF THIS SWITCH STATEMENT
                case let .error(error): error |> (Result.init |>> block)
                case let .value(photo): (photo, self) |> (FlickrPhoto.init |>> Result.init |>> block)
                }
            }
        }
    }
}

