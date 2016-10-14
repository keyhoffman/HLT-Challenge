//
//  TestTransitions.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/11/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

final class HalfSizePresentationController: UIPresentationController {
    
    private lazy var blurView: UIVisualEffectView = { [weak self] in
        let bv           = UIVisualEffectView.init <^> UIBlurEffect(style: .dark)
        bv.frame         = self?.containerView?.frame ?? .zero
        bv.alpha         = .zero
        bv.clipsToBounds = true
        bv.addSubview <^> self?.presentedViewController.view ?? UIView(frame: .zero)
        return bv
    }()
    
    private lazy var placeholderView: UIView = { [weak self] in
        let phv   = UIView()
        phv.frame = curry(CGRect.init) <^> 0 <^> 0 <^> (self?.containerView?.frame.width ?? 0) <^> ((self?.containerView?.frame.height ?? 0) / 2)
        phv.alpha = .zero
        return phv
    }()
    
    lazy var tap: UITapGestureRecognizer = { return UITapGestureRecognizer(target: self, action: #selector(tapped)) }()

    dynamic private func tapped() {
        print("tapped")
    }
    
    private lazy var photoView: UIImageView = { [weak self] in
        let pv         = UIImageView(image: self?.flickrPhoto.photo)
//        pv.frame       = self?.placeholderView.frame.insetBy(dx: 40, dy: 40) ?? .zero
        pv.bounds      = self?.placeholderView.frame.insetBy(dx: 40, dy: 40) ?? .zero
        pv.frame       = CGRect(origin: CGPoint(x: 40, y: -pv.bounds.height), size: pv.bounds.size)
        pv.alpha       = .zero
        pv.contentMode = .scaleToFill
        return pv
    }()

    private let flickrPhoto: FlickrPhoto
    
    init(flickrPhoto: FlickrPhoto, presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        self.flickrPhoto = flickrPhoto
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.addSubview(blurView)
        containerView?.addSubview(placeholderView)
        containerView?.addSubview(photoView)
        containerView!.addGestureRecognizer <^> UITapGestureRecognizer(target: self, action: #selector(tapped))
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.blurView.alpha  = .oneHundred
            self?.photoView.alpha = .oneHundred
//            self?.photoView.frame = self?.placeholderView.frame.insetBy(dx: 40, dy: 40) ?? .zero
            self?.photoView.center = self?.placeholderView.center ?? .zero
        })
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        guard !completed else { return }
        photoView.removeFromSuperview()
        placeholderView.removeFromSuperview()
        blurView.removeFromSuperview()
        let pv = UIImageView()
        pv.frame = CGRect(origin: CGPoint(x: 0, y: -pv.bounds.height), size: pv.bounds.size)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let width      = containerView?.bounds.width ?? 0
        let halfHeight = (containerView?.bounds.height ?? 0) / 2
        return CGRect(x: 0, y: halfHeight, width: width, height: halfHeight)
    }
    
    override var shouldPresentInFullscreen: Bool {
        return false
    }

}




final class CustomPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.75
    }
    
//    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
//        <#code#>
//    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController   = transitionContext.viewController(forKey: .to) else { return }
        
//        let foo = interruptibleAnimator(using: transitionContext)
        
        print("isAnimated", transitionContext.isAnimated)
        print("isInteractive", transitionContext.isInteractive)
        
        let finalFrameForViewController = transitionContext.finalFrame(for: toViewController)
        let containerView               = transitionContext.containerView
        
        let bounds = UIScreen.main.bounds
        
        toViewController.view.frame = (finalFrameForViewController).offsetBy(dx: 0, dy: bounds.size.height)
        
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveLinear, animations: {
            fromViewController.view.alpha = .thirty
            toViewController.view.frame   = finalFrameForViewController
        }) { completed in
            transitionContext.completeTransition(completed)
            fromViewController.view.alpha = .oneHundred
        }
    }
}



