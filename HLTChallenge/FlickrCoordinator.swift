//
//  FlickrCoordinator.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrCoordinator

final class FlickrCoordinator: NSObject, SubCoordinator, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    
    // MARK: - Property Declarations
    
    private let window: UIWindow
    private let rootNavigationController = UINavigationController()
    
    // MARK: - Initialization
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - SubCoordinator Conformance
    
    func start() {
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
        
//        let vc = ViewController()
//        rootNavigationController.pushViewController(vc, animated: true)
        
        let flickrPhotoTableViewControllerConfig = FlickrPhotoTableViewControllerConfiguration(didSelectPhoto: presentComments, userHasReachedBottomOfTableView: loadMorePhotos)
        let flickrPhotoTableViewController       = FlickrPhotoTableViewController(configuration: flickrPhotoTableViewControllerConfig)
        rootNavigationController.pushViewController(flickrPhotoTableViewController, animated: false)
        
        FlickrPhotoMetadata.getPhotosStream { result in
            switch result {
            case let .error(error):       debugPrint(error)
            case let .value(flickrPhoto): flickrPhotoTableViewController.data.append(flickrPhoto)
            }
        }
    }
    
    private func presentComments(for metadata: FlickrPhotoMetadata) {
        
        print("PHOTO OWNER:", metadata.ownerName)
        
        let flickrCommentTableViewController                    = FlickrCommentTableViewController()
//        flickrCommentTableViewController.anima
        flickrCommentTableViewController.modalPresentationStyle = .custom
//        flickrCommentTableViewController.modalTransitionStyle   = .c
        flickrCommentTableViewController.transitioningDelegate  = self
        
        rootNavigationController.present(flickrCommentTableViewController, animated: true, completion: nil)
        
        let photoIDParameter = FlickrPhotoComment.photoIDParameter(for: metadata) // FIXME: CLEAN THIS UPPPPP
        FlickrPhotoComment.getAll(withAdditionalQueryParameters: photoIDParameter) { result in
            switch result {
            case let .error(error):    debugPrint(error)
            case let .value(comments): flickrCommentTableViewController.data = comments
            }
        }
    }
    
    private func loadMorePhotos(startingAt row: Int) {
        
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentAnimationController()
    }
    
//    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        <#code#>
//    }
//    
//    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        <#code#>
//    }
}





final class ViewController: UIViewController {
    
    lazy var pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handle))
    
//    let colorChange = UIViewPropertyAnimator(duration: 2.0, curve: .easeIn) { //[weak self] in
//        self.view.backgroundColor = .blue
//    }
    
    
    
    let foo: UILabel = {
        let l = UILabel()
        l.text = "fasasdfasfdfd"
        l.layer.borderWidth = 0.5
        l.layer.backgroundColor = UIColor.white.cgColor
        return l
    }()

    let colorChange = UIViewPropertyAnimator(duration: 2.0, curve: .easeIn)//, animations: nil)
    let changeWidthFrame = UIViewPropertyAnimator(duration: 3.0, curve: .easeIn)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.backgroundColor = UIColor.green.cgColor
        view.addSubview(foo)
        view.addGestureRecognizer(pan)
        
//        pan.addTarget(self, action: #selector(handle))
        
        
        foo.frame  = CGRect(x: 100, y: 100, width: 100, height: 100)
        
        colorChange.addAnimations {
            self.view.layer.backgroundColor = UIColor.blue.cgColor
        }
        
        changeWidthFrame.addAnimations {
            self.foo.frame = CGRect(x: 200, y: 300, width: 200, height: 200)
//            self.foo.center = CGPoint(x: 200, y: 200)
//            self.foo.layer.borderWidth =
            self.foo.layer.backgroundColor = UIColor.red.cgColor
        }
        
        changeWidthFrame.startAnimation(afterDelay: 3.0)
        
//        colorChange.startAnimation(afterDelay: 5.0)
    }
    
    
    func handle() {
        colorChange.fractionComplete = (view.center.y + pan.translation(in: view).y) / view.bounds.height
    }
    
    
}






















