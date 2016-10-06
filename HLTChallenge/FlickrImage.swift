//
//  FlickrImage.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

struct FlickrImage: Downloadable {
    let id:      String
    let ownerID: String
    let url:     String
}

extension FlickrImage {
    static let urlParameters = [
        FlickrConstants.ParameterKeys.APIKey:          FlickrConstants.ParameterValues.APIKey,
        FlickrConstants.ParameterKeys.Method:          FlickrConstants.ParameterValues.SearchMethod,
        FlickrConstants.ParameterKeys.Extras:          FlickrConstants.ParameterValues.MediumURL,
        FlickrConstants.ParameterKeys.Format:          FlickrConstants.ParameterValues.ResponseFormat,
        FlickrConstants.ParameterKeys.NoJSONCallback:  FlickrConstants.ParameterValues.DisableJSONCallback,
        FlickrConstants.ParameterKeys.SafeSearch:      FlickrConstants.ParameterValues.SafeSearchOn,
        FlickrConstants.ParameterKeys.PicturesPerPage: String(FlickrConstants.ParameterValues.PicturesPerPage)
//        FlickrConstants.ParameterKeys.Text:            searchTerm,
//        FlickrConstants.ParameterKeys.PageNumber:      String(page)
    ]

}




protocol Downloadable {
    static var urlParameters: URLParameters { get }
}


extension Downloadable {
    static func loadPhotos(forPage page: Int, andSearchTerm searchTerm: String = FlickrConstants.ParameterValues.GeneralSearch) {
        
        switch url(from: urlParameters) >>= urlRequest {
        case let .error(error): print(error)
        case let .value(request): print(request)
        }
        
    }
    
    static private func dataTask(request: URLRequest) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            
        }

    }
    
    static private func urlRequest(from url: URL) -> Result<URLRequest> {
        return curry(Result.init) <^> URLRequest(url: url)
    }
    
    static private func url(from parameters: URLParameters) -> Result<URL> {
        var components        = URLComponents()
        components.scheme     = FlickrConstants.API.Scheme
        components.host       = FlickrConstants.API.Host
        components.path       = FlickrConstants.API.Path
        components.queryItems = parameters.map(urlQueryItem)
        
        return components.url.toResult(with:) <^> URLRequestError.invalidURL(parameters: parameters)
    }
    
    static private func urlQueryItem(from name: String, and value: String?) -> URLQueryItem {
        return URLQueryItem(name: name, value: value)
    }
}
