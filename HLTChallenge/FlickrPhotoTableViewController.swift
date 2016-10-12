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
    let didSelectPhoto: (FlickrPhotoMetadata) -> Void
    let userHasReachedBottomOfTableView: (_ row: Int) -> Void
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
    
    private let didSelectPhoto: (FlickrPhotoMetadata) -> Void
    private let userHasReachedBottomOfTableView: (_ row: Int) -> Void
    
    // MARK: - Initialization
    
    init(configuration: FlickrPhotoTableViewControllerConfiguration) {
        defer { tableView.prefetchDataSource = self }
        didSelectPhoto = configuration.didSelectPhoto
        userHasReachedBottomOfTableView = configuration.userHasReachedBottomOfTableView
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
        didSelectPhoto <^> data[indexPath.row].metadata
     }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == data.count - 1 else { return }
        userHasReachedBottomOfTableView <^> indexPath.row
    }
    
    // MARK: - UITableViewDataSourcePrefetching Conformance
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("Prefetched rows:", indexPaths.map { $0.row })
        
        guard let row = indexPaths.last?.row, row == data.count - 1 else { return }
        print("GET THIS ROW:", row)
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("Cancelled rows:", indexPaths.map { $0.row })
    }
    
    // MARK: - Preparable Conformance
    
    func prepare() {
        defer { FlickrPhotoTableViewControllerStyleSheet.prepare(self) }
    }
    
    dynamic private func displaySearchTextField() {
        print("display search text field")
    }
}
