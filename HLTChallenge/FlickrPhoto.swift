//
//  FlickrPhoto.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/8/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrPhoto

struct FlickrPhoto: ResultRepresentable {
    let photo:    UIImage
    let metadata: FlickrPhotoMetadata
}

extension FlickrPhoto {
    static func create(photo: UIImage, metadata: FlickrPhotoMetadata) -> Result<FlickrPhoto> {
        return curry(Result.init) <^> FlickrPhoto(photo: photo, metadata: metadata)
    }
}
