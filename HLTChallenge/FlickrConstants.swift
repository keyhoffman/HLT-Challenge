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
        static let Scheme = "https"
        static let Host   = "api.flickr.com"
        static let Path   = "/services/rest"
    }
    
    // MARK: Parameter Keys
    
    struct ParameterKeys {
        static let Method          = "method"
        static let APIKey          = "api_key"
        static let UserID          = "user_id"
        static let Text            = "text"
        static let Extras          = "extras"
        static let PageNumber      = "page"
        static let Format          = "format"
        static let NoJSONCallback  = "nojsoncallback"
        static let PicturesPerPage = "per_page"
        static let SafeSearch      = "safe_search"
    }
    
    // MARK: Parameter Values
    
    struct ParameterValues {
        static let PublicPhotosMethod  = "flickr.people.getPublicPhotos"
        static let SearchMethod        = "flickr.photos.search"
        static let APIKey              = "c9025518af10cb3bb1ec3fd80ea2fd52"
        static let UserID              = "90967382@N07"
        static let GeneralSearch       = "general"
        static let ResponseFormat      = "json"
        static let DisableJSONCallback = "1"
        static let MediumURL           = "url_m"
        static let PicturesPerPage     = 2
        static let PageNumber          = "1"
        static let SafeSearchOn        = "1"
        static let SafeSearchOff       = "0"
    }
    
    // MARK: Response Keys
    
    struct ResponseKeys {
        static let Status     = "stat"
        static let Photos     = "photos"
        static let Photo      = "photo"
        static let Title      = "title"
        static let mediumURL  = "url_m"
        static let TotalPages = "pages"
        static let Total      = "total"
    }
    
    // MARK: Response Values
    
    struct ResponseValues {
        static let OKStatus            = "ok"
        static let MaxPicturesReturned = 4000
    }
}
