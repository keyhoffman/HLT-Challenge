//
//  FlickrTableViewCellStyleSheet.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrPhotoTableViewCellStyleSheet

struct FlickrPhotoTableViewCellStyleSheet: ViewPreparer {
    
    // MARK: - ViewPreparer Conformance
    
    static func prepare(_ photoCell: FlickrPhotoTableViewCell) {
        
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
