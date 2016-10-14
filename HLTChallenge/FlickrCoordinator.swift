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
    private var halfPresController: HalfSizePresentationController?
    
    // MARK: - Initialization
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - SubCoordinator Conformance
    
    func start() {
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
        
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
        let flickrCommentTableViewController = FlickrCommentTableViewController { _ in self.rootNavigationController.dismiss(animated: true) }
        flickrCommentTableViewController.modalPresentationStyle = .custom
        flickrCommentTableViewController.transitioningDelegate  = self
        
        halfPresController = HalfSizePresentationController(flickrPhoto: flickrPhoto, presentedViewController: flickrCommentTableViewController, presenting: nil)
        
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
        print("presented", presented)
        print("presenting", presenting)
        print("source", source)
        
        return halfPresController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentAnimationController()
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print("func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) CALLED", navigationController)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) CALLED", navigationController)
    }
    
//    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        
//        
//        print("func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? CALLED")
//        
//        switch operation {
//        case .none: print("No operation for", navigationController)
//        case .pop:  print("Pop operation for", navigationController)
//        case .push: print("Push operation for", navigationController)
//        }
//        
//        return CustomPresentAnimationController()
//    }
}

















//    // TODO: DELETE THIS!!!
//    var repeatCount = 0
//
//    private func preLoadPhotos(for flickrPhotoTableViewController: FlickrPhotoTableViewController, at rows: [Int]) {
//        let count = flickrPhotoTableViewController.data.count
//        guard let picturesPerPage = Int(FlickrConstants.Parameters.Values.Metadata.picturesPerPage), let max = rows.max() else { print("NILLLL");return }
//        print("Prefetched rows:", rows, "---- data count:", count, "---- ppp:", picturesPerPage)
//        if max == count - 1 {
//            print("yeeeeee")
//
////            FlickrPhotoMetadata.getPhotosStream(startingAt: count) { result in
////                switch result {
////                case let .error(error):       debugPrint(error)
////                case let .value(flickrPhoto):
////
////                    if !flickrPhotoTableViewController.data.contains(flickrPhoto) {
////                        flickrPhotoTableViewController.data.append(flickrPhoto)
////                        self.repeatCount += 1
//////                        print("REPEAT =", self.repeatCount)
////                    }
////                }
////            }
//
//
//        }
//    }
