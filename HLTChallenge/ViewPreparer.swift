//
//  ViewPreparer.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - ViewPreparer

protocol ViewPreparer {
    associatedtype SubjectType: Preparable
    static func prepare(_ subject: SubjectType)
}

