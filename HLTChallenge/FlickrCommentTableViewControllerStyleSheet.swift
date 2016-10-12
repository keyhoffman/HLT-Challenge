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
    
    static func prepare(_ tableVC: FlickrCommentTableViewController) {
        
        defer { tableVC.view.layoutSubviews() }
        
        tableVC.tableView.rowHeight = UITableViewAutomaticDimension
        
        tableVC.emptyMessageLabel.text = "This photo has no comments!"
        
        tableVC.title = "comments"
    }
}

