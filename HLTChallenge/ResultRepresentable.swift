//
//  ResultRepresentable.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/6/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - ResultRepresentable Protocol

protocol ResultRepresentable {}

// MARK: - ResultRepresentable Conformance -- Native Swift Types

extension Array:      ResultRepresentable {}
extension UIImage:    ResultRepresentable {}
extension Data:       ResultRepresentable {}
extension Dictionary: ResultRepresentable {}
extension URLRequest: ResultRepresentable {}
extension URL:        ResultRepresentable {}
