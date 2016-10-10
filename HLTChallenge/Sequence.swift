//
//  Sequence.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/7/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// FIXME: Find a way to make this generic!!!!! Possibly with type erasure
extension Sequence where Iterator.Element == Result<FlickrPhotoMetadata> {
    
    /// Transforms an `Array` of `Result` of `FlickrImageMetadata` into
    /// a `Result` of an `Array` of `FlickrImageMetadata`.
    ///
    /// - note: Transformation Structure ====>>  [Result\<FlickrImageMetadata\>] -> Result<[FlickrImageMetadata]>
    ///
    /// - returns: A `Result` of an `Array` of `FlickrImageMetadata`
    func invert() -> Result<[FlickrPhotoMetadata]> {
        return curry(Result.init) <^> self.flatMap { $0.toOptional() }
    }
}

// FIXME: Find a way to make this generic!!!!! Possibly with type erasure
extension Sequence where Iterator.Element == Result<UIImage> {
    func invert() -> Result<[UIImage]> {
        return curry(Result.init) <^> self.flatMap { $0.toOptional() }
    }
}

// FIXME: Find a way to make this generic!!!!! Possibly with type erasure
extension Sequence where Iterator.Element == Result<FlickrPhotoComment> {
    func invert() -> Result<[FlickrPhotoComment]> {
        return curry(Result.init) <^> self.flatMap { $0.toOptional() }
    }
}

//typealias GenericResult<T: ResultRepresentable> = Result<T>
//
//
//extension Sequence where Iterator.Element: ResultType {
//    func invert<A>() -> Result<A> where A: ResultRepresentable {
//        
//        let foo = self.map { $0.toOptional() }.flatMap { $0 }
//        
//        let faa = self.flatMap { $0.toOptional() }
//        
//        return Result(faa)
//        
////        return curry(Result.init) <^> self.map { $0.toOptional() }.flatMap { $0 }
//    }
//}
