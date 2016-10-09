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
    
    // MARK: - API
    
    struct API {
        static let scheme = "https"
        static let host   = "api.flickr.com"
        static let path   = "/services/rest"
    }
    
    // MARK: - Parameters
    
    struct Parameters {
        
        // MARK: - Keys
        
        struct Keys {
            
            // MARK: General
            
            struct General {
                static let apiKey          = "api_key"
                static let responseFormat  = "format"
                static let noJSONCallback  = "nojsoncallback"
            }
            
            // MARK: Metadata
            
            struct Metadata {
                static let method          = "method"
                static let picturesPerPage = "per_page"
                static let pageNumber      = "page"
                static let text            = "text"
                static let extras          = "extras"
                static let safeSearch      = "safe_search"

            }
            
            // MARK: PhotoInfo
            
            struct PhotoInfo {
                static let method  = "method"
                static let photoID = "photo_id"
            }
            
            // MARK: PhotoComments
            
            struct PhotoComments {
                static let method  = "method"
                static let photoID = "photo_id"
            }
        }
        
        // MARK: - Values
        
        struct Values {
            
            // MARK: General
            
            struct General {
                static let apiKey         = "c9025518af10cb3bb1ec3fd80ea2fd52"
                static let responseFormat = "json"
                static let noJSONCallback = "1"
                
            }
            
            // MARK: Metadata
            
            struct Metadata {
                static let search          = "flickr.photos.search"
                static let getRecent       = "flickr.photos.getRecent"
                static let picturesPerPage = "20"
                static let pageNumber      = "1"
                static let extras          = "url_m"
                static let safeSearch      = "1"
                
            }
            
            // MARK: PhotoInfo
            
            struct PhotoInfo {
                static let method = "flickr.photos.getInfo"
            }
            
            // MARK: PhotoComments
            
            struct PhotoComments {
                static let method = "flickr.photos.comments.getList"
            }
        }
    }
    
    // MARK: - Response
    
    struct Response {
        
        // MARK: - Keys
        
        struct Keys {
            
            // MARK: General
            
            struct General {
                static let status = "stat"
            }
            
            // MARK: Metadata
            
            struct Metadata {
                static let photos  = "photos"
                static let photo   = "photo"
                static let title   = "title"
                static let id      = "id"
                static let ownerID = "owner"
                static let url     = "url_m"
            }
            
            // MARK: PhotoInfo
            
            struct PhotoInfo {
                static let photo    = "photo"
                static let owner    = "owner"
                static let username = "username"
            }
            
            // MARK: PhotoComments
            
            struct PhotoComments {
                static let id       = "id"
                static let author   = "authorname"
                static let content  = "_content"
                static let comments = "comments"
                static let comment  = "comment"
            }
        }
        
        // MARK: - Values
        
        struct Values {
            
            // MARK: General
            
            struct General {
                
                // MARK: Status
                
                struct Status {
                    static let error   = "fail"
                    static let success = "ok"
                }
            }
        }
    }
}
