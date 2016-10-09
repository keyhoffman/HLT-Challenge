//
//  FlickrTableViewControllerStyleSheet.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrTableViewControllerStyleSheet

struct FlickrTableViewControllerStyleSheet: ViewPreparer {
    
    // MARK: - ViewPreparer Conformance
    
    static func prepare(_ flickrTVC: FlickrTableViewController) {
        
        defer { flickrTVC.view.layoutSubviews() }
        
        flickrTVC.navigationItem.titleView = flickrTVC.searchTextField
        flickrTVC.navigationItem.rightBarButtonItem = flickrTVC.displaySearchTextFieldButton
    }
    
    // MARK: - BarButtonItem
    
    enum BarButtonItem: Int {
        case displaySearchTextField = 1
        
        var barButtonItem: UIBarButtonItem {
            let bbi   = UIBarButtonItem()
            bbi.tag   = rawValue
            bbi.title = title
            return bbi
        }
        
        private var title: String {
            switch self {
            case .displaySearchTextField: return "Search"
            }
        }
    }
    
    // MARK: - TextField
    
    enum TextField: Int {
        case search = 1
        
        var textField: UITextField {
            let tf                       = UITextField()
            tf.tag                       = rawValue
            tf.borderStyle               = borderStyle
            tf.placeholder               = placeholder
            tf.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
            tf.autocapitalizationType    = autocapitalizationType
            tf.autocorrectionType        = autocorrectionType
            tf.clearButtonMode           = clearButtonMode
            tf.keyboardAppearance        = keyboardAppearance
            tf.returnKeyType             = returnKeyType
            return tf
        }
        
        private var borderStyle: UITextBorderStyle {
            switch self {
            case .search: return .roundedRect
            }
        }
        
        private var placeholder: String {
            switch self {
            case .search: return "Search for images..."
            }
        }
        
        private var adjustsFontSizeToFitWidth: Bool {
            switch self {
            case .search: return true
            }
        }
        
        private var autocapitalizationType: UITextAutocapitalizationType {
            switch self {
            case .search: return .words
            }
        }
        
        private var autocorrectionType: UITextAutocorrectionType {
            switch self {
            case .search: return .yes
            }
        }
        
        private var clearButtonMode: UITextFieldViewMode {
            switch self {
            case .search: return .whileEditing
            }
        }
        
        private var keyboardAppearance: UIKeyboardAppearance {
            switch self {
            case .search: return .dark
            }
        }
        
        private var returnKeyType: UIReturnKeyType {
            switch self {
            case .search : return .search
            }
        }
    }
}
