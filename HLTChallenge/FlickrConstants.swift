//
//  FlickrConstants.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// FIXME: REFACTOR THIS

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
            
            /**
             FlickrConstants.Parameters.Keys.Metadata.method:          FlickrConstants.Parameters.Values.Metadata.Method.getRecent.rawValue,
             FlickrConstants.Parameters.Keys.Metadata.extras:          FlickrConstants.Parameters.Values.Metadata.extras,
             FlickrConstants.Parameters.Keys.Metadata.safeSearch:      FlickrConstants.Parameters.Values.Metadata.SafeSearch.moderate.rawValue,
             FlickrConstants.Parameters.Keys.Metadata.picturesPerPage: FlickrConstants.Parameters.Values.Metadata.picturesPerPage
             */
            
            // MARK: Metadata
            
            struct Metadata {
                static let method          = "method"
                static let picturesPerPage = "per_page"
                static let pageNumber      = "page"
                static let text            = "text"
                static let extras          = "extras"
                static let safeSearch      = "safe_search"

            }
            
//            // MARK: PhotoInfo
//            
//            struct PhotoInfo {
//                static let method  = "method"
//                static let photoID = "photo_id"
//            }
            
            /**
            FlickrConstants.Parameters.Keys.PhotoComments.method: FlickrConstants.Parameters.Values.PhotoComments.method
             */
            
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
            
            /**
             let photosDict  = dict[FlickrConstants.Response.Keys.Metadata.photos]      >>- _JSONDictionary,
             let status      = dict[FlickrConstants.Response.Keys.General.status]       >>- JSONString,
             let photosArray = photosDict[FlickrConstants.Response.Keys.Metadata.photo] >>- JSONArray,
             */
            
            
            /**
             let id      = dict[FlickrConstants.Response.Keys.Metadata.id]          >>- JSONString,
             let url     = dict[FlickrConstants.Response.Keys.Metadata.url]         >>- JSONString,
             let title   = dict[FlickrConstants.Response.Keys.Metadata.title]       >>- JSONString,
             let ownerId = dict[FlickrConstants.Response.Keys.Metadata.ownerID]     >>- JSONString,
             let ownerName = dict[FlickrConstants.Response.Keys.Metadata.ownerName] >>- JSONString
             */
            
            
            // MARK: Metadata
            
            struct Metadata {
                static let photos    = "photos"
                static let photo     = "photo"
                static let title     = "title"
                static let id        = "id"
                static let ownerID   = "owner"
                static let url       = "url_m"
                static let ownerName = "ownername"
            }
            
//            // MARK: PhotoInfo
//            
//            struct PhotoInfo {
//                static let photo    = "photo"
//                static let owner    = "owner"
//                static let username = "username"
//            }
            
            
            /**
             let commentsDict = dict[FlickrConstants.Response.Keys.PhotoComments.comments] >>- _JSONDictionary,
             let status       = dict[FlickrConstants.Response.Keys.General.status]         >>- JSONString,
             status == FlickrConstants.Response.Values.Status.success else { return Result(CreationError.Flickr.comment) }
             guard let commentsArray = commentsDict[FlickrConstants.Response.Keys.PhotoComments.comment] >>- JSONArray else { return Result.init <| .empty }
             */
            
            // MARK: PhotoComments
            
            struct PhotoComments {
                static let id        = "id"
                static let ownerName = "authorname"
                static let ownerID   = "author"
                static let date      = "datecreate"
                static let content   = "_content"
                static let comments  = "comments"
                static let comment   = "comment"
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
