//
//  ShowCommentsPresentationController.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/15/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

final class ShowCommentsPresentationController: UIPresentationController, UIViewControllerAnimatedTransitioning {
    
    private lazy var backgroundBlurView: UIVisualEffectView? = { [weak self] in
        guard let `self` = self else { return nil }
        let bv           = UIVisualEffectView.init <^> UIBlurEffect(style: .dark)
        bv.frame         = self.containerView?.frame ?? .zero
        bv.alpha         = .zero
        bv.clipsToBounds = true
        bv.addSubview <^> self.presentedViewController.view
        return bv
    }()

    private lazy var mainStackView: UIStackView? = { [weak self] in
        guard let `self` = self else { return nil }
        let sv           = UIStackView.init(withNullableSubViews:) <^> [self.ownerNameLabel, self.flickrPhotoView]
        sv.axis          = .vertical
        sv.alignment     = .center
        sv.distribution  = .fillProportionally
        sv.spacing       = 5
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var flickrPhotoView: UIImageView? = { [weak self] in
        guard let `self` = self else { return nil }
        let pv         = UIImageView(image: self.flickrPhoto.photo)
        pv.alpha       = .zero
        pv.contentMode = .scaleAspectFit
        return pv
    }()
    
    private lazy var ownerNameLabel: UILabel? = { [weak self] in
        guard let `self` = self else { return nil }
        let l                       = UILabel()
        l.adjustsFontSizeToFitWidth = true
        l.alpha                     = .zero
        l.backgroundColor           = .clear
        l.textColor                 = .white
        l.textAlignment             = .center
        l.numberOfLines             = 2
        l.text                      = "Photographer:\n" + self.flickrPhoto.metadata.ownerName
        return l
    }()
    
    private lazy var mainStackViewLayoutGuide: UILayoutGuide? = { [weak self] in
        guard let `self` = self, let containerView = self.containerView else { return nil }
        let lg = UILayoutGuide()
        containerView.addLayoutGuide(lg)
        lg.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive                              = true
        lg.bottomAnchor.constraint(equalTo: self.presentedViewController.view.topAnchor).isActive               = true
        lg.heightAnchor.constraint(greaterThanOrEqualTo: containerView.heightAnchor, multiplier: 0.03).isActive = true
        return lg
    }()
    
    private lazy var dismissTapGesture: UITapGestureRecognizer? = { [weak self] in
//        guard let `self` = self else { return nil }
        return UITapGestureRecognizer(target: self, action: #selector(tapDismiss))
    }()
    
    
    private let flickrPhoto: FlickrPhoto
    private let dismiss: (Void) -> Void
    
    init(flickrPhoto: FlickrPhoto, presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, dismiss: @escaping (Void) -> Void) {
        self.flickrPhoto = flickrPhoto
        self.dismiss     = dismiss
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.addSubview <*> backgroundBlurView
        containerView?.addSubview <*> mainStackView
        containerView?.addGestureRecognizer <*> dismissTapGesture
        
        setConstraints()
        
        presentedViewController.view.frame = frameOfPresentedViewInContainerView.offsetBy(dx: 0, dy: UIScreen.main.bounds.height)
        
        containerView?.layoutIfNeeded()
        
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            guard let `self` = self else { return }
            self.backgroundBlurView?.alpha = .oneHundred
            self.flickrPhotoView?.alpha    = .oneHundred
            self.ownerNameLabel?.alpha     = .oneHundred
            
            self.presentingViewController.view.alpha = .thirty
            self.presentedViewController.view.frame  = self.frameOfPresentedViewInContainerView
            
            self.containerView?.layoutIfNeeded()
        })
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        guard !completed else { return }
        removeAllViewsAndResetPresentingViewController()
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        let width  = containerView.bounds.width
        let height = containerView.bounds.height / 3
        let y      = containerView.bounds.height - height
        return CGRect(x: 0, y: y, width: width, height: height)
    }
    
    override var shouldPresentInFullscreen: Bool {
        return false
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        removeAllViewsAndResetPresentingViewController()
    }
    
    override func dismissalTransitionWillBegin() {
        mainStackViewLayoutGuide?.heightAnchor.constraint(lessThanOrEqualTo: presentedViewController.view.heightAnchor, multiplier: 1).isActive = true
    }
    
    private func setConstraints() {
        guard let mainStackView = mainStackView, let containerView = containerView, let mainStackViewLayoutGuide = mainStackViewLayoutGuide else { return }
        
        let topMarginOffset = containerView.frame.height * 0.03
        
        let mainStackViewTop    = curry(NSLayoutConstraint.init) <^> mainStackView <^> .top     <^> .equal <^> containerView            <^> .topMargin <^> 1    <^> topMarginOffset
        let mainStackViewBottom = curry(NSLayoutConstraint.init) <^> mainStackView <^> .bottom  <^> .equal <^> mainStackViewLayoutGuide <^> .top       <^> 1    <^> 0
        let mainStackViewCenter = curry(NSLayoutConstraint.init) <^> mainStackView <^> .centerX <^> .equal <^> containerView            <^> .centerX   <^> 1    <^> 0
        let mainStackViewWidth  = curry(NSLayoutConstraint.init) <^> mainStackView <^> .width   <^> .equal <^> containerView            <^> .width     <^> 0.90 <^> 0
        
        NSLayoutConstraint.activate <^> [mainStackViewTop, mainStackViewCenter, mainStackViewWidth, mainStackViewBottom]
    }
    
    dynamic private func tapDismiss() {
        guard let dismissTapGesture = dismissTapGesture else { return }
        switch dismissTapGesture.state {
        case .ended: dismiss()
        default: break
        }
    }
    
    private func removeAllViewsAndResetPresentingViewController() {
        ownerNameLabel?    .removeFromSuperview()
        flickrPhotoView?   .removeFromSuperview()
        mainStackView?     .removeFromSuperview()
        backgroundBlurView?.removeFromSuperview()
        containerView?.removeLayoutGuide <*> mainStackViewLayoutGuide
        containerView?.removeGestureRecognizer <*> dismissTapGesture
        presentingViewController.view.alpha = .oneHundred
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning Conformance
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.75
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveLinear, animations: {}) { 
            transitionContext.completeTransition($0)
        }
    }
}
