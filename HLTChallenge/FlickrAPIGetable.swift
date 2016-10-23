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
        
//        let foo = curry(dataTask) <^> (queryParameters |> (url >-> urlRequest))
//
//        _ = foo
//        
//        func addMe(x: Int, y: Int) -> Int {
//            return x + y
//        }
//        
//        _ = curry(_dataTask_) <| block <^> (queryParameters |> (url >-> urlRequest))
        switch queryParameters |> (url >-> urlRequest) {
        case let .error(error):   block <| Result(error)
        case let .value(request): dataTask(for: request, with: block)
        }
        
    }
    
//    static func _dataTask_(block: @escaping ResultBlock<[Self]>, request: URLRequest) {
//        
//    }
    
    static func dataTask(for request: URLRequest, with block: @escaping ResultBlock<[Self]>) {
        URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            DispatchQueue.main.async {
                (Response(data: data, urlResponse: urlResponse), error) |> (Result.init >-> parse >-> decode >-> extract >-> block)
            }
        }.resume()
    }
    
}
