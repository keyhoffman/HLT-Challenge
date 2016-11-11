//
//  ShowCommentsPresentationController.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/15/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

final class ShowCommentsPresentationController: UIPresentationController, UIViewControllerAnimatedTransitioning {
    
    private lazy var backgroundBlurView: UIVisualEffectView = { [weak self] in
        $0.frame         = self?.containerView?.frame ?? .zero
        $0.alpha         = Percentage.zero.cgFloat
        $0.clipsToBounds = true
        $0.addSubview <^> self?.presentedViewController.view
        return $0
    }(UIVisualEffectView.init <| UIBlurEffect(style: .dark))

    private lazy var mainStackView: UIStackView = { [weak self] in
        $0.axis                                      = .vertical
        $0.alignment                                 = .center
        $0.distribution                              = .fillProportionally
        $0.spacing                                   = 5
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addArrangedSubviews <*> [self?.ownerNameLabel, self?.flickrPhotoView]
        return $0
    }(UIStackView())
    
    private lazy var flickrPhotoView: UIImageView = { [weak self] in
        $0.image       = self?.flickrPhoto.photo
        $0.alpha       = Percentage.zero.cgFloat
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var ownerNameLabel: UILabel = { [weak self] in
        $0.adjustsFontSizeToFitWidth = true
        $0.alpha                     = Percentage.zero.cgFloat
        $0.backgroundColor           = .clear
        $0.textColor                 = .white
        $0.textAlignment             = .center
        $0.numberOfLines             = 2
        $0.text                      = "Photographer:\n" + (self?.flickrPhoto.metadata.ownerName ?? .empty)
        return $0
    }(UILabel())
    
    private lazy var mainStackViewLayoutGuide: UILayoutGuide? = { [weak self] in
        guard let `self` = self, let containerView = self.containerView else { return nil }
        containerView.addLayoutGuide($0)
        $0.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive                              = true
        $0.bottomAnchor.constraint(equalTo: self.presentedViewController.view.topAnchor).isActive               = true
        $0.heightAnchor.constraint(greaterThanOrEqualTo: containerView.heightAnchor, multiplier: 0.03).isActive = true
        return $0
    }(UILayoutGuide())
    
    private lazy var dismissTapGesture: UITapGestureRecognizer = { [weak self] in
        return UITapGestureRecognizer(target: self, action: .tapDismiss)
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
            self?.backgroundBlurView.alpha = Percentage.oneHundred.cgFloat
            self?.flickrPhotoView.alpha    = Percentage.oneHundred.cgFloat
            self?.ownerNameLabel.alpha     = Percentage.oneHundred.cgFloat
            
            self?.presentingViewController.view.alpha = Percentage.thirty.cgFloat
            self?.presentedViewController.view.frame  = self?.frameOfPresentedViewInContainerView ?? .zero
            
            self?.containerView?.layoutIfNeeded()
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
        let topMarginOffset = (containerView?.frame.height ?? 0) * 0.03
        
        let mainStackViewTop    = ¿NSLayoutConstraint.init <| mainStackView <| .top     <| .equal <| containerView            <| .topMargin <| 1    <| topMarginOffset
        let mainStackViewBottom = ¿NSLayoutConstraint.init <| mainStackView <| .bottom  <| .equal <| mainStackViewLayoutGuide <| .top       <| 1    <| 0
        let mainStackViewCenter = ¿NSLayoutConstraint.init <| mainStackView <| .centerX <| .equal <| containerView            <| .centerX   <| 1    <| 0
        let mainStackViewWidth  = ¿NSLayoutConstraint.init <| mainStackView <| .width   <| .equal <| containerView            <| .width     <| 0.90 <| 0
        
        NSLayoutConstraint.activate <| [mainStackViewTop, mainStackViewCenter, mainStackViewWidth, mainStackViewBottom]
    }
    
    dynamic fileprivate func tapDismiss() {
        switch dismissTapGesture.state {
        case .ended: dismiss()
        default: break
        }
    }
    
    private func removeAllViewsAndResetPresentingViewController() {
        ownerNameLabel    .removeFromSuperview()
        flickrPhotoView   .removeFromSuperview()
        mainStackView     .removeFromSuperview()
        backgroundBlurView.removeFromSuperview()
        containerView?.removeLayoutGuide <*> mainStackViewLayoutGuide
        containerView?.removeGestureRecognizer <*> dismissTapGesture
        presentingViewController.view.alpha = Percentage.oneHundred.cgFloat
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

fileprivate extension Selector {
    fileprivate static let tapDismiss = #selector(ShowCommentsPresentationController.tapDismiss)
}
