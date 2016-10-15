//
//  FlickrCommentTableViewControllerStyleSheet.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/10/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrCommentTableViewControllerStyleSheet

struct FlickrCommentTableViewControllerStyleSheet: ViewPreparer {
    
    // MARK: - ViewPreparer Conformance
    
    static func prepare(_ commentsTVC: FlickrCommentTableViewController) {
        
        defer { commentsTVC.view.layoutIfNeeded() }
        
        commentsTVC.view.backgroundColor = .clear
        commentsTVC.tableView.allowsSelection = false
    }
}

