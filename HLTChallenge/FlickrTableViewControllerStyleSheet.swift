//
//  FlickrTableViewControllerStyleSheet.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

struct FlickrTableViewControllerStyleSheet: ViewPreparer {
    
    static func prepare(_ flickrTVC: FlickrTableViewController) {
        
        defer { flickrTVC.view.layoutSubviews() }
        
        flickrTVC.tableView.rowHeight = 200
        
        flickrTVC.navigationItem.titleView = flickrTVC.searchTextField
        flickrTVC.navigationItem.rightBarButtonItem = flickrTVC.displaySearchButton
        
    }
}
