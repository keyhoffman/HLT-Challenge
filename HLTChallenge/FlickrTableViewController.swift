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

    let searchTextField = UITextField()
    
    let displaySearchButton = UIBarButtonItem()
    
    let didSelectPhoto: (Void) -> Void
    
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
        
        searchTextField.placeholder = "FOOOO"
        searchTextField.becomeFirstResponder()
        searchTextField.borderStyle = .line
        
        view.backgroundColor = .blue
        displaySearchButton.title = "BUTT"
    }
    
    
    func prepare() {
        defer { FlickrTableViewControllerStyleSheet.prepare(self) }
    }
}
