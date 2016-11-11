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
    
    func configure(_ flickrPhoto: FlickrPhoto) {
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

// MARK: - Selector Extension

fileprivate extension Selector {
    fileprivate static let displayPhotoTitle = #selector(FlickrView.displayPhotoTitle)
}


// MARK: - FlickrViewStyleSheet

fileprivate struct FlickrViewStyleSheet: ViewPreparer {
    
    private static let titleLabelBottomToFlickrViewTopOffsetByViewHeightFactor: CGFloat = 0.8
    
    // MARK: - ViewPreparer Conformance
    
    fileprivate static func prepare(_ flickrView: FlickrView) {
        
        defer { flickrView.layoutIfNeeded() }
        
        flickrView.backgroundColor = .clear
        
        // MARK: - AutoLayout
        
        let flickrImageViewTop      = ¿NSLayoutConstraint.init <| flickrView.flickrPhotoView <| .top      <| .equal <| flickrView <| .top      <| 1 <| 0
        let flickrImageViewBottom   = ¿NSLayoutConstraint.init <| flickrView.flickrPhotoView <| .bottom   <| .equal <| flickrView <| .bottom   <| 1 <| 0
        let flickrImageViewLeading  = ¿NSLayoutConstraint.init <| flickrView.flickrPhotoView <| .leading  <| .equal <| flickrView <| .leading  <| 1 <| 0
        let flickrImageViewTrailing = ¿NSLayoutConstraint.init <| flickrView.flickrPhotoView <| .trailing <| .equal <| flickrView <| .trailing <| 1 <| 0
        
        let flickrImageViewConstraints = [flickrImageViewTop, flickrImageViewBottom, flickrImageViewLeading, flickrImageViewTrailing]
        
        let titleLabelCenterX = ¿NSLayoutConstraint.init <| flickrView.titleLabel <| .centerX <| .equal <| flickrView.vibrancyView <| .centerX <| 1 <| 0
        let titleLabelCenterY = ¿NSLayoutConstraint.init <| flickrView.titleLabel <| .centerY <| .equal <| flickrView.vibrancyView <| .centerY <| 1 <| 0
        let titleLabelHeight  = ¿NSLayoutConstraint.init <| flickrView.titleLabel <| .height  <| .equal <| flickrView.vibrancyView <| .height  <| 1 <| 0
        let titleLabelWidth   = ¿NSLayoutConstraint.init <| flickrView.titleLabel <| .width   <| .equal <| flickrView.vibrancyView <| .width   <| 1 <| 0
        
        let titleLabelConstraints = [titleLabelCenterX, titleLabelCenterY, titleLabelHeight, titleLabelWidth]
        
        let vibrancyViewCenterX = ¿NSLayoutConstraint.init <| flickrView.vibrancyView <| .centerX <| .equal <| flickrView.blurView <| .centerX <| 1 <| 0
        let vibrancyViewCenterY = ¿NSLayoutConstraint.init <| flickrView.vibrancyView <| .centerY <| .equal <| flickrView.blurView <| .centerY <| 1 <| 0
        let vibrancyViewHeight  = ¿NSLayoutConstraint.init <| flickrView.vibrancyView <| .height  <| .equal <| flickrView.blurView <| .height  <| 1 <| 0
        let vibrancyViewWidth   = ¿NSLayoutConstraint.init <| flickrView.vibrancyView <| .width   <| .equal <| flickrView.blurView <| .width   <| 1 <| 0
        
        let vibrancyViewConstraints = [vibrancyViewCenterX, vibrancyViewCenterY, vibrancyViewHeight, vibrancyViewWidth]
        
        NSLayoutConstraint.activate <| flickrImageViewConstraints + titleLabelConstraints + vibrancyViewConstraints
    }
    
    // MARK: - Label
    
    fileprivate enum Label: Int {
        case title = 1
        
        fileprivate var label: UILabel {
            let l                                       = UILabel()
            l.tag                                       = rawValue
            l.backgroundColor                           = backgroundColor
            l.textColor                                 = textColor
            l.textAlignment                             = textAlignment
            l.numberOfLines                             = numberOfLines
            l.adjustsFontSizeToFitWidth                 = adjustsFontSizeToFitWidth
            l.font                                      = font
            l.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
            l.sizeToFit()
            return l
        }
        
        private var backgroundColor: UIColor? {
            switch self {
            case .title: return .clear
            }
        }
        
        private var textColor: UIColor {
            switch self {
            case .title: return UIColor.darkText.withAlphaComponent(Percentage.seventy.cgFloat)
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
        
        private var font: UIFont {
            switch self {
            case .title: return UIFont.monospacedDigitSystemFont(ofSize: 25, weight: UIFontWeightSemibold)
            }
        }
        
        private var translatesAutoresizingMaskIntoConstraints: Bool {
            switch self {
            case .title: return false
            }
        }
    }
    
    // MARK: - VisualEffectView
    
    fileprivate enum VisualEffectView: Int {
        case titleBlur = 1, titleVibrancy
        
        fileprivate var visualEffectView: UIVisualEffectView {
            let bv                                       = UIVisualEffectView(effect: effect)
            bv.tag                                       = rawValue
            bv.backgroundColor                           = backgroundColor
            bv.layer.borderColor                         = borderColor
            bv.layer.borderWidth                         = borderWidth
            bv.layer.cornerRadius                        = cornerRadius
            bv.clipsToBounds                             = clipsToBounds
            bv.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
            return bv
        }
        
        private var effect: UIVisualEffect? {
            switch self {
            case .titleBlur:     return UIBlurEffect(style: .light)
            case .titleVibrancy: return UIVibrancyEffect.init <*> (VisualEffectView.titleBlur.effect as? UIBlurEffect)
            }
        }
        
        private var backgroundColor: UIColor? {
            switch self {
            case .titleBlur:     return UIColor.white.withAlphaComponent(Percentage.fifty.cgFloat)
            case .titleVibrancy: return nil
            }
        }
        
        private var borderColor: CGColor? {
            switch self {
            case .titleBlur:     return UIColor.darkText.withAlphaComponent(Percentage.forty.cgFloat).cgColor
            case .titleVibrancy: return nil
            }
        }
        
        private var borderWidth: CGFloat {
            switch self {
            case .titleBlur:     return 0.5
            case .titleVibrancy: return 0.0
            }
        }
        
        private var cornerRadius: CGFloat {
            switch self {
            case .titleBlur:     return 4.0
            case .titleVibrancy: return 0.0
            }
        }
        
        private var clipsToBounds: Bool {
            switch self {
            case .titleBlur:     return true
            case .titleVibrancy: return true
            }
        }
        
        private var translatesAutoresizingMaskIntoConstraints: Bool {
            switch self {
            case .titleBlur:     return false
            case .titleVibrancy: return false
            }
        }
    }
    
    // MARK: - ImageView
    
    fileprivate enum ImageView: Int {
        case flickr = 1
        
        fileprivate var imageView: UIImageView {
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
