//
//  DismissCommentsAnimatedTransition.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/15/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

final class DismissCommentsAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.75
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from), let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toViewController.view.alpha   = .oneHundred
            containerView.alpha           = .zero
            fromViewController.view.frame = CGRect(origin: CGPoint(x: 0, y: containerView.frame.height), size: fromViewController.view.bounds.size)
        }) { transitionContext.completeTransition($0) }
    }
}
