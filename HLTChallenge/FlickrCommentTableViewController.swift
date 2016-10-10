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
    
    // MARK: - Preparable Conformance
    
    func prepare() {
        defer { FlickrCommentTableViewControllerStyleSheet.prepare(self) }
    }
}

