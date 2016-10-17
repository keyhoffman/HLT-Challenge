//
//  FlickrView.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrView

final class FlickrView: UIView, Preparable, Configurable {

    // MARK: - Property Declarations
    
    let flickrPhotoView = FlickrViewStyleSheet.ImageView.flickr.imageView
    
    let titleLabel = FlickrViewStyleSheet.Label.title.label
    
    let blurView = FlickrViewStyleSheet.VisualEffectView.titleBlur.visualEffectView
    
    private lazy var blurViewWidth: NSLayoutConstraint = {
        return curry(NSLayoutConstraint.init) <^> self.blurView <^> .width <^> .equal <^> self <^> .width <^> .twenty <^> 0
    }()

    // MARK: - Preparable Conformance
    
    func prepare() {
        defer {
            setInitialBlurViewConstraints()
            FlickrViewStyleSheet.prepare(self)
        }
        addSubview(flickrPhotoView)
        addSubview(blurView)
        blurView.contentView.addSubview(titleLabel)
        blurView.addGestureRecognizer <^> UITapGestureRecognizer(target: self, action: #selector(displayPhotoTitle))
    }
    
    private func setInitialBlurViewConstraints() {
        let blurViewTop      = curry(NSLayoutConstraint.init) <^> blurView <^> .top      <^> .equal <^> self <^> .topMargin      <^> 1       <^> 0
        let blurViewHeight   = curry(NSLayoutConstraint.init) <^> blurView <^> .height   <^> .equal <^> self <^> .height         <^> .seven  <^> 0
        let blurViewLeading  = curry(NSLayoutConstraint.init) <^> blurView <^> .leading  <^> .equal <^> self <^> .leadingMargin  <^> 1       <^> 0
        
        let blurViewConstraints = [blurViewTop, blurViewHeight, blurViewLeading, blurViewWidth]
        
        NSLayoutConstraint.activate(blurViewConstraints)
    }
    
    // MARK: - Configurable Conformance
    
    func configure(withData flickrPhoto: FlickrPhoto) {
        defer { prepare() }
        flickrPhotoView.image = flickrPhoto.photo
        titleLabel.text       = "title"
        flickrPhotoMetadata   = flickrPhoto.metadata
    }
    
    private var flickrPhotoMetadata: FlickrPhotoMetadata?
    
    dynamic private func displayPhotoTitle() {
        layoutIfNeeded()
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: .ninety, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { [weak self] in
            self?.blurViewWidth.constant = self?.blurViewWidth.constant == 0 ? 275 : 0
            self?.titleLabel.text        = self?.blurViewWidth.constant == 0 ? "title" : self?.flickrPhotoMetadata?.title
            self?.layoutIfNeeded()
        })
    }
}


