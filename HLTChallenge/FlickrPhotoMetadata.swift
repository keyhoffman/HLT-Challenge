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

func ==(_ lhs: FlickrPhotoMetadata, _ rhs: FlickrPhotoMetadata) -> Bool {
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
        guard let id      = dict[FlickrConstants.Response.Keys.Metadata.id]          >>= JSONString,
              let url     = dict[FlickrConstants.Response.Keys.Metadata.url]         >>= JSONString,
              let title   = dict[FlickrConstants.Response.Keys.Metadata.title]       >>= JSONString,
              let ownerId = dict[FlickrConstants.Response.Keys.Metadata.ownerID]     >>= JSONString,
              let ownerName = dict[FlickrConstants.Response.Keys.Metadata.ownerName] >>= JSONString else { return Result(CreationError.Flickr.metadata) }
        return curry(Result.init) <^> FlickrPhotoMetadata(id: id, url: url, title: title, ownerID: ownerId, ownerName: ownerName)
    }
    
    static func extract(from dict: JSONDictionary) -> Result<[FlickrPhotoMetadata]> {
        guard let photosDict  = dict[FlickrConstants.Response.Keys.Metadata.photos]      >>= _JSONDictionary,
              let status      = dict[FlickrConstants.Response.Keys.General.status]       >>= JSONString,
              let photosArray = photosDict[FlickrConstants.Response.Keys.Metadata.photo] >>= JSONArray,
              status == FlickrConstants.Response.Values.Status.success else { return Result(CreationError.Flickr.metadata) }
        return photosArray.map(FlickrPhotoMetadata.create).invert()
    }
}

// MARK: - Module Static API

extension FlickrPhotoMetadata {
    static func getPhotosStream(withBlock block: @escaping ResultBlock<FlickrPhoto>) {
        getAll { allMetadataResults in _ = allMetadataResults >>= { allMetadata in curry(Result.init) <^> allMetadata.map { metadata in metadata.getFlickrPhoto <^> block } } }
    }
}

// MARK: - Fileprivate Instance API {

extension FlickrPhotoMetadata {
    fileprivate func getFlickrPhoto(withBlock block: @escaping ResultBlock<FlickrPhoto>) {
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
