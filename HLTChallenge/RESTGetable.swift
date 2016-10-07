//
//  Downloadable.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

protocol RESTGetable: Equatable, ResultRepresentable {
    static var urlQueryParameters:   URLParameters { get }
    static var urlAddressParameters: URLParameters { get }
    
    static func create(from dictionary: JSONDictionary) -> Result<Self>
}

extension RESTGetable {
    static var scheme: String {
        return "scheme"
    }
    
    static var host: String {
        return "host"
    }
    
    static var path: String {
        return "path"
    }
}

extension RESTGetable {
    static func get(withBlock block: @escaping (Result<Self>) -> Void) {
        switch url() >>= urlRequest {
        case let .error(error):   block <^> Result(error)
        case let .value(request): dataTask(request: request, withBlock: block)
        }
    }
}

extension RESTGetable {
    static fileprivate func dataTask(request: URLRequest, withBlock block: @escaping (Result<Self>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                block <^> (processDataTask(date: data, response: response, error: error) >>= Self.create)
            }
        }.resume()
    }
    
    static func processDataTask(date: Data?, response: URLResponse?, error: Error?) -> Result<JSONDictionary> {
        return (Result(error, Response(data: date, urlResponse: response)) >>= parseResponse) >>= decodeJSON
    }
    
    static private func parseResponse(response: Response) -> Result<Data> {
        let successRange = 200..<300
        return successRange.contains(response.statusCode) ? Result(response.data) : curry(Result.init) <^> URLRequestError.invalidResponseStatus(code: response.statusCode)
    }
    
    static private func decodeJSON(from data: Data) -> Result<JSONDictionary> {
        do {
            guard let decodedJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSONDictionary else { return Result(URLRequestError.couldNotParseJSON) }
            return Result(decodedJSON)
        } catch {
            return Result(error)
        }
    }
}

extension RESTGetable {
    static func urlRequest(from url: URL) -> Result<URLRequest> {
        return curry(Result.init) <^> URLRequest(url: url)
    }
    
    static func url() -> Result<URL> {
        guard let compontentsPath = urlAddressParameters[path] else { return curry(Result.init) <^> URLRequestError.invalidURLPath(path: urlAddressParameters[path]) }
        
        var components        = URLComponents()
        components.path       = compontentsPath
        components.scheme     = urlAddressParameters[scheme]
        components.host       = urlAddressParameters[host]
        components.queryItems = urlQueryParameters.map(URLQueryItem.init)
        
        return components.url.toResult(withError:) <^> URLRequestError.invalidURL(parameters: urlQueryParameters)
    }
}


