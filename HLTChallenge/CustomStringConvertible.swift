//
//  CustomStringConvertibleExt.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/6/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

extension CustomStringConvertible {
    func print_() {
        print(#file, #line, self)
    }
    
    func print_(with context: String) {
        print(#file, #line, context, self)
    }
}

extension CustomDebugStringConvertible {
    func debugPrint_() {
        debugPrint(#file, #line, self)
    }
    
    func debugPrint_(with context: String) {
        debugPrint(#file, #line, context, self)
    }
}
