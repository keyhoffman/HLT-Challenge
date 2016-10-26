//
//  FlickrAPIGetable.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/9/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - FlickrAPIGetable Protocol

protocol FlickrAPIGetable: RESTGetable {
    static func extract(from dict: JSONDictionary) -> Result<[Self]>
}

extension FlickrAPIGetable {
    static var urlGeneralQueryParameters: URLParameters {
        return [
            FlickrConstants.Parameters.Keys.General.apiKey:         FlickrConstants.Parameters.Values.General.apiKey,
            FlickrConstants.Parameters.Keys.General.responseFormat: FlickrConstants.Parameters.Values.General.responseFormat,
            FlickrConstants.Parameters.Keys.General.noJSONCallback: FlickrConstants.Parameters.Values.General.noJSONCallback
        ]
    }
    
    // MARK: - RESTGetable Conformance
    
    static var urlAddressParameters: URLParameters {
        return [
            host:   FlickrConstants.API.host,
            path:   FlickrConstants.API.path,
            scheme: FlickrConstants.API.scheme
        ]
    }
}

// FIXME: FIX RESPECTIVE `RESTGetable` methods
extension FlickrAPIGetable {
    static func getAll(withAdditionalQueryParameters queryParameters: URLParameters = .empty, withBlock block: @escaping ResultBlock<[Self]>) {
        (queryParameters |> (url >-> urlRequest)) <^> { request in dataTask(for: request, with: block) } //<^> (queryParameters |> (url >-> urlRequest)) // FIXME: HANDLE ERROR AND CLEAN THIS UPPPPP
    }
    
    static func dataTask(for request: URLRequest, with block: @escaping ResultBlock<[Self]>) {
        URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            DispatchQueue.main.async {
                (Response(data: data, urlResponse: urlResponse), error) |> (Result.init >-> parse >-> decode >-> extract >-> block)
            }
        }.resume()
    }
}


// MARK: - FlickrCollection Protocol

protocol FlickrCollection: FlickrAPIGetableCollection {
    associatedtype FlickrElement: Hashable
    var elements: Set<FlickrElement> { get }
//    init(from array: [FlickrElement])
}

extension FlickrCollection {
    
//    init(from array: [FlickrElement]) {
//        self.elements = Set(array)
//    }
    
    typealias FlickrIndex = SetIndex<FlickrElement>
    
    var startIndex: FlickrIndex { return elements.startIndex }
    var endIndex:   FlickrIndex { return elements.endIndex }
    
    subscript(i: FlickrIndex) -> FlickrElement {
        return elements[i]
    }
    
    func index(after i: FlickrIndex) -> FlickrIndex {
        return elements.index(after: i)
    }
}


struct FlickrPhotoMetadataCollection: FlickrCollection {
    let elements: Set<FlickrPhotoMetadata>
    
    static func convert(from arr: [FlickrPhotoMetadata]) -> Set<FlickrPhotoMetadata> {
        return <#value#>
    }
    init(from array: [FlickrPhotoMetadata]) {
        elements = Set(array)
    }
}

// MARK: - Equatable Conformance

func ==(_ lhs: FlickrPhotoMetadataCollection, _ rhs: FlickrPhotoMetadataCollection) -> Bool {
    return lhs.elements == rhs.elements
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
    
    static func extract(from dict: JSONDictionary) -> Result<[FlickrPhotoMetadataCollection]> {
        fatalError()
    }
}

extension FlickrPhotoMetadataCollection {
    
}

extension FlickrPhotoMetadataCollection {
    
}

































