//
//  FlickrCommentTableViewCellStyleSheet.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/10/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrCommentTableViewCellStyleSheet

struct FlickrCommentTableViewCellStyleSheet: ViewPreparer {
    
    static func prepare(_ commentCell: FlickrCommentTableViewCell) {
        
        defer { commentCell.layoutIfNeeded() }
        
        let stackViewTop      = curry(NSLayoutConstraint.init) <^> commentCell.stackView <^> .top      <^> .equal <^> commentCell <^> .top      <^> 1 <^> 0
        let stackViewBottom   = curry(NSLayoutConstraint.init) <^> commentCell.stackView <^> .bottom   <^> .equal <^> commentCell <^> .bottom   <^> 1 <^> 0
        let stackViewLeading  = curry(NSLayoutConstraint.init) <^> commentCell.stackView <^> .leading  <^> .equal <^> commentCell <^> .leading  <^> 1 <^> 0
        let stackViewTrailing = curry(NSLayoutConstraint.init) <^> commentCell.stackView <^> .trailing <^> .equal <^> commentCell <^> .trailing <^> 1 <^> 0
        
        let stackViewConstraints = [stackViewTop, stackViewBottom, stackViewLeading, stackViewTrailing]
        
        let activeConstraints = stackViewConstraints
        
        NSLayoutConstraint.activate(activeConstraints)
    }
    
    // MARK: - Label
    
    enum Label: Int {
        case content = 1, author = 2
        
        var label: UILabel {
            let l                                       = UILabel()
            l.tag                                       = rawValue
            l.backgroundColor                           = backgroundColor
            l.textColor                                 = textColor
            l.textAlignment                             = textAlignment
            l.numberOfLines                             = numberOfLines
            l.adjustsFontSizeToFitWidth                 = adjustsFontSizeToFitWidth
            l.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
            return l
        }
        
        private var backgroundColor: UIColor {
            switch self {
            case .content: return .blue
            case .author:  return .red
            }
        }
        
        private var textColor: UIColor {
            switch self {
            case .content: return .white
            case .author:  return .white
            }
        }
        
        private var textAlignment: NSTextAlignment {
            switch self {
            case .content: return .left
            case .author:  return .left
            }
        }
        
        private var numberOfLines: Int {
            switch self {
            case .content: return 0
            case .author:  return 1
            }
        }
        
        private var adjustsFontSizeToFitWidth: Bool {
            switch self {
            case .content: return true
            case .author:  return false
            }
        }
        
        private var translatesAutoresizingMaskIntoConstraints: Bool {
            switch self {
            case .content: return false
            case .author:  return false
            }
        }
    }

}


