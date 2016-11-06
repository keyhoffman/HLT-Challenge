//
//  FlickrCollectionElement.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/26/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - FlickrCollectionElement Protocol

protocol FlickrCollectionElement: JSONCreatable, Hashable {
    var id:      String { get }
    var ownerID: String { get }
}

// MARK: - Hashable Conformance

extension FlickrCollectionElement {
    var hashValue: Int { return id.hashValue ^ ownerID.hashValue }
}

// MARK: - Equatable Conformance

func == <T>(_ lhs: T, _ rhs: T) -> Bool where T: FlickrCollectionElement {
    return lhs.hashValue == rhs.hashValue
}
