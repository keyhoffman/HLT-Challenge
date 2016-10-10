//
//  JSON.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/10/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

func JSONObject<A>(from object: AnyObject) -> A? {
    return object as? A
}

func JSONString(from object: AnyObject) -> String? {
    return object as? String
}

// TODO: Find a better name for this function
func _JSONDictionary(from object: AnyObject) -> JSONDictionary? {
    return object as? JSONDictionary
}

func JSONArray(from object: AnyObject) -> [JSONDictionary]? {
    return object as? [JSONDictionary]
}
