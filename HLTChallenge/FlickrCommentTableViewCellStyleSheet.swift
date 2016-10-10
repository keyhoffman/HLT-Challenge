//
//  FlickrCommentTableViewCellStyleSheet.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/10/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrCommentTableViewCellStyleSheet

struct FlickrCommentTableViewCellStyleSheet: ViewPreparer {
    
    static func prepare(_ commentCell: FlickrCommentTableViewCell) {
        
        defer { commentCell.layoutIfNeeded() }
        
    }
}


