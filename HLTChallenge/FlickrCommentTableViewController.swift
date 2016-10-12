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
    
    private lazy var button: UIButton = {
        let b = UIButton.init <^> CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        b.setTitle("Dismiss", for: .normal)
        b.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        b.tintColor = .white
        b.layer.backgroundColor = UIColor.blue.cgColor
        return b
    }()

    override func setEmptyBackgroundLabel() {
        print("SET BG")
        tableView.backgroundView = button
        tableView.separatorStyle = .none
    }
    
    private let dismiss: (Void) -> Void
    
    init(dismiss: @escaping (Void) -> Void) {
        self.dismiss = dismiss
        super.init()
    }
    
    dynamic private func tapped() {
        dismiss()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
}

