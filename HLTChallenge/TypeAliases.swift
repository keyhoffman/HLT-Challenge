//
//  URLParameters.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/6/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - URLParamters

typealias URLParameters = [String: String]

// MARK: - JSONDictionary

typealias JSONDictionary = [String: Any]

// MARK: - ResultBlock

typealias ResultBlock<T: ResultRepresentable> = (Result<T>) -> Void

// MARK: - Percentage

typealias Percentage = CGFloat
