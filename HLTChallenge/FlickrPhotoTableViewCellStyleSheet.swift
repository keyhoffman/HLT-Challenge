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
        
        // MARK: AutoLayout
        
        photoCell.flickrView.translatesAutoresizingMaskIntoConstraints = false
        
        let flickrViewTop      = curry(NSLayoutConstraint.init) <^> photoCell.flickrView <^> .top      <^> .equal <^> photoCell <^> .top      <^> 1 <^> 0
        let flickrViewBottom   = curry(NSLayoutConstraint.init) <^> photoCell.flickrView <^> .bottom   <^> .equal <^> photoCell <^> .bottom   <^> 1 <^> 0
        let flickrViewLeading  = curry(NSLayoutConstraint.init) <^> photoCell.flickrView <^> .leading  <^> .equal <^> photoCell <^> .leading  <^> 1 <^> 0
        let flickrViewTrailing = curry(NSLayoutConstraint.init) <^> photoCell.flickrView <^> .trailing <^> .equal <^> photoCell <^> .trailing <^> 1 <^> 0
        
        let flickrViewConstraints = [flickrViewTop, flickrViewBottom, flickrViewLeading, flickrViewTrailing]
        
        NSLayoutConstraint.activate <^> flickrViewConstraints
    }
    
    // MARK: - View
    
    enum View: Int {
        case flickr = 1
        
        var view: UIView {
            let v                                       = _view
            v.tag                                       = rawValue
            v.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
            return v
        }
        
        private var _view: UIView {
            switch self {
            case .flickr: return FlickrView()
            }
        }
        
        private var translatesAutoresizingMaskIntoConstraints: Bool {
            switch self {
            case .flickr: return false
            }
        }
        
    }
}
