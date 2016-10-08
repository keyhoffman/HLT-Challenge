//
//  FlickrViewStyleSheet.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

struct FlickrViewStyleSheet: ViewPreparer {
    
    static private let titleLabelBottomToFlickrViewTopOffsetByViewHeightFactor: CGFloat = 0.8
    
    static func prepare(_ flickrView: FlickrView) {
        
        defer { flickrView.layoutSubviews() }
        
        flickrView.backgroundColor = .green
        
        // MARK: AutoLayout
        
        let titleLabelBottomToFlickrViewTopOffset = titleLabelBottomToFlickrViewTopOffsetByViewHeightFactor * flickrView.frame.height
        
        
        let flickrImageViewTop      = curry(NSLayoutConstraint.init) <^> flickrView.flickrImageView <^> .top      <^> .equal <^> flickrView <^> .top      <^> 1 <^> 0
        let flickrImageViewBottom   = curry(NSLayoutConstraint.init) <^> flickrView.flickrImageView <^> .bottom   <^> .equal <^> flickrView <^> .bottom   <^> 1 <^> 0
        let flickrImageViewLeading  = curry(NSLayoutConstraint.init) <^> flickrView.flickrImageView <^> .leading  <^> .equal <^> flickrView <^> .leading  <^> 1 <^> 0
        let flickrImageViewTrailing = curry(NSLayoutConstraint.init) <^> flickrView.flickrImageView <^> .trailing <^> .equal <^> flickrView <^> .trailing <^> 1 <^> 0
        
        let flickrImageViewConstraints = [flickrImageViewTop, flickrImageViewBottom, flickrImageViewLeading, flickrImageViewTrailing]
        
        let titleLabelTop      = curry(NSLayoutConstraint.init) <^> flickrView.titleLabel <^> .top      <^> .equal <^> flickrView <^> .topMargin      <^> 1 <^> 0
        let titleLabelBottom   = curry(NSLayoutConstraint.init) <^> flickrView.titleLabel <^> .bottom   <^> .equal <^> flickrView <^> .top            <^> 1 <^> titleLabelBottomToFlickrViewTopOffset
        let titleLabelLeading  = curry(NSLayoutConstraint.init) <^> flickrView.titleLabel <^> .leading  <^> .equal <^> flickrView <^> .leadingMargin  <^> 1 <^> 0
        let titleLabelTrailing = curry(NSLayoutConstraint.init) <^> flickrView.titleLabel <^> .trailing <^> .equal <^> flickrView <^> .trailingMargin <^> 1 <^> 0
        
        let titleLabelConstraints = [titleLabelTop, titleLabelBottom, titleLabelLeading, titleLabelTrailing]
        
        let activeConstraints = titleLabelConstraints + flickrImageViewConstraints
        
        NSLayoutConstraint.activate(activeConstraints)
        
    }
    
    // MARK: Label
    
    enum Label: Int {
        case title = 1
        
        var label: UILabel {
            let l                                       = UILabel()
            l.tag                                       = rawValue
            l.backgroundColor                           = backgroundColor
            l.textColor                                 = textColor
            l.textAlignment                             = textAlignment
            l.numberOfLines                             = numberOfLines
            l.adjustsFontSizeToFitWidth                 = adjustsFontSizeToFitWidth
            l.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
            return l
        }
        
        private var backgroundColor: UIColor {
            switch self {
            case .title: return #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 0.470515839)
            }
        }
        
        private var textColor: UIColor {
            switch self {
            case .title: return .black
            }
        }
        
        private var textAlignment: NSTextAlignment {
            switch self {
            case .title: return .center
            }
        }
        
        private var numberOfLines: Int {
            switch self {
            case .title: return 2
            }
        }
        
        private var adjustsFontSizeToFitWidth: Bool {
            switch self {
            case .title: return true
            }
        }
        
        private var translatesAutoresizingMaskIntoConstraints: Bool {
            switch self {
            case .title: return false
            }
        }
    }
    
    // MARK: ImageView
    
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
