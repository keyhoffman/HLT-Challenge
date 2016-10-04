//
//  ViewPreparer.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

protocol ViewPreparer {
    associatedtype SubjectType: Prerparable
    static func prepare(_ subject: SubjectType)
}

