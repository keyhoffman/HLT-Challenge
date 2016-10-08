//
//  FlickrConstants.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - FlickrConstants

struct FlickrConstants {
    
    // MARK: API
    
    struct API {
        static let scheme = "https"
        static let host   = "api.flickr.com"
        static let path   = "/services/rest"
    }
    
    // MARK: Parameter Keys
    
    struct ParameterKeys {
        static let method          = "method"
        static let apiKey          = "api_key"
        static let userID          = "user_id"
        static let text            = "text"
        static let extras          = "extras"
        static let pageNumber      = "page"
        static let format          = "format"
        static let noJSONCallback  = "nojsoncallback"
        static let picturesPerPage = "per_page"
        static let safeSearch      = "safe_search"
    }
    
    // MARK: Parameter Values
    
    struct ParameterValues {
        static let publicPhotosMethod  = "flickr.people.getPublicPhotos"
        static let searchMethod        = "flickr.photos.search"
        static let apiKey              = "c9025518af10cb3bb1ec3fd80ea2fd52"
        static let userID              = "90967382@N07"
        static let generalSearch       = "general"
        static let responseFormat      = "json"
        static let disableJSONCallback = "1"
        static let mediumURL           = "url_m"
        static let picturesPerPage     = "20"
        static let pageNumber          = "1"
        static let safeSearchOn        = "1"
        static let safeSearchOff       = "0"
    }
    
    // MARK: Response Keys
    
    struct ResponseKeys {
        static let status     = "stat"
        static let photos     = "photos"
        static let photo      = "photo"
        static let title      = "title"
        static let id         = "id"
        static let ownerID    = "owner"
        static let mediumURL  = "url_m"
        static let totalPages = "pages"
        static let total      = "total"
    }
    
    // MARK: Response Values
    
    struct ResponseValues {
        static let okStatus            = "ok"
        static let maxPicturesReturned = 4000
    }
}
