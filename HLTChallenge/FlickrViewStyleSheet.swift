//
//  FlickrViewStyleSheet.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrViewStyleSheet

struct FlickrViewStyleSheet: ViewPreparer {
    
    static private let titleLabelBottomToFlickrViewTopOffsetByViewHeightFactor: CGFloat = 0.8
    
    // MARK: - ViewPreparer Conformance
    
    static func prepare(_ flickrView: FlickrView) {
        
        defer { flickrView.layoutIfNeeded() }
        
        flickrView.backgroundColor = .clear
        
        // MARK: - AutoLayout
        
        let flickrImageViewTop      = curry(NSLayoutConstraint.init) <| flickrView.flickrPhotoView <| .top      <| .equal <| flickrView <| .top      <| 1 <| 0
        let flickrImageViewBottom   = curry(NSLayoutConstraint.init) <| flickrView.flickrPhotoView <| .bottom   <| .equal <| flickrView <| .bottom   <| 1 <| 0
        let flickrImageViewLeading  = curry(NSLayoutConstraint.init) <| flickrView.flickrPhotoView <| .leading  <| .equal <| flickrView <| .leading  <| 1 <| 0
        let flickrImageViewTrailing = curry(NSLayoutConstraint.init) <| flickrView.flickrPhotoView <| .trailing <| .equal <| flickrView <| .trailing <| 1 <| 0
        
        let flickrImageViewConstraints = [flickrImageViewTop, flickrImageViewBottom, flickrImageViewLeading, flickrImageViewTrailing]
        
        let titleLabelCenterX = curry(NSLayoutConstraint.init) <| flickrView.titleLabel <| .centerX <| .equal <| flickrView.vibrancyView <| .centerX <| 1 <| 0
        let titleLabelCenterY = curry(NSLayoutConstraint.init) <| flickrView.titleLabel <| .centerY <| .equal <| flickrView.vibrancyView <| .centerY <| 1 <| 0
        let titleLabelHeight  = curry(NSLayoutConstraint.init) <| flickrView.titleLabel <| .height  <| .equal <| flickrView.vibrancyView <| .height  <| 1 <| 0
        let titleLabelWidth   = curry(NSLayoutConstraint.init) <| flickrView.titleLabel <| .width   <| .equal <| flickrView.vibrancyView <| .width   <| 1 <| 0
        
        let titleLabelConstraints = [titleLabelCenterX, titleLabelCenterY, titleLabelHeight, titleLabelWidth]
        
        let vibrancyViewCenterX = curry(NSLayoutConstraint.init) <| flickrView.vibrancyView <| .centerX <| .equal <| flickrView.blurView <| .centerX <| 1 <| 0
        let vibrancyViewCenterY = curry(NSLayoutConstraint.init) <| flickrView.vibrancyView <| .centerY <| .equal <| flickrView.blurView <| .centerY <| 1 <| 0
        let vibrancyViewHeight  = curry(NSLayoutConstraint.init) <| flickrView.vibrancyView <| .height  <| .equal <| flickrView.blurView <| .height  <| 1 <| 0
        let vibrancyViewWidth   = curry(NSLayoutConstraint.init) <| flickrView.vibrancyView <| .width   <| .equal <| flickrView.blurView <| .width   <| 1 <| 0
        
        let vibrancyViewConstraints = [vibrancyViewCenterX, vibrancyViewCenterY, vibrancyViewHeight, vibrancyViewWidth]
        
        NSLayoutConstraint.activate <| flickrImageViewConstraints + titleLabelConstraints + vibrancyViewConstraints
    }
    
    // MARK: - Label

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
            case .title: return UIColor.darkText.withAlphaComponent(.seventy)
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
    
    enum VisualEffectView: Int {
        case titleBlur = 1, titleVibrancy
        
        var visualEffectView: UIVisualEffectView {
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
            case .titleBlur:     return UIColor.white.withAlphaComponent(.fifty)
            case .titleVibrancy: return nil
            }
        }
        
        private var borderColor: CGColor? {
            switch self {
            case .titleBlur:     return UIColor.darkText.withAlphaComponent(.forty).cgColor
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
