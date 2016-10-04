//
//  FlickrViewStyleSheet.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

struct FlickrViewStyleSheet: ViewPreparer {
    
    static func prepare(_ flickrView: FlickrView) {
        
        defer { flickrView.layoutSubviews() }
        
        // MARK: AutoLayout
        
        flickrView.backgroundColor = .red
        
//        flickrView.flickrImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let flickrImageViewTop      = curry(NSLayoutConstraint.init) <^> flickrView.flickrImageView <^> .top      <^> .equal <^> flickrView <^> .top      <^> 1 <^> 0
        let flickrImageViewBottom   = curry(NSLayoutConstraint.init) <^> flickrView.flickrImageView <^> .bottom   <^> .equal <^> flickrView <^> .bottom   <^> 1 <^> 0
        let flickrImageViewLeading  = curry(NSLayoutConstraint.init) <^> flickrView.flickrImageView <^> .leading  <^> .equal <^> flickrView <^> .leading  <^> 1 <^> 0
        let flickrImageViewTrailing = curry(NSLayoutConstraint.init) <^> flickrView.flickrImageView <^> .trailing <^> .equal <^> flickrView <^> .trailing <^> 1 <^> 0
        
        let flickrImageViewConstraints = [flickrImageViewTop, flickrImageViewBottom, flickrImageViewLeading, flickrImageViewTrailing]
        
        let activeConstraints = flickrImageViewConstraints
        
        NSLayoutConstraint.activate(activeConstraints)
        
    }
    
    // MARK ImageView
    
    enum ImageView: Int {
        case flickr = 1
        
        var imageView: UIImageView {
            let iv                                       = UIImageView()
            iv.tag                                       = rawValue
            iv.contentMode                               = contentMode
            iv.layer.masksToBounds                       = maskLayerToBounds
            iv.clipsToBounds                             = clipsToBounds
            iv.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
            return iv
        }
        
        private var translatesAutoresizingMaskIntoConstraints: Bool {
            switch self {
            case .flickr: return false
            }
        }
        
        private var contentMode: UIViewContentMode {
            switch self {
            case .flickr: return .scaleAspectFill
            }
        }
        
        private var maskLayerToBounds: Bool {
            switch self {
            case .flickr: return true
            }
        }
        
        private var clipsToBounds: Bool {
            switch self {
            case .flickr: return true
            }
        }
    }
}
