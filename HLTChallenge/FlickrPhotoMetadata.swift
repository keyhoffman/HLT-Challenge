//
//  FlickrImage.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrPhotoMetadata

struct FlickrPhotoMetadata: RESTGetable, ResultRepresentable {
    let id:      String
    let ownerID: String
    let url:     String
    let title:   String
}

// MARK: - Equatable Conformance

func ==(_ lhs: FlickrPhotoMetadata, _ rhs: FlickrPhotoMetadata) -> Bool {
    return lhs.id == rhs.id && lhs.ownerID == rhs.ownerID && lhs.url == rhs.url
}

// MARK: - RESTGetable Conformance

extension FlickrPhotoMetadata {
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
        FlickrPhotoMetadata.host:   FlickrConstants.API.host,
        FlickrPhotoMetadata.path:   FlickrConstants.API.path,
        FlickrPhotoMetadata.scheme: FlickrConstants.API.scheme
    ]
    
    static func create(from dict: JSONDictionary) -> Result<FlickrPhotoMetadata> {
        guard let id      = dict[FlickrConstants.ResponseKeys.id]        as? String,
              let ownerId = dict[FlickrConstants.ResponseKeys.ownerID]   as? String,
              let url     = dict[FlickrConstants.ResponseKeys.mediumURL] as? String,
              let title   = dict[FlickrConstants.ResponseKeys.title]     as? String else { return Result(CreationError.flickrPhotoMetadata) }
        return curry(Result.init) <^> FlickrPhotoMetadata(id: id, ownerID: ownerId, url: url, title: title)
    }
}

// MARK: - Module Static API

extension FlickrPhotoMetadata {
    static func getPhotosStream(withBlock block: @escaping (Result<UIImage>) -> Void) {
        getAllMetadata { _ = $0 >>= { curry(Result.init) <^> $0.map { data in data.getPhoto <^> block } } }
    }
}

// MARK: - Fileprivate Instance API {

extension FlickrPhotoMetadata {
    fileprivate func getPhoto(withBlock block: @escaping (Result<UIImage>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let data = URL(string: self.url).flatMap { try? Data(contentsOf:$0) }
            DispatchQueue.main.async {
                block <^> (data.flatMap(UIImage.init).toResult <^> CreationError.flickrPhoto(forURL: self.url))
            }
        }
    }
}

// MARK: - Fileprivate Static API

extension FlickrPhotoMetadata {
    static fileprivate func getAllMetadata(withblock block: @escaping (Result<[FlickrPhotoMetadata]>) -> Void) {
//        url() >>= urlRequest |> (block <^> dataTask)
//        block <^> (url() >>= urlRequest |> dataTask)
        switch url() >>= urlRequest { // FIXME: GET RID OF THIS SWITCH STATEMENT
        case let .error(error):   block <^> Result(error)
        case let .value(request): dataTask(request: request, withBlock: block)
        }
    }

    static private func dataTask(request: URLRequest, withBlock block: @escaping (Result<[FlickrPhotoMetadata]>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                block <^> (processDataTask(date: data, response: response, error: error) >>= FlickrPhotoMetadata.extractMetadata)
            }
        }.resume()
    }
    
    static private func extractMetadata(from dict: JSONDictionary) -> Result<[FlickrPhotoMetadata]> {
        guard let photosDict  = dict[FlickrConstants.ResponseKeys.photos]      as? JSONDictionary,
              let photosArray = photosDict[FlickrConstants.ResponseKeys.photo] as? [JSONDictionary] else { return Result(CreationError.flickrPhotoMetadata) }
        return photosArray.map(FlickrPhotoMetadata.create).invert()
    }
}



