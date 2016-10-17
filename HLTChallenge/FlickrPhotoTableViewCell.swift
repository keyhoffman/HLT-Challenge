//
//  FlickrTableViewCell.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrPhotoTableViewCell

final class FlickrPhotoTableViewCell: UITableViewCell, Configurable, Preparable {
    
    // MARK: - Property Declarations
    
    let flickrView = FlickrView()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        defer { prepare() }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Preparable Conformance
    
    func prepare() {
        defer { FlickrPhotoTableViewCellStyleSheet.prepare(self) }
        addSubview(flickrView)
    }
    
    // MARK: - Configurable Conformance
    
    func configure(withData flickrPhoto: FlickrPhoto) {
        flickrView.configure(withData: flickrPhoto)
    }
}
