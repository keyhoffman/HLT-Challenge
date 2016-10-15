//
//  UIStackView.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/10/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

extension UIStackView {
    
    /// Adds an array of views to the end of the arrangedSubviews Array
    ///
    /// - parameter views: an array of UIView to be added
    func addArrangedSubviews(_ views: [UIView]) {
        _ = views.map(addArrangedSubview)
    }
    
    func addArrangedSubviews(_ views: [UIView?]) {
        _ = views.flatMap { $0 }.map(addArrangedSubview)
    }
    
    convenience init(withNullableSubViews views: [UIView?]) {
        self.init()
        _ = views.flatMap { $0 }.map(addArrangedSubview)
    }
}

