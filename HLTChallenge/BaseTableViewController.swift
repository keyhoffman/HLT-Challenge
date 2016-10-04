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
    
    // MARK: Property Declarations
    
    private let cellIdentifier = String(describing: Cell.self)
    
    var data: [DataType] = [] {
        didSet { tableView.reloadData() }
    }
    
    // MARK: Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(Cell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    // MARK: UITableViewDatasource Conformance Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(data.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Cell else {
            fatalError(FatalError.couldNotDequeueCell(identifier: cellIdentifier).debugDescription)
        }
        let row = indexPath.row
        cell.configure(withData: data[row])
        return cell
    }
}

