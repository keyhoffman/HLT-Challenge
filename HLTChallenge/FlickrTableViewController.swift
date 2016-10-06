//
//  FlickrTableViewController.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

struct FlickrTableViewControllerConfiguration {
    let didSelectPhoto: (Void) -> Void
}

final class FlickrTableViewController: TableViewContoller<FlickrTableViewCell>, Prerparable, UITextFieldDelegate {

    lazy var searchTextField: UITextField = {
        let tf      = FlickrTableViewControllerStyleSheet.TextField.search.textField
        tf.isHidden = true
        tf.delegate = self
        tf.becomeFirstResponder()
        return tf
    }()
    
    lazy var displaySearchTextFieldButton: UIBarButtonItem = {
        let bbi    = FlickrTableViewControllerStyleSheet.BarButtonItem.displaySearchTextField.barButtonItem
        bbi.target = self
        bbi.action = #selector(displaySearchTextField)
        return bbi
    }()
    
    private let didSelectPhoto: (Void) -> Void
    
    init(configuration: FlickrTableViewControllerConfiguration) {
        didSelectPhoto = configuration.didSelectPhoto
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defer { prepare() }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectPhoto()
    }
    
    func prepare() {
        defer { FlickrTableViewControllerStyleSheet.prepare(self) }
    }
    
    dynamic private func displaySearchTextField() {
        print("display search text field")
    }
}
