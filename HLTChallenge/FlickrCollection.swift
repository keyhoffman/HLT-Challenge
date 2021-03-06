//
//  FlickrCollection.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/25/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - FlickrCollection Protocol

protocol FlickrCollection: FlickrAPIGetable, Collection, EmptyInitializable {
    associatedtype FlickrElement: FlickrCollectionElement
    var elements: Set<FlickrElement> { get }
    init(from array: [FlickrElement])
}

// MARK: - Collection Conformance

extension FlickrCollection {
    typealias FlickrIndex = SetIndex<FlickrElement>
    
    var startIndex: FlickrIndex { return elements.startIndex }
    var endIndex:   FlickrIndex { return elements.endIndex }
    
    subscript(i: FlickrIndex) -> FlickrElement {
        return elements[i]
    }
    
    func index(after i: FlickrIndex) -> FlickrIndex {
        return elements.index(after: i)
    }
}

// MARK: - Equatable Conformance

func == <T>(_ lhs: T, _ rhs: T) -> Bool where T: FlickrCollection {
    return lhs.elements == rhs.elements
}
