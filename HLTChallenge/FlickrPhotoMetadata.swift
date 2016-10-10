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
    let ownerID: String
    let url:     String
    let title:   String
}

// MARK: - Equatable Conformance

func ==(_ lhs: FlickrPhotoMetadata, _ rhs: FlickrPhotoMetadata) -> Bool {
    return lhs.id == rhs.id && lhs.ownerID == rhs.ownerID && lhs.url == rhs.url && lhs.title == rhs.title
}

// MARK: - FlickrAPIGetable Conformance

extension FlickrPhotoMetadata {
    static let urlQueryParameters = urlGeneralQueryParameters + [
        FlickrConstants.Parameters.Keys.Metadata.method:          FlickrConstants.Parameters.Values.Metadata.getRecent,
        FlickrConstants.Parameters.Keys.Metadata.extras:          FlickrConstants.Parameters.Values.Metadata.extras,
        FlickrConstants.Parameters.Keys.Metadata.safeSearch:      FlickrConstants.Parameters.Values.Metadata.safeSearch,
        FlickrConstants.Parameters.Keys.Metadata.picturesPerPage: FlickrConstants.Parameters.Values.Metadata.picturesPerPage
    ]
    
    static func create(from dict: JSONDictionary) -> Result<FlickrPhotoMetadata> {
        guard let id      = dict[FlickrConstants.Response.Keys.Metadata.id]        as? String,
              let ownerId = dict[FlickrConstants.Response.Keys.Metadata.ownerID]   as? String,
              let url     = dict[FlickrConstants.Response.Keys.Metadata.url]       as? String,
              let title   = dict[FlickrConstants.Response.Keys.Metadata.title]     as? String else { return Result(CreationError.Flickr.metadata) }
        return curry(Result.init) <^> FlickrPhotoMetadata(id: id, ownerID: ownerId, url: url, title: title)
    }
    
    static func extract(from dict: JSONDictionary) -> Result<[FlickrPhotoMetadata]> {
        guard let photosDict  = dict[FlickrConstants.Response.Keys.Metadata.photos]      as? JSONDictionary,
              let photosArray = photosDict[FlickrConstants.Response.Keys.Metadata.photo] as? [JSONDictionary] else { return Result(CreationError.Flickr.metadata) }
        return photosArray.map(FlickrPhotoMetadata.create).invert()
    }
}

// MARK: - Module Static API

extension FlickrPhotoMetadata {
    static func getPhotosStream(withBlock block: @escaping (Result<FlickrPhoto>) -> Void) {
        getAll { allMetadataResults in _ = allMetadataResults >>= { allMetadata in curry(Result.init) <^> allMetadata.map { metadata in metadata.getFlickrPhoto <^> block } } }
    }
}

// MARK: - Fileprivate Instance API {

extension FlickrPhotoMetadata {
    fileprivate func getFlickrPhoto(withBlock block: @escaping (Result<FlickrPhoto>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let data = URL(string: self.url).flatMap { try? Data(contentsOf:$0) }
            DispatchQueue.main.async {
                switch data.flatMap(UIImage.init).toResult <^> CreationError.Flickr.photo(forURL: self.url) { // FIXME: GET RID OF THIS SWITCH STATEMENT
                case let .error(error): block <^> Result(error)
                case let .value(photo): block <^> (curry(Result.init) <^> FlickrPhoto(photo: photo, metadata: self))
                }
            }
        }
    }
}



























//    fileprivate func url(withMethod method: String) -> Result<URL> {
//        let path = FlickrPhotoMetadata.urlAddressParameters[FlickrPhotoMetadata.path]
//
//        guard let compontentsPath = path else { return curry(Result.init) <^> URLRequestError.invalidURLPath(path: path) }
//
//        var components        = URLComponents()
//        components.path       = compontentsPath
//        components.scheme     = FlickrPhotoMetadata.urlAddressParameters[FlickrPhotoMetadata.scheme]
//        components.host       = FlickrPhotoMetadata.urlAddressParameters[FlickrPhotoMetadata.host]
//        components.queryItems = FlickrPhotoMetadata.urlQueryParameters.map(URLQueryItem.init)
//
//        return components.url.toResult(withError:) <^> URLRequestError.invalidURL(parameters: FlickrPhotoMetadata.urlQueryParameters)
//    }






//    static fileprivate func getAllMetadata(withblock block: @escaping (Result<[FlickrPhotoMetadata]>) -> Void) {
//        switch url() >>= urlRequest { // FIXME: GET RID OF THIS SWITCH STATEMENT
//        case let .error(error):   block <^> Result(error)
//        case let .value(request): dataTask(with: request, withBlock: block)
//        }
//    }

//    static private func dataTask(request: URLRequest, withBlock block: @escaping (Result<[FlickrPhotoMetadata]>) -> Void) {
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            DispatchQueue.main.async {
//                block <^> (processDataTask(date: data, response: response, error: error) >>= FlickrPhotoMetadata.extract)
//            }
//        }.resume()
//    }
