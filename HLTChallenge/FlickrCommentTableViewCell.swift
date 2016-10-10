//
//  FlickrCommentTableViewCell.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/10/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrCommentTableViewCell

final class FlickrCommentTableViewCell: UITableViewCell, Preparable, Configurable {
    
    private let authorLabel  = UILabel()
    private let contentLabel = UILabel()
    
    let stackView = UIStackView()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        defer { prepare() }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Preparable Conformance
    
    func prepare() {
        defer { FlickrCommentTableViewCellStyleSheet.prepare(self) }
        stackView.addArrangedSubviews <^> [contentLabel, authorLabel]
        addSubview(stackView)
    }
    
    // MARK: - Configurable Conformance
    
    func configure(withData comment: FlickrPhotoComment) {
        defer { prepare() }
        authorLabel.text =  comment.author
        contentLabel.text = comment.content
    }
}

