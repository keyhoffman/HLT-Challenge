//
//  FlickrTableViewCellStyleSheet.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

struct FlickrTableViewCellStyleSheet: ViewPreparer {
    
    static func prepare(_ flickrCell: FlickrTableViewCell) {
        
        defer { flickrCell.layoutSubviews() }
        
        // MARK: AutoLayout
        
        flickrCell.backgroundColor = .green
        
        flickrCell.flickrView.translatesAutoresizingMaskIntoConstraints = false
        
        let flickrViewTop      = curry(NSLayoutConstraint.init) <^> flickrCell.flickrView <^> .top <^> .equal <^> flickrCell <^> .top <^> 1 <^> 0
        let flickrViewBottom   = curry(NSLayoutConstraint.init) <^> flickrCell.flickrView <^> .top <^> .equal <^> flickrCell <^> .top <^> 1 <^> 0
        let flickrViewLeading  = curry(NSLayoutConstraint.init) <^> flickrCell.flickrView <^> .top <^> .equal <^> flickrCell <^> .top <^> 1 <^> 0
        let flickrViewTrailing = curry(NSLayoutConstraint.init) <^> flickrCell.flickrView <^> .top <^> .equal <^> flickrCell <^> .top <^> 1 <^> 0
        
        let flickrViewConstraints = [flickrViewTop, flickrViewBottom, flickrViewLeading, flickrViewTrailing]
        
        let activeConstraints = flickrViewConstraints
        
        NSLayoutConstraint.activate(activeConstraints)
    }
    
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
