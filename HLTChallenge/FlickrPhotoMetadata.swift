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
              let url     = dict[FlickrConstants.ResponseKeys.mediumURL] as? String else { return Result(CreationError.flickrImage) }
        return curry(Result.init) <^> FlickrPhotoMetadata(id: id, ownerID: ownerId, url: url)
    }
}

// MARK: - Module API

extension Sequence where Iterator.Element == ((@escaping (Result<UIImage>) -> Void) -> Void) {
    func invert() -> Result<[UIImage]> {
        let foo = self.flatMap { $0 { result in return } }
        
        let fuu = self.flatMap(<#T##transform: ((((Result<UIImage>) -> Void) -> Void)) throws -> ElementOfResult?##((((Result<UIImage>) -> Void) -> Void)) throws -> ElementOfResult?#>) // MARK: - START HERE
        
        //return curry(Result.init) <^> self.map { $0.toOptional() }.flatMap { $0 }
    }
}

extension FlickrPhotoMetadata {
    static func getAllMetadata(withblock block: @escaping (Result<[FlickrPhotoMetadata]>) -> Void) {
        
//        block <^> (curry(dataTask) <^> (url() >>= urlRequest) <^> block)
        
//        block <^> ((url() >>= urlRequest) >>= dataTask)
        
        switch url() >>= urlRequest { // FIXME: GET RID OF THIS SWITCH STATEMENT
        case let .error(error):   block <^> Result(error)
        case let .value(request): dataTask(request: request, withBlock: block)
        }
    }
    
    static func getAllPhotos(withBlock block: @escaping (Result<[UIImage]>) -> Void) {
        getAllMetadata { result in
            switch result { // FIXME: GET RID OF THIS SWITCH STATEMENT
            case let .error(error):    block <^> Result(error)
            case let .value(metadata): block <^> metadata.map(getPhoto).invert()
            }
        }
    }
}

extension FlickrPhotoMetadata {
    func getPhoto(withBlock block: @escaping (Result<UIImage>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let data = URL(string: self.url).flatMap { try? Data(contentsOf:$0) }
            DispatchQueue.main.async {
                block <^> data.flatMap(UIImage.init).toResult()
            }
        }
    }
}

// MARK: - Fileprivate API

extension FlickrPhotoMetadata {
        static fileprivate func dataTask(request: URLRequest, withBlock block: @escaping (Result<[FlickrPhotoMetadata]>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                block <^> (processDataTask(date: data, response: response, error: error) >>= FlickrPhotoMetadata.extractMetadata)
            }
        }.resume()
    }
    
    static private func extractMetadata(from dict: JSONDictionary) -> Result<[FlickrPhotoMetadata]> {
        guard let photosDict  = dict[FlickrConstants.ResponseKeys.photos]      as? JSONDictionary,
              let photosArray = photosDict[FlickrConstants.ResponseKeys.photo] as? [JSONDictionary] else { return Result(CreationError.flickrImage) }
        return photosArray.map(FlickrPhotoMetadata.create).invert()
    }
}



