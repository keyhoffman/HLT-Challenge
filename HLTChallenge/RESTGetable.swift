//
//  Downloadable.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - RESTGetable Protocol

protocol RESTGetable: JSONCreatable {
    static var urlQueryParameters:   URLParameters { get }
    static var urlAddressParameters: URLParameters { get }
}

// MARK: - Module Static `urlAddressParameters` Keys

extension RESTGetable {
    static var scheme: String { return "scheme" }
    static var host:   String { return "host" }
    static var path:   String { return "path" }
}

// MARK: - Module Static API

extension RESTGetable {
    static func get(withAdditionalQueryParameters queryParameters: URLParameters = .empty, withBlock block: @escaping ResultBlock<Self>) { // FIXME: HANDLE ERROR
        queryParameters |> (url >-> urlRequest) <^> { request in dataTask(for: request, with: block) }
    }
}

// MARK: - URL Configuration Extension

extension RESTGetable {
    fileprivate static func urlRequest(from url: URL) -> Result<URLRequest> {
        return Result.init <| URLRequest(url: url)
    }
    
    fileprivate static func url(withAdditionalQueryParameters queryParameters: URLParameters = .empty) -> Result<URL> {
        let componentsURL = URLComponents(path:       urlAddressParameters[path],
                                          scheme:     urlAddressParameters[scheme],
                                          host:       urlAddressParameters[host],
                                          queryItems: (urlQueryParameters + queryParameters).map(URLQueryItem.init))?.url
        return componentsURL.toResult <| URLRequestError.invalidURL(parameters: urlQueryParameters)
    }
}

// MARK: - Fileprivate Static API

extension RESTGetable {
    fileprivate static func dataTask(for request: URLRequest, with block: @escaping ResultBlock<Self>) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                (Response(data: data, urlResponse: response), error) |> (Result.init >-> parse(response:) >-> decode(json:) >-> create >-> block)
            }
        }.resume()
    }
    
    private static func parse(response: Response) -> Result<Data> {
        return Response.successRange.contains(response.statusCode) ? Result(response.data) : Result.init <| URLRequestError.invalidResponseStatus(code: response.statusCode)
    }
    
    private static func decode(json data: Data) -> Result<JSONDictionary> {
        do    { return (try JSONSerialization.jsonObject(with: data, options: .allowFragments) >>- _JSONDictionary).toResult <| URLRequestError.couldNotParseJSON }
        catch { return Result(error) }
    }
}


