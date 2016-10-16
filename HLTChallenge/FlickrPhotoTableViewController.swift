//
//  FlickrTableViewController.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrPhotoTableViewControllerConfiguration

struct FlickrPhotoTableViewControllerConfiguration {
    let didSelectPhoto:                      (FlickrPhoto) -> Void
    let hasRequestedDataRefreshForTableView: (FlickrPhotoTableViewController) -> Void
}

// MARK: - FlickrPhotoTableViewController

final class FlickrPhotoTableViewController: TableViewContoller<FlickrPhotoTableViewCell>, UITableViewDataSourcePrefetching, Preparable, UITextFieldDelegate {

    // MARK: - Property Delcarations
    
    lazy var searchTextField: UITextField = { [weak self] in
        let tf      = FlickrPhotoTableViewControllerStyleSheet.TextField.search.textField
        tf.isHidden = true
        tf.delegate = self
//        tf.becomeFirstResponder()
        return tf
    }()
    
    lazy var displaySearchTextFieldButton: UIBarButtonItem = { [weak self] in
        let bbi    = FlickrPhotoTableViewControllerStyleSheet.BarButtonItem.displaySearchTextField.barButtonItem
        bbi.target = self
        bbi.action = #selector(displaySearchTextField)
        return bbi
    }()
    
    private lazy var refreshController: UIRefreshControl = {
        let rc = FlickrPhotoTableViewControllerStyleSheet.RefreshControl.tableViewTop.refreshControl
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return rc
    }()
    
    private let didSelectPhoto:                      (FlickrPhoto) -> Void
    private let hasRequestedDataRefreshForTableView: (FlickrPhotoTableViewController) -> Void
    
    // MARK: - Initialization
    
    init(configuration: FlickrPhotoTableViewControllerConfiguration) {
        didSelectPhoto = configuration.didSelectPhoto
        hasRequestedDataRefreshForTableView = configuration.hasRequestedDataRefreshForTableView
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defer { prepare() }
    }
    
    // MARK: - UITableView Delegate Conformance
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectPhoto <^> data[indexPath.row]
     }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - UITableViewDataSourcePrefetching Conformance
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        handlePrefetch(self, indexPaths.map { $0.row })
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    }
    
    // MARK: - Preparable Conformance
    
    func prepare() {
        defer { FlickrPhotoTableViewControllerStyleSheet.prepare(self) }
        tableView.prefetchDataSource = self
        self.refreshControl = refreshController
    }
    
    dynamic private func handleRefresh() {
        hasRequestedDataRefreshForTableView(self)
    }
    
    dynamic private func displaySearchTextField() {
        print("display search text field")
    }
}
