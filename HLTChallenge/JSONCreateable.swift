//
//  JSONCreateable.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/25/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - JSONCreatable Protocol

protocol JSONCreatable: Equatable {
    static func create(from dictionary: JSONDictionary) -> Result<Self>
}

extension JSONCreatable {
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
