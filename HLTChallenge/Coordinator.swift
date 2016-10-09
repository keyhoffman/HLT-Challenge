//
//  Coordinator.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - Coordinator Protocol

protocol Coordinator {
    func start()
}

// MARK: - SubCoordinator Protocol

protocol SubCoordinator: Coordinator {}
