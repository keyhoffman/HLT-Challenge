//
//  FlickrPhotoMetadataTests.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/15/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import XCTest
@testable import HLTChallenge

// MARK: - FlickrPhotoMetadataTests

class FlickrPhotoMetadataTests: XCTestCase {
    
    // MARK: - Mocks
    
    private let urlAddressParameters: URLParameters = [
        "host":   FlickrConstants.API.host,
        "path":   FlickrConstants.API.path,
        "scheme": FlickrConstants.API.scheme
    ]
    
    private let urlGeneralQueryParameters: URLParameters = [
        FlickrConstants.Parameters.Keys.General.apiKey:         FlickrConstants.Parameters.Values.General.apiKey,
        FlickrConstants.Parameters.Keys.General.responseFormat: FlickrConstants.Parameters.Values.General.responseFormat,
        FlickrConstants.Parameters.Keys.General.noJSONCallback: FlickrConstants.Parameters.Values.General.noJSONCallback
    ]
    
    
    private var urlQueryParameters: URLParameters {
        return urlGeneralQueryParameters + [
            FlickrConstants.Parameters.Keys.Metadata.method:          FlickrConstants.Parameters.Values.Metadata.Method.getRecent.rawValue,
            FlickrConstants.Parameters.Keys.Metadata.extras:          FlickrConstants.Parameters.Values.Metadata.extras,
            FlickrConstants.Parameters.Keys.Metadata.safeSearch:      FlickrConstants.Parameters.Values.Metadata.SafeSearch.moderate.rawValue,
            FlickrConstants.Parameters.Keys.Metadata.picturesPerPage: FlickrConstants.Parameters.Values.Metadata.picturesPerPage
        ]
    }
    
    private let mockUrlString = "https://api.flickr.com/services/rest?format=json&method=flickr.photos.getRecent&api_key=c9025518af10cb3bb1ec3fd80ea2fd52&per_page=10&safe_search=2&extras=url_m,%20owner_name&nojsoncallback=1"
    
    private lazy var mockURL: URL = { URL(string: self.mockUrlString)! }()
    
    private lazy var mockURLRequest: URLRequest = { URLRequest(url: self.mockURL) }()
    
    // MARK: - Tests
    
    func test_FlickrPhotoMetadata_URL() {
        let urlResult = FlickrPhotoMetadata.url()
        
        switch urlResult {
        case .error(let error): XCTAssertNil(error, "URL creation error:\(error)")
        case .value(let url):
            XCTAssertNotNil(url, "FlickrPhotoMetadata URL does not exist")
            XCTAssertEqual(url, mockURL, "FlickrPhotoMetadata url does not match mockURL")
        }
    }
    
    func test_FlickrPhotoMetadata_URLRequest() {
        let urlRequestResult = FlickrPhotoMetadata.urlRequest(from: mockURL)
        
        switch urlRequestResult {
        case .error(let error): XCTAssertNil(error, "URL creation error:\(error)")
        case .value(let request):
            XCTAssertNotNil(request, "FlickrPhotoMetadata URLRequest does not exist")
            XCTAssertEqual(request, mockURLRequest, "FlickrPhotoMetadata URLRequest does not match mockURLRequest")
        }
    }
    
    func test_FlickrPhotoMetadata_URLSessionDataTaskResponseInitialization() {
        
        let _expectation = expectation(description: "DataTask for URLRequest: \(mockURLRequest)")
    
        let task = URLSession.shared.dataTask(with: mockURLRequest) { dataTaskData, dataTaskResponse, dataTaskError in
            
            let response = Response(data: dataTaskData, urlResponse: dataTaskResponse)
            
            XCTAssertNil(dataTaskError, "Error should be nil")
            XCTAssertNotNil(dataTaskData, "Data should not be nil")
            XCTAssertNotNil(dataTaskResponse, "URLResponse should not be nil")
            
            XCTAssertNotNil(response, "Response should not be nil")
            XCTAssertEqual(self.mockURLRequest.url?.absoluteString, (dataTaskResponse as? HTTPURLResponse)?.url?.absoluteString, "The request and response URLs do not match")
            XCTAssertEqual(response?.statusCode, 200, "Response status code does not equal 200")
            
            _expectation.fulfill()
        }
        
        task.resume()
        
        waitForExpectations(timeout: 6) { error in
            defer { task.cancel() }
            guard let error = error else { return }
            print("Error:", error.localizedDescription)
        }
        
    }
}
