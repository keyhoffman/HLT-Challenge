//
//  FlickrTableViewController.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrTableViewControllerConfiguration

struct FlickrTableViewControllerConfiguration {
    let didSelectPhoto: (FlickrPhotoMetadata) -> Void
}

// MARK: - FlickrTableViewController

final class FlickrTableViewController: TableViewContoller<FlickrTableViewCell>, Preparable, UITextFieldDelegate {

    // MARK: - Property Delcarations
    
    lazy var searchTextField: UITextField = {
        let tf      = FlickrTableViewControllerStyleSheet.TextField.search.textField
        tf.isHidden = true
        tf.delegate = self
//        tf.becomeFirstResponder()
        return tf
    }()
    
    lazy var displaySearchTextFieldButton: UIBarButtonItem = {
        let bbi    = FlickrTableViewControllerStyleSheet.BarButtonItem.displaySearchTextField.barButtonItem
        bbi.target = self
        bbi.action = #selector(displaySearchTextField)
        return bbi
    }()
    
    private var selectedIndexPath: IndexPath?
    private let didSelectPhoto: (FlickrPhotoMetadata) -> Void
    
    // MARK: - Initialization
    
    init(configuration: FlickrTableViewControllerConfiguration) {
        didSelectPhoto = configuration.didSelectPhoto
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
//        didSelectPhoto()
        defer { animateCellHeightChange(withDuration: 0.3, at: indexPath) }
        guard let _selectedIndexPath = selectedIndexPath, _selectedIndexPath == indexPath else {
            selectedIndexPath = indexPath
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = nil
    }
    
    // TODO: Move to stylesheet
    private var defaultCellHeight:  CGFloat { return view.frame.height * 0.6 }
    private var selectedCellHeight: CGFloat { return view.frame.height * 0.9 }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard selectedIndexPath == indexPath else { return defaultCellHeight }
        return selectedCellHeight
    }
    
    private func animateCellHeightChange(withDuration duration: TimeInterval, at indexPath: IndexPath) {
        UIView.animate(withDuration: duration) { 
            self.tableView.beginUpdates()
            if let _ = self.selectedIndexPath {
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            self.tableView.endUpdates()
        }
    }
    
    // MARK: - Preparable Conformance
    
    func prepare() {
        defer { FlickrTableViewControllerStyleSheet.prepare(self) }
    }
    
    dynamic private func displaySearchTextField() {
        print("display search text field")
    }
}
