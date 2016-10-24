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
    let didSelectPhoto:        (FlickrPhoto) -> Void
    let loadPhotosForNextPage: (FlickrPhotoTableViewController, Int) -> Void
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
        bbi.action = .displaySearchTextField
        return bbi
    }()
    
    private lazy var refreshController: UIRefreshControl = { [weak self] in
        let rc = FlickrPhotoTableViewControllerStyleSheet.RefreshControl.tableViewTop.refreshControl
        rc.addTarget(self, action: .handleRefresh, for: .valueChanged)
        return rc
    }()
    
    private let didSelectPhoto:        (FlickrPhoto) -> Void
    private let loadPhotosForNextPage: (FlickrPhotoTableViewController, Int) -> Void
    
    // MARK: - Initialization
    
    init(configuration: FlickrPhotoTableViewControllerConfiguration) {
        didSelectPhoto        = configuration.didSelectPhoto
        loadPhotosForNextPage = configuration.loadPhotosForNextPage
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
        didSelectPhoto <| data[indexPath.row]
     }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - UIScrollViewDelegate Conformance
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.height) else { return }
        loadPhotosForNextPage(self, tableView.numberOfRows(inSection: 0) - 1) // FIXME: THIS IS GROSS
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
    
    dynamic fileprivate func handleRefresh() {
        loadPhotosForNextPage(self, tableView.numberOfRows(inSection: 0) - 1) // FIXME: THIS IS GROSS
    }
    
    dynamic fileprivate func displaySearchTextField() {
        fatalError()
    }
}

private extension Selector {
    static let handleRefresh          = #selector(FlickrPhotoTableViewController.handleRefresh)
    static let displaySearchTextField = #selector(FlickrPhotoTableViewController.displaySearchTextField)
}
