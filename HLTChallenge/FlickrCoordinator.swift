//
//  FlickrCoordinator.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrCoordinator

final class FlickrCoordinator: SubCoordinator {
    
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
        
        let flickrCommentTableViewController = FlickrCommentTableViewController()
        rootNavigationController.present(flickrCommentTableViewController, animated: true, completion: nil)
        
        let photoIDParameter = FlickrPhotoComment.photoIDParameter(for: metadata) // FIXME: CLEAN THIS UPPPPP
        FlickrPhotoComment.getAll(withAdditionalQueryParameters: photoIDParameter) { result in
            switch result {
            case let .error(error):    debugPrint(error)
            case let .value(comments): flickrCommentTableViewController.data = comments
            }
        }
    }
}
