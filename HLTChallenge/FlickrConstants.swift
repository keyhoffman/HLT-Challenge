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
            
            // MARK: - MetadataCollection
            
            struct MetadataCollection {
                static let method          = "method"
                static let picturesPerPage = "per_page"
                static let pageNumber      = "page"
                static let text            = "text"
                static let extras          = "extras"
                static let safeSearch      = "safe_search"
            }
            
            // MARK: CommentCollection
            
            struct CommentCollection {
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
            
            // MARK: MetadataCollection
            
            struct MetadataCollection {
                static let picturesPerPage = "10"
                static let extras          = "url_m, owner_name"
                
                enum Method: String {
                    case search    = "flickr.photos.search"
                    case getRecent = "flickr.photos.getRecent"
                }
                
                enum SafeSearch: String {
                    case safe = "1", moderate = "2", restricted = "3"
                }
            }
            
            // MARK: CommentCollection
            
            struct CommentCollection {
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
            
            // MARK: - MetadataCollection
            
            struct MetadataCollection {
                static let photoDictionary = "photos"
                static let photoArray      = "photo"
            }
            
            // MARK: Metadata
            
            struct Metadata {
                static let title     = "title"
                static let id        = "id"
                static let ownerID   = "owner"
                static let url       = "url_m"
                static let ownerName = "ownername"
            }
            
            // MARK: - CommentCollection
            
            struct CommentCollection {
                static let commentDictionary = "comments"
                static let commentArray      = "comment"
            }
            
            // MARK: Comment
            
            struct Comment {
                static let id        = "id"
                static let ownerName = "authorname"
                static let ownerID   = "author"
                static let date      = "datecreate"
                static let content   = "_content"
            }
        }
        
        // MARK: - Values
        
        struct Values {
                
            // MARK: Status
            
            struct Status {
                static let error   = "fail"
                static let success = "ok"
            }
        }
    }
}
