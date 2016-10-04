//
//  FlickrTableViewCell.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

final class FlickrTableViewCell: UITableViewCell, Configurable, Prerparable {
    
    // FIXEME: FlickrTableViewCellStyleSheet.View.flickr.view
    let flickrView = FlickrView()
    
    convenience init() {
        self.init()
        defer { prepare() }
    }
    
    func prepare() {
        defer { FlickrTableViewCellStyleSheet.prepare(self) }
        addSubview(flickrView)
    }
    
    func configure(withData image: UIImage) {
        flickrView.configure(withData: image)
    }
}
