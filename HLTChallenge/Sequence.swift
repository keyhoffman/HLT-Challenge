//
//  Sequence.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/7/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// FIXME: Find a way to make this generic!!!!!
extension Sequence where Iterator.Element == Result<FlickrImageMetadata> {
    
    /// Transforms an `Array` of `Result` of `FlickrImageMetadata` into
    /// a `Result` of an `Array` of `FlickrImageMetadata`.
    ///
    /// - note: Transformation Structure --  [Result\<FlickrImageMetadata\>] -> Result<[FlickrImageMetadata]>
    ///
    /// - returns: A `Result` of an `Array` of `FlickrImageMetadata`
    func invert() -> Result<[FlickrImageMetadata]> {
        return curry(Result.init) <^> self.map { $0.toOptional() }.flatMap { $0 }
    }
}
