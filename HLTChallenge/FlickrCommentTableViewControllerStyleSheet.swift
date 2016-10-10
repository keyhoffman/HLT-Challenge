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
    
    static func prepare(_ tableVC: FlickrCommentTableViewController) {
        
        defer { tableVC.view.layoutSubviews() }
        
        tableVC.title = "comments"
    }
}

