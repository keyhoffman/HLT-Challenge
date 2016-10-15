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
    private var showCommentsPresentationController: ShowCommentsPresentationController?
    
    // MARK: - Initialization
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - SubCoordinator Conformance
    
    func start() {
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
        rootNavigationController.transitioningDelegate = self
        
        let flickrPhotoTableViewControllerConfig = FlickrPhotoTableViewControllerConfiguration(didSelectPhoto: presentComments, hasRequestedDataRefreshForTableView: loadMorePhotos)
        let flickrPhotoTableViewController       = FlickrPhotoTableViewController(configuration: flickrPhotoTableViewControllerConfig)
        rootNavigationController.pushViewController(flickrPhotoTableViewController, animated: false)
        
        FlickrPhotoMetadata.getPhotosStream { result in
            switch result {
            case let .error(error):       debugPrint(error)
            case let .value(flickrPhoto): flickrPhotoTableViewController.data.append(flickrPhoto)
            }
        }
    }
    
    private func presentComments(for flickrPhoto: FlickrPhoto) {
        let flickrCommentTableViewController = FlickrCommentTableViewController()
        flickrCommentTableViewController.modalPresentationStyle = .custom
        flickrCommentTableViewController.transitioningDelegate  = self
        
        showCommentsPresentationController = ShowCommentsPresentationController(flickrPhoto: flickrPhoto, presentedViewController: flickrCommentTableViewController, presenting: nil)
        
        showCommentsPresentationController?.dismiss = { _ in self.rootNavigationController.dismiss(animated: true) }
        
        rootNavigationController.present(flickrCommentTableViewController, animated: true)
        
        let photoIDParameter = FlickrPhotoComment.photoIDParameter(for: flickrPhoto.metadata) // FIXME: CLEAN THIS UP!!!!!
        FlickrPhotoComment.getAll(withAdditionalQueryParameters: photoIDParameter) { result in
            switch result {
            case let .error(error):    debugPrint(error)
            case let .value(comments): flickrCommentTableViewController.data = comments
            }
        }
    }
    
    private func loadMorePhotos(for flickrTableViewController: FlickrPhotoTableViewController) {
        let index = flickrTableViewController.data.count
        FlickrPhotoMetadata.getPhotosStream(startingAt: index) { result in
            switch result {
            case let .error(error):       debugPrint(error)
            case let .value(flickrPhoto): flickrTableViewController.data.append(flickrPhoto)
            }
        }
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return showCommentsPresentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return showCommentsPresentationController
    }
}
