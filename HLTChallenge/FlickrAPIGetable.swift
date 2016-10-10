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
    
    // MARK: RESTGetable Conformance
    
    static var urlAddressParameters: URLParameters {
        return [
            host:   FlickrConstants.API.host,
            path:   FlickrConstants.API.path,
            scheme: FlickrConstants.API.scheme
        ]
    }
}

extension FlickrAPIGetable {
    static func getAll(withAdditionalQueryParameters queryParameters: URLParameters = [:], withBlock block: @escaping (Result<[Self]>) -> Void) {
        switch (url <^> queryParameters) >>= urlRequest { // FIXME: GET RID OF THIS SWITCH STATEMENT!!!!
        case let .error(error):   block <^> Result(error)
        case let .value(request): dataTask(with: request, withBlock: block)
        }

    }
    
    static func dataTask(with request: URLRequest, withBlock block: @escaping (Result<[Self]>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, repsonse, error in
            DispatchQueue.main.async {
                block <^> (processDataTask(date: data, response: repsonse, error: error) >>= Self.extract)
            }
        }.resume()
    }
}
