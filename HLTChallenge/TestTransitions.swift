//
//  TestTransitions.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/11/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

final class HalfSizePresentationController: UIPresentationController {
    
    lazy var bgView: UIView = {
        let v = UIView()
        v.backgroundColor = .green
        v.addSubview(self.presentedViewController.view)
        v.frame = self.containerView?.frame ?? .zero
        print("bgView.bounds =", v.bounds)
        return v
    }()
    
    override func presentationTransitionWillBegin() {
        //        presentingViewController.view.addGestureRecognizer(poopTap)
        //        presentedViewController.view.addGestureRecognizer(dismissTap)
        if let _ = containerView { print("YES CONTAIN") }
        else { print("NO CONTAIN") }
        
        containerView?.addSubview(bgView)
        
        let transitionCoordinator = presentingViewController.transitionCoordinator
        bgView.alpha = 0.0
        
        transitionCoordinator?.animate(alongsideTransition: { transitionCoordinatorContext in
            self.bgView.alpha = 1.0
            }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        guard !completed else { print("COMPLETED");return }
        print("Not completed")
        bgView.removeFromSuperview()
    }
    
    var poopTap: UITapGestureRecognizer {
        return UITapGestureRecognizer(target: presentingViewController, action: #selector(poop))
    }
    var dismissTap: UITapGestureRecognizer {
        return UITapGestureRecognizer(target: presentedViewController, action: #selector(tapped))
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let width      = containerView?.bounds.width ?? 0
        let halfHeight = (containerView?.bounds.height ?? 0) / 2
        return CGRect(x: 0, y: halfHeight, width: width, height: halfHeight)
    }
    
    override var shouldPresentInFullscreen: Bool {
        return false
    }
    
    func poop() {
        print("POOP")
    }
    
    func tapped() {
        print("TAPPED")
    }
}



final class DismissTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
        let containerView = transitionContext.containerView
        
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        let bounds = UIScreen.main.bounds
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromViewController.view.frame = curry(CGRect.init) <^> (CGPoint(x: 0, y: bounds.height)) <^> bounds.size
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}

final class DismissInteractorTransition: UIPercentDrivenInteractiveTransition {
    
    var inProgress  = false
    var shouldComplete = false
    
    private let dismissalThreshold: Percentage
    private let navigationController: UINavigationController
    
    init(dismissalThreshold: Percentage, navigationController: UINavigationController) {
        self.dismissalThreshold   = dismissalThreshold
        self.navigationController = navigationController
    }
    
    private lazy var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
    
    dynamic private func handlePanGesture() {
        guard let panGestureSuperView = panGesture.view?.superview else { return }
        let viewTranslation = panGesture.translation(in: panGestureSuperView)
        switch panGesture.state {
        case .began:
            inProgress = true
            navigationController.dismiss(animated: true, completion: nil)
        case .changed:
            break
//            let const = CGFloat.init <^> (curry(fminf) <^> fmaxf(Float(viewTranslation.x / 200.0), 0.0) <^> 1.0)
//            shouldComplete = const > dismissalThreshold
//            update(const)
        case .cancelled:
            inProgress = false
            cancel()
        case .ended:
            inProgress = false
            shouldComplete ? finish() : cancel()
        case .possible, .failed: break
        }
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




final class CustomInteractionController: UIPercentDrivenInteractiveTransition {
    
    private var navigationController: UINavigationController?
    private var shouldCompleteTransition = false
    private var transitionInProgress     = false
    private var completionSeed: CGFloat {
        return 1 - percentComplete
    }
    
    private lazy var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
    
    func attach(to viewController: UIViewController) {
        navigationController = viewController.navigationController
        setupGestureRecognizer(for: viewController.view)
    }
    
    private func setupGestureRecognizer(for view: UIView) {
        view.addGestureRecognizer(panGesture)
    }
    
    dynamic private func handlePanGesture() {
        guard let panGestureSuperView = panGesture.view?.superview else { return }
        let viewTranslation = panGesture.translation(in: panGestureSuperView)
        switch panGesture.state {
        case .began:
            transitionInProgress = true
            _ = navigationController?.popViewController(animated: true)
        case .changed: break
//            let const = CGFloat.init <^> (curry(fminf) <^> fmaxf(Float(viewTranslation.x / 200.0), 0.0) <^> 1.0)
//            shouldCompleteTransition = const > 0.5
//            update(const)
        case .cancelled:
            transitionInProgress = false
            cancel()
        case .ended:
            transitionInProgress = false
            guard shouldCompleteTransition else { break }
            finish()
        case .possible, .failed: break
        }
    }
}


