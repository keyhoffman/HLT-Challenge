//
//  Sequence.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/7/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

protocol ResultType {
    associatedtype Value
    var toOptional: Value? { get }
}

struct AnyResult<Value>: ResultType {
    let toOptional: Value?
    
    init<A: ResultType>(_ result: A) where A.Value == Value {
        toOptional = result.toOptional
    }
}

//extension Sequence where Iterator.Element: ResultType {
//    func _inverted<A>() -> [A] where A: ResultType {
//        return <#value#>
//    }
//}



// MARK: - Sequence Extension

// FIXME: Find a way to make this generic!!!!! Possibly with type erasure
extension Sequence where Iterator.Element == Result<FlickrPhotoMetadata> {
    
    /// Transforms an `Array` of `Result` of `FlickrImageMetadata` into
    /// a `Result` of an `Array` of `FlickrImageMetadata`.
    ///
    /// - note: Transformation Structure ====>>  [Result\<FlickrPhotoMetadata\>] -> Result<[FlickrPhotoMetadata]>
    ///
    /// - returns: A `Result` of an `Array` of `FlickrImageMetadata`
    var inverted: Result<[FlickrPhotoMetadata]> {
        return Result.init <| self.flatMap { $0.toOptional }
    }
}

// MARK: - Sequence Extension

// FIXME: Find a way to make this generic!!!!! Possibly with type erasure
extension Sequence where Iterator.Element == Result<UIImage> {
    var inverted: Result<[UIImage]> {
        return Result.init <| self.flatMap { $0.toOptional }
    }
}

// MARK: - Sequence Extension

// FIXME: Find a way to make this generic!!!!! Possibly with type erasure
extension Sequence where Iterator.Element == Result<FlickrPhotoComment> {
    var inverted: Result<[FlickrPhotoComment]> {
        return Result.init <| self.flatMap { $0.toOptional }
    }
}

// MARK: - Sequence Extension

extension Sequence {
    func apply<T>(_ fs: [(Iterator.Element) -> T]) -> [T] {
        return fs.flatMap { self.map($0) }
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
////        return Result.init <| self.map { $0.toOptional() }.flatMap { $0 }
//    }
//}
