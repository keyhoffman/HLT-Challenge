//
//  Configurable.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

protocol Configurable {
    associatedtype DataType
    func configure(withData data: DataType)
}
