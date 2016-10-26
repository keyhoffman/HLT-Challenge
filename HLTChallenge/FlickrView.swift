//
//  FlickrView.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrView

final class FlickrView: UIView, PreparedConfigurable {

    // MARK: - Property Declarations
    
    let flickrPhotoView = FlickrViewStyleSheet.ImageView.flickr.imageView
    
    let titleLabel = FlickrViewStyleSheet.Label.title.label
    
    let blurView = FlickrViewStyleSheet.VisualEffectView.titleBlur.visualEffectView
    
    let vibrancyView = FlickrViewStyleSheet.VisualEffectView.titleVibrancy.visualEffectView

    private lazy var blurViewWidth: NSLayoutConstraint = { ¿NSLayoutConstraint.init <| self.blurView <| .width <| .equal <| self <| .width <| Percentage.ten.cgFloat <| 0 }()
    
    // MARK: - Preparable Conformance
    
    func prepare() {
        defer {
            setInitialBlurViewConstraints()
            FlickrViewStyleSheet.prepare(self)
        }
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(flickrPhotoView)
        addSubview(blurView)
        blurView.contentView.addSubview(vibrancyView)
        vibrancyView.contentView.addSubview(titleLabel)
        blurView.addGestureRecognizer <| UITapGestureRecognizer(target: self, action: .displayPhotoTitle)
    }
    
    private func setInitialBlurViewConstraints() {
        let blurViewTop      = ¿NSLayoutConstraint.init <| blurView <| .top      <| .equal <| self <| .topMargin      <| 1                         <| 0
        let blurViewHeight   = ¿NSLayoutConstraint.init <| blurView <| .height   <| .equal <| self <| .height         <| Percentage.ten.cgFloat    <| 0
        let blurViewLeading  = ¿NSLayoutConstraint.init <| blurView <| .leading  <| .equal <| self <| .leadingMargin  <| 1                         <| 0
                
        let blurViewConstraints = [blurViewTop, blurViewHeight, blurViewLeading, blurViewWidth]
        
        NSLayoutConstraint.activate(blurViewConstraints)
    }
    
    // MARK: - Configurable Conformance
    
    func configure(withData flickrPhoto: FlickrPhoto) {
        defer { prepare() }
        flickrPhotoView.image = flickrPhoto.photo
        flickrPhotoMetadata   = flickrPhoto.metadata
    }
    
    private var flickrPhotoMetadata: FlickrPhotoMetadata?
    
    dynamic fileprivate func displayPhotoTitle() {
        layoutIfNeeded()
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: Percentage.seventy.cgFloat, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { [weak self] in
            self?.blurViewWidth.constant = self?.blurViewWidth.constant == 0 ? 310 : 0 // FIXME: REMOVE MAGIC NUMBER
            self?.titleLabel.text        = self?.blurViewWidth.constant == 0 ? .empty : self?.flickrPhotoMetadata?.title
            self?.layoutIfNeeded()
        })
    }
}

private extension Selector {
    static let displayPhotoTitle = #selector(FlickrView.displayPhotoTitle)
}


