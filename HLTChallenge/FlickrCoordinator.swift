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
        
        let flickrPhotoTableViewControllerConfig = FlickrPhotoTableViewControllerConfiguration(didSelectPhoto: presentComments, loadPhotosForNextPage: loadPhotos)
        let flickrPhotoTableViewController       = FlickrPhotoTableViewController(configuration: flickrPhotoTableViewControllerConfig)
        rootNavigationController.pushViewController(flickrPhotoTableViewController, animated: false)
        
        loadPhotos(for: flickrPhotoTableViewController)
    }
    
    private func presentComments(for flickrPhoto: FlickrPhoto) {
        let flickrCommentTableViewController = FlickrCommentTableViewController()
        flickrCommentTableViewController.modalPresentationStyle = .custom
        flickrCommentTableViewController.transitioningDelegate  = self
        
        showCommentsPresentationController = ShowCommentsPresentationController(flickrPhoto: flickrPhoto, presentedViewController: flickrCommentTableViewController, presenting: nil) {
            self.rootNavigationController.dismiss(animated: true)
        }
        
        rootNavigationController.present(flickrCommentTableViewController, animated: true)
        
        loadComments(for: flickrCommentTableViewController, with: flickrPhoto)
    }
    
    // MARK: - FlickrAPIGetable API Calls
    
    private func loadComments(for flickrCommentTableViewController: FlickrCommentTableViewController, with photo: FlickrPhoto) {
        let photoIDParameter = FlickrPhotoComment.photoIDParameter(for: photo.metadata)
        FlickrPhotoComment.getAll(withAdditionalQueryParameters: photoIDParameter) { result in
            switch result {
            case let .error(error):    debugPrint(error)
            case let .value(comments): flickrCommentTableViewController.data = comments
            }
        }
    }
    
    private func loadPhotos(for flickrPhotoTableViewController: FlickrPhotoTableViewController, at index: Int = 0) {
        let dataCount = flickrPhotoTableViewController.data.count
        guard let picturesPerPage = Int(FlickrConstants.Parameters.Values.Metadata.picturesPerPage),
              (index >= dataCount - 2 && index >= picturesPerPage - 1) || dataCount == 0  else { return }
        
        FlickrPhotoMetadata.getPhotosStream(startingAt: flickrPhotoTableViewController.data.count) { result in
            switch result {
            case let .error(error):       debugPrint(error)
            case let .value(flickrPhoto): flickrPhotoTableViewController.data.append(flickrPhoto)
            }
        }
    }
    
    // MARK: - UIViewControllerTransitioningDelegate Conformance
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return showCommentsPresentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return showCommentsPresentationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissCommentsAnimatedTransition()
    }
}

