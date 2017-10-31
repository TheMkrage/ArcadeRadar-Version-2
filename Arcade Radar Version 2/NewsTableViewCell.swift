//
//  NewsTableViewCell.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 6/30/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.descriptionView?.isUserInteractionEnabled = false
        self.selectionStyle = .none
    }
}
