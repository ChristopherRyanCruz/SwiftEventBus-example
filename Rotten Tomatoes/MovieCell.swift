//
//  MovieCell.swift
//  Rotten Tomatoes
//
//  Created by Chris Cruz on 4/14/15.
//  Copyright (c) 2015 Chris Cruz. All rights reserved.
//

import Foundation
import UIKit

class MovieCell : UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        prepareForReuse()
    }
    
    override func prepareForReuse() {
        posterImageView.image = nil
    }
}