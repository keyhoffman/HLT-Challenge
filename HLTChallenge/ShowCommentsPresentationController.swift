//
//  ShowCommentsPresentationController.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/15/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

final class ShowCommentsPresentationController: UIPresentationController, UIViewControllerAnimatedTransitioning {
    
    private lazy var blurView: UIVisualEffectView? = { [weak self] in
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
        let sv           = UIStackView.init(withNullableSubViews:) <^> [self.ownerNameLabel, self.photoView]
        sv.axis          = .vertical
        sv.alignment     = .center
        sv.distribution  = .fillProportionally
        sv.spacing       = 5
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var photoView: UIImageView? = { [weak self] in
        guard let `self` = self else { return nil }
        let pv         = UIImageView(image: self.flickrPhoto.photo)
        pv.alpha       = .zero
        pv.contentMode = .scaleToFill
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
    
    private lazy var dismissTapGesture: UITapGestureRecognizer = { UITapGestureRecognizer(target: self, action: #selector(tapDismiss)) }()
    
    private let flickrPhoto: FlickrPhoto
    private let dismiss: (Void) -> Void
    
    init(flickrPhoto: FlickrPhoto, presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, dismiss: @escaping (Void) -> Void) {
        self.flickrPhoto = flickrPhoto
        self.dismiss     = dismiss
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.addSubview <*> blurView
        containerView?.addSubview <*> mainStackView
        containerView?.addGestureRecognizer(dismissTapGesture)
        
        setConstraints()
        
        presentedViewController.view.frame = frameOfPresentedViewInContainerView.offsetBy(dx: 0, dy: UIScreen.main.bounds.height)
        
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            guard let `self` = self else { return }
            self.blurView?.alpha       = .oneHundred
            self.photoView?.alpha      = .oneHundred
            self.ownerNameLabel?.alpha = .oneHundred
            
            self.presentingViewController.view.alpha = .thirty
            self.presentedViewController.view.frame  = self.frameOfPresentedViewInContainerView
            })
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        guard !completed else { return }
        removeAllViewsAndResetPresentingViewController()
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let width      = containerView?.bounds.width ?? 0
        let halfHeight = (containerView?.bounds.height ?? 0) / 2
        return CGRect(x: 0, y: halfHeight, width: width, height: halfHeight)
    }
    
    override var shouldPresentInFullscreen: Bool {
        return false
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        removeAllViewsAndResetPresentingViewController()
    }
    
    private func setConstraints() {
        guard let mainStackView = mainStackView, let containerView = containerView else { return }
        
        let verticalMarginOffset = containerView.frame.height * 0.03
        
        let mainStackViewTop    = curry(NSLayoutConstraint.init) <^> mainStackView <^> .top     <^> .equal <^> containerView <^> .topMargin <^> 1    <^> verticalMarginOffset
        let mainStackViewBottom = curry(NSLayoutConstraint.init) <^> mainStackView <^> .bottom  <^> .equal <^> containerView <^> .centerY   <^> 1    <^> -verticalMarginOffset
        let mainStackViewCenter = curry(NSLayoutConstraint.init) <^> mainStackView <^> .centerX <^> .equal <^> containerView <^> .centerX   <^> 1    <^> 0
        let mainStackViewWidth  = curry(NSLayoutConstraint.init) <^> mainStackView <^> .width   <^> .equal <^> containerView <^> .width     <^> 0.90 <^> 0
        
        NSLayoutConstraint.activate <^> [mainStackViewTop, mainStackViewBottom, mainStackViewCenter, mainStackViewWidth]
    }
    
    dynamic private func tapDismiss() {
        switch dismissTapGesture.state {
        case .ended: dismiss()
        default: break
        }
    }
    
    private func removeAllViewsAndResetPresentingViewController() {
        ownerNameLabel? .removeFromSuperview()
        photoView?      .removeFromSuperview()
        mainStackView?  .removeFromSuperview()
        blurView?       .removeFromSuperview()
        presentingViewController.view.alpha = .oneHundred
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning Conformance
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveLinear, animations: {  }) {
            transitionContext.completeTransition($0)
        }
    }
}
