//
//  FlickrCoordinator.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

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
        
        FlickrImage.loadAll { result in
            switch result {
            case let .error(error):  debugPrint(error)
            case let .value(images): let _ = images.map { print($0) }
            }
        }
        
    }
    
    private func photo(from image: FlickrImage, withBlock block: @escaping (Result<UIImage>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let data = URL(string: image.url).flatMap { (try? Data(contentsOf: $0)) }
            DispatchQueue.main.async {
                block <^> data.flatMap { UIImage(data: $0) }.toResult()
            }
            
        }
    }
    
    private func navigateToImageDetailView() {
        print("NAVIGATE")
    }
}

