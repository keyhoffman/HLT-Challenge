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
    
    
    // MARK: - Preparable Conformance
    
    func prepare() {
        defer { FlickrCommentTableViewCellStyleSheet.prepare(self) }
    }
    
    // MARK: - Configurable Conformance
    
    func configure(withData comment: FlickrPhotoComment) {
        defer { prepare() }
        
    }
}

