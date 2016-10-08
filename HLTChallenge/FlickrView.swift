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
    
    let titleLabel = FlickrViewStyleSheet.Label.title.label
    
//    init() {
//        super.init(frame: .zero)
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func prepare() {
        defer { FlickrViewStyleSheet.prepare(self) }
        addSubview(flickrImageView)
        addSubview(titleLabel)
    }
    
    func configure(withData flickrPhoto: FlickrPhoto) {
        defer { prepare() }
        flickrImageView.image = flickrPhoto.photo
        titleLabel.text       = flickrPhoto.metadata.title
    }
}
