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

// MARK: - Selector Extension

fileprivate extension Selector {
    fileprivate static let handleRefresh          = #selector(FlickrPhotoTableViewController.handleRefresh)
    fileprivate static let displaySearchTextField = #selector(FlickrPhotoTableViewController.displaySearchTextField)
}

// MARK: - FlickrPhotoTableViewControllerStyleSheet

fileprivate struct FlickrPhotoTableViewControllerStyleSheet: ViewPreparer {
    
    // MARK: - ViewPreparer Conformance
    
    static func prepare(_ flickrTVC: FlickrPhotoTableViewController) {
        
        defer { flickrTVC.view.layoutIfNeeded() }
        
        
        flickrTVC.tableView.backgroundColor = .darkText
        
        flickrTVC.navigationItem.titleView = flickrTVC.searchTextField
        flickrTVC.navigationItem.rightBarButtonItem = flickrTVC.displaySearchTextFieldButton
    }
    
    // MARK: - BarButtonItem
    
    fileprivate enum BarButtonItem: Int {
        case displaySearchTextField = 1
        
        fileprivate var barButtonItem: UIBarButtonItem {
            let bbi   = UIBarButtonItem()
            bbi.tag   = rawValue
            bbi.title = title
            return bbi
        }
        
        private var title: String {
            switch self {
            case .displaySearchTextField: return "Search"
            }
        }
    }
    
    // MARK: - TextField
    
    fileprivate enum TextField: Int {
        case search = 1
        
        fileprivate var textField: UITextField {
            let tf                       = UITextField()
            tf.tag                       = rawValue
            tf.borderStyle               = borderStyle
            tf.placeholder               = placeholder
            tf.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
            tf.autocapitalizationType    = autocapitalizationType
            tf.autocorrectionType        = autocorrectionType
            tf.clearButtonMode           = clearButtonMode
            tf.keyboardAppearance        = keyboardAppearance
            tf.returnKeyType             = returnKeyType
            tf.clipsToBounds             = clipsToBounds
            return tf
        }
        
        private var borderStyle: UITextBorderStyle {
            switch self {
            case .search: return .roundedRect
            }
        }
        
        private var placeholder: String {
            switch self {
            case .search: return "Search for images..."
            }
        }
        
        private var adjustsFontSizeToFitWidth: Bool {
            switch self {
            case .search: return true
            }
        }
        
        private var autocapitalizationType: UITextAutocapitalizationType {
            switch self {
            case .search: return .words
            }
        }
        
        private var autocorrectionType: UITextAutocorrectionType {
            switch self {
            case .search: return .yes
            }
        }
        
        private var clearButtonMode: UITextFieldViewMode {
            switch self {
            case .search: return .whileEditing
            }
        }
        
        private var keyboardAppearance: UIKeyboardAppearance {
            switch self {
            case .search: return .dark
            }
        }
        
        private var returnKeyType: UIReturnKeyType {
            switch self {
            case .search : return .search
            }
        }
        
        private var clipsToBounds: Bool {
            switch self {
            case .search: return true
            }
        }
    }
    
    fileprivate enum RefreshControl: Int {
        case tableViewTop = 1
        
        fileprivate var refreshControl: UIRefreshControl {
            let rc             = UIRefreshControl()
            rc.tag             = rawValue
            rc.attributedTitle = NSAttributedString(string: title)
            rc.backgroundColor = backgroundColor
            rc.tintColor       = tintColor
            return rc
        }
        
        private var title: String {
            switch self {
            case .tableViewTop: return "Pull to refresh"
            }
        }
        
        private var backgroundColor: UIColor {
            switch self {
            case .tableViewTop: return .cyan
            }
        }
        
        private var tintColor: UIColor {
            switch self {
            case .tableViewTop: return .red
            }
        }
    }
}
