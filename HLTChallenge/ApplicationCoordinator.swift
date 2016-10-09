//
//  ApplicationCoordinator.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - ApplicationCoordinator

final class ApplicationCoordinator: Coordinator {
    
    // MARK: - Property Declarations
    
    private let window: UIWindow
    
    // MARK: - Initialization
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Coordinator Conformance
    
    func start() {
        let flickrCoordinator = FlickrCoordinator(window: window)
        flickrCoordinator.start()
    }
    
}
