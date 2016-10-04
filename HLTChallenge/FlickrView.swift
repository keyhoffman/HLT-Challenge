//
//  FlickrView.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

final class FlickrView: UIView, Prerparable, Configurable {

    let flickrImageView = FlickrViewStyleSheet.ImageView.flickr.imageView
    
    convenience init() {
        self.init()
        defer { prepare() }
    }
    
    
    func prepare() {
        defer { FlickrViewStyleSheet.prepare(self) }
        addSubview(flickrImageView)
    }
    
    func configure(withData image: UIImage) {
        flickrImageView.image = image
    }
}
