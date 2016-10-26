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

typealias ResultBlock<T> = (Result<T>) -> Void

// MARK: - Percentage

typealias Percentage = Float

// MARK: - PreparedConfigurable

typealias PreparedConfigurable = Preparable & Configurable

// MARK: - RESTGetableCollection

typealias RESTGetableCollection = Collection & RESTGetable

// MARK: - FlickrGetableCollection

/// RESTGetableCollection = Collection & RESTGetable
typealias FlickrAPIGetableCollection = RESTGetableCollection & FlickrAPIGetable & FlickrCollection
