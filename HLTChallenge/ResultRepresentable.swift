//
//  ResultRepresentable.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/6/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

protocol ResultRepresentable {}

extension Array:      ResultRepresentable {}
extension UIImage:    ResultRepresentable {}
extension Data:       ResultRepresentable {}
extension Dictionary: ResultRepresentable {}
extension URLRequest: ResultRepresentable {}
extension URL:        ResultRepresentable {}
