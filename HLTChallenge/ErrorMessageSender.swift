//
//  ErrorMessageSender.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/7/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

// MARK: - ErrorMessageSender Protocol

protocol ErrorMessageSender: CustomStringConvertible {}



extension ErrorMessageSender {
    var messagePrefix: String {
        return "Oooops... Something went wrong!\n"
    }
}
