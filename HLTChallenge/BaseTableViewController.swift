//
//  BaseTableViewController.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - TableViewController

class TableViewContoller<Cell: UITableViewCell>: UITableViewController where Cell: Configurable {
    
    typealias DataType = Cell.DataType

    // MARK: - Property Declarations
    
    private let cellIdentifier = String(describing: Cell.self)
    
    lazy var emptyMessageLabel: UILabel = {
        let l           = UILabel.init <^> CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        l.tag           = 0
        l.text          = "No data available"
        l.textColor     = .red
        l.textAlignment = .center
        l.sizeToFit()
        return l
    }()
    
    private var num = 0
    
    var data: [DataType] = [] {
        didSet(oldData) {
            defer {
                tableView.reloadData()
                refreshControl?.endRefreshing()
            }
            guard data.count > 0 else {
                setEmptyBackgroundLabel()
                return
            }
            guard let _ = tableView.backgroundView else { return }
            removeEmptyBackgroundLabel()
        }
    }
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        if data.count < 1 { setEmptyBackgroundLabel() }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setEmptyBackgroundLabel() {
        tableView.backgroundView = emptyMessageLabel
        tableView.separatorStyle = .none
    }
    func removeEmptyBackgroundLabel() {
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
    }
    
     // MARK: - ViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(Cell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
     // MARK: - UITableViewDatasource Conformance Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Cell else {
            fatalError(FatalError.couldNotDequeueCell(identifier: cellIdentifier).debugDescription)
        }
        cell.configure <^> data[indexPath.row]
        return cell
    }
}
