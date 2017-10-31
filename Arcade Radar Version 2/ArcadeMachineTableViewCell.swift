//
//  ArcadeMachineTableViewCell.swift
//  Arcade Radar
//
//  Created by Matthew Krager on 5/7/16.
//  Copyright © 2016 Matthew Krager. All rights reserved.
//

import UIKit

class ArcadeMachineTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pricePerPlayLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    var finds = 1 {
        didSet {
            let mutableAttributedTitle = NSMutableAttributedString(attributedString: self.yesButton.currentAttributedTitle!)
            mutableAttributedTitle.mutableString.setString("\(self.finds)")
            self.yesButton.setAttributedTitle(mutableAttributedTitle, for: .normal)
        }
    }
    
    var notFinds = 0 {
        didSet {
            let mutableAttributedTitle = NSMutableAttributedString(attributedString: self.noButton.currentAttributedTitle!)
            mutableAttributedTitle.mutableString.setString("\(self.notFinds)")
            self.noButton.setAttributedTitle(mutableAttributedTitle, for: .normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.resetAppearance()
    }
    
    func resetAppearance() {
        self.yesButton.backgroundColor = Colors.yesColor
        self.noButton.backgroundColor = Colors.noColor
        self.yesButton.layer.cornerRadius = 15
        self.noButton.layer.cornerRadius = 15
        self.yesButton.layer.borderWidth = 0
        self.noButton.layer.borderWidth = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        
    }
    
    @IBAction func yesButtonPressed(_ sender: Any) {
        self.yesButton.layer.borderWidth = 1.0
        self.yesButton.layer.borderColor = UIColor.black.cgColor
        self.yesButton.backgroundColor = Colors.yesColor
        self.noButton.layer.borderWidth = 0.0
        self.noButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func noButtonPressed(_ sender: Any) {
        self.noButton.layer.borderWidth = 1.0
        self.noButton.layer.borderColor = UIColor.black.cgColor
        self.noButton.backgroundColor = Colors.noColor
        self.yesButton.layer.borderWidth = 0.0
        self.yesButton.backgroundColor = UIColor.lightGray
    }

}
