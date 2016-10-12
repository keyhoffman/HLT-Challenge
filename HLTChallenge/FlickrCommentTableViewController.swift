//
//  FlickrCommentTableViewController.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/10/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrCommentTableViewController

final class FlickrCommentTableViewController: TableViewContoller<FlickrCommentTableViewCell>, Preparable {
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defer { prepare() }
    }
    
    // MARK: - Preparable Conformance
    
    func prepare() {
        defer { FlickrCommentTableViewControllerStyleSheet.prepare(self) }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        <#code#>
//    }

}

