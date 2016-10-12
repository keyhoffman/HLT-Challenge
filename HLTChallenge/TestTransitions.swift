//
//  TestTransitions.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/11/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

final class HalfSizePresentationController: UIPresentationController {
    
    private lazy var blurView: UIVisualEffectView = {
        let bv   = UIVisualEffectView.init <^> UIBlurEffect(style: .dark)
        bv.frame = self.containerView?.frame ?? .zero
        bv.alpha = .zero
        bv.addSubview(self.presentedViewController.view)
        return bv
    }()
    
    init(image: UIImage, presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.addSubview(blurView)
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in self.blurView.alpha = .oneHundred })
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        guard !completed else { return }
        blurView.removeFromSuperview()
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








// MARK: - // MARK: - // MARK: - // MARK: -

final class CustomPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 5.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        
        let finalFrameForViewController = transitionContext.finalFrame(for: toViewController)
        
        let containerView = transitionContext.containerView
        
        let bounds = UIScreen.main.bounds
        
        toViewController.view.frame = (finalFrameForViewController).offsetBy(dx: 0, dy: bounds.size.height)
        
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveLinear, animations: {
            fromViewController.view.alpha = .fifty
            toViewController.view.frame   = finalFrameForViewController
        }) { completed in
            transitionContext.completeTransition(completed)
            fromViewController.view.alpha = .oneHundred
        }
    }
}



