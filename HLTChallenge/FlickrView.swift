//
//  FlickrView.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrView

final class FlickrView: UIView, Preparable, Configurable {

    // MARK: - Property Declarations
    
    let flickrPhotoView = FlickrViewStyleSheet.ImageView.flickr.imageView
    
    let titleLabel = FlickrViewStyleSheet.Label.title.label
    
    // MARK: - Preparable Conformance
    
    func prepare() {
        defer { FlickrViewStyleSheet.prepare(self) }
        addSubview(flickrPhotoView)
        addSubview(titleLabel)        
    }
    
    // MARK: - Configurable Conformance
    
    func configure(withData flickrPhoto: FlickrPhoto) {
        defer { prepare() }
        flickrPhotoView.image = flickrPhoto.photo
        titleLabel.text       = flickrPhoto.metadata.title
    }
}
