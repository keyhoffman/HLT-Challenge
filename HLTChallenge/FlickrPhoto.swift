//
//  FlickrPhoto.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/8/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrPhoto

struct FlickrPhoto: Equatable {
    let photo:    UIImage
    let metadata: FlickrPhotoMetadata
}

// MARK: - Equatable Conformance

func == (_ lhs: FlickrPhoto, _ rhs: FlickrPhoto) -> Bool {
    return lhs.metadata == rhs.metadata
}
