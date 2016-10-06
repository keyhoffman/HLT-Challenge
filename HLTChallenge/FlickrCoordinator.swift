//
//  FlickrCoordinator.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

typealias URLParameters = [String: String]

final class FlickrCoordinator: SubCoordinator {
    
    private let window: UIWindow
    private let rootNavigationController = UINavigationController()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
        
        let flickrTableViewControllerConfig = FlickrTableViewControllerConfiguration(didSelectPhoto: navigateToImageDetailView)
        
        let flickrTableViewController = FlickrTableViewController(configuration: flickrTableViewControllerConfig)
        rootNavigationController.pushViewController(flickrTableViewController, animated: false)
    }
    
    private func navigateToImageDetailView() {
        print("NAVIGATE")
    }
}

