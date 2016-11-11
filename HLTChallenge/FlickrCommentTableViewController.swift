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
    
    // MARK: - BaseTableViewController Overridden Methods
    
    override func setEmptyBackgroundLabel() {
        emptyMessageLabel.text            = "This photo has no comments"
        emptyMessageLabel.textColor       = .lightGray
        emptyMessageLabel.backgroundColor = .clear
        
        tableView.backgroundView = emptyMessageLabel
        tableView.separatorStyle = .none
    }
    
    // MARK: - UITableViewDelegateConformance Conformance
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// MARK: - FlickrCommentTableViewControllerStyleSheet

fileprivate struct FlickrCommentTableViewControllerStyleSheet: ViewPreparer {
    
    // MARK: - ViewPreparer Conformance
    
    fileprivate static func prepare(_ commentsTVC: FlickrCommentTableViewController) {
        
        defer { commentsTVC.view.layoutIfNeeded() }
        
        commentsTVC.view.backgroundColor = .clear
        commentsTVC.tableView.allowsSelection = false
    }
}
