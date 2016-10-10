//
//  FlickrCoordinator.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrCoordinator

final class FlickrCoordinator: NSObject, SubCoordinator, UIViewControllerTransitioningDelegate {
    
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
        
        let flickrPhotoTableViewControllerConfig = FlickrPhotoTableViewControllerConfiguration(didSelectPhoto: presentComments)
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
        flickrCommentTableViewController.modalPresentationStyle = .custom
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
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

final class HalfSizePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        let height = containerView?.bounds.height ?? 0 / 2
        let width  = containerView?.bounds.width ?? 0
        print("HEIGHT:", height)
        return CGRect(x: 0, y: 0, width: width, height: height)
    }
}












