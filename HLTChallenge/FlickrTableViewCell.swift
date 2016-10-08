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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        defer { prepare() }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func prepare() {
        defer { FlickrTableViewCellStyleSheet.prepare(self) }
        addSubview(flickrView)
    }
    
    func configure(withData flickrPhoto: FlickrPhoto) {
        flickrView.configure(withData: flickrPhoto)
    }
}
