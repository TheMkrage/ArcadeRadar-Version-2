//
//  BrowseArcadeTableViewCell.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 7/13/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit

class BrowseArcadeTableViewCell: UITableViewCell {

    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var arcadeNameLAbel: UILabel!
    @IBOutlet var compassView: UIImageView!
    @IBOutlet weak var gameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setRotation(angle: CGFloat) {
        UIView.animate(withDuration: 0.35) {
            self.compassView.transform = CGAffineTransform(rotationAngle: angle.degreesToRadians)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
