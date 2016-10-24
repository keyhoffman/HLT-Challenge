//
//  Downloadable.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - RESTGetable Protocol

protocol RESTGetable: Equatable {
    static var urlQueryParameters:   URLParameters { get }
    static var urlAddressParameters: URLParameters { get }
    
    static func create(from dictionary: JSONDictionary) -> Result<Self>
}

// MARK: - Module Static `urlAddressParameters` Keys

extension RESTGetable {
    static var scheme: String { return "scheme" }
    static var host:   String { return "host" }
    static var path:   String { return "path" }
}

// MARK: - Module Static JSON Parsing Helper Methods

extension RESTGetable {
    static func JSONObject<A>(from object: Any) -> A? {
        return object as? A
    }
    
    static func JSONString(from object: Any) -> String? {
        return object as? String
    }
    
    // TODO: Find a better name for this function
    static func _JSONDictionary(from object: Any) -> JSONDictionary? {
        return object as? JSONDictionary
    }
    
    static func JSONArray(from object: Any) -> [JSONDictionary]? {
        return object as? [JSONDictionary]
    }
}

// MARK: - Module Static API

extension RESTGetable {
    // FIXME: GENERALIZE THIS METHOD TO WORK WITH `FlickrAPIGetable`
    static func get(withAdditionalQueryParameters queryParameters: URLParameters = .empty, withBlock block: @escaping ResultBlock<Self>) {
        _ = { dataTask(for: $0, with: block) } <^> (queryParameters |> (url >-> urlRequest)) // FIXME: HANDLE ERROR
    }
    
    // MARK: URL Configuration
    
    static func urlRequest(from url: URL) -> Result<URLRequest> {
        return Result.init <| URLRequest(url: url)
    }
    
    static func url(withAdditionalQueryParameters queryParameters: URLParameters = .empty) -> Result<URL> {
        let componentsURL = URLComponents(path:       urlAddressParameters[path],
                                          scheme:     urlAddressParameters[scheme],
                                          host:       urlAddressParameters[host],
                                          queryItems: (urlQueryParameters + queryParameters).map(URLQueryItem.init))?.url
        
        return componentsURL.toResult(withError:) <| URLRequestError.invalidURL(parameters: urlQueryParameters)
    }
}

// MARK: - Fileprivate Static API

extension RESTGetable {
    // FIXME: GENERALIZE THIS METHOD TO WORK WITH `FlickrAPIGetable`
    static fileprivate func dataTask(for request: URLRequest, with block: @escaping ResultBlock<Self>) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                (Response(data: data, urlResponse: response), error) |> (Result.init >-> parse >-> decode >-> create >-> block)
            }
        }.resume()
    }
    
    static func parse(response: Response) -> Result<Data> {
        return Response.successRange.contains(response.statusCode) ? Result(response.data) : Result.init <| URLRequestError.invalidResponseStatus(code: response.statusCode)
    }
    
    static func decode(json data: Data) -> Result<JSONDictionary> {
        do    { return (try JSONSerialization.jsonObject(with: data, options: .allowFragments) >>- _JSONDictionary).toResult <| URLRequestError.couldNotParseJSON }
        catch { return Result(error) }
    }
}


