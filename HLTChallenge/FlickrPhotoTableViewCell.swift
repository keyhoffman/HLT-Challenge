//
//  FlickrTableViewCell.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrPhotoTableViewCell

final class FlickrPhotoTableViewCell: UITableViewCell, PreparedConfigurable {
    
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
    
    func configure(_ flickrPhoto: FlickrPhoto) {
        flickrView.configure(flickrPhoto)
    }
}

// MARK: - FlickrPhotoTableViewCellStyleSheet

fileprivate struct FlickrPhotoTableViewCellStyleSheet: ViewPreparer {
    
    // MARK: - ViewPreparer Conformance
    
    fileprivate static func prepare(_ photoCell: FlickrPhotoTableViewCell) {
        
        defer { photoCell.layoutIfNeeded() }
        
        photoCell.backgroundColor = .darkText
        photoCell.selectionStyle  = .none
        
        // MARK: AutoLayout
        
        photoCell.flickrView.translatesAutoresizingMaskIntoConstraints = false
        
        let flickrViewTop      = ¿NSLayoutConstraint.init <| photoCell.flickrView <| .top      <| .equal <| photoCell <| .top      <| 1 <| 0
        let flickrViewBottom   = ¿NSLayoutConstraint.init <| photoCell.flickrView <| .bottom   <| .equal <| photoCell <| .bottom   <| 1 <| 0
        let flickrViewLeading  = ¿NSLayoutConstraint.init <| photoCell.flickrView <| .leading  <| .equal <| photoCell <| .leading  <| 1 <| 0
        let flickrViewTrailing = ¿NSLayoutConstraint.init <| photoCell.flickrView <| .trailing <| .equal <| photoCell <| .trailing <| 1 <| 0
        
        let flickrViewConstraints = [flickrViewTop, flickrViewBottom, flickrViewLeading, flickrViewTrailing]
        
        NSLayoutConstraint.activate <| flickrViewConstraints
    }
}
