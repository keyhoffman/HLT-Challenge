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
        
//        let foo = url >-> urlRequest
        let faa = (queryParameters |> (url >-> urlRequest), block)
        let foo = dataTask
        
        
        
        
        switch faa.0 {
        case .error(let e): faa.1 <| Result(e)
        case .value(let v): foo(v, faa.1)
            
            
        }
        
        
        switch queryParameters |> (url >-> urlRequest) {
        case let .error(error):   block <| Result(error)
        case let .value(request): dataTask(for: request, with: block)
        }
        
    }
    
    static func dataTask(for request: URLRequest, with block: @escaping ResultBlock<[Self]>) {
        URLSession.shared.dataTask(with: request) { data, repsonse, error in
            DispatchQueue.main.async {
                (data, repsonse, error) |> (processDataTask >-> extract >-> block)
            }
        }.resume()
    }
    
}
