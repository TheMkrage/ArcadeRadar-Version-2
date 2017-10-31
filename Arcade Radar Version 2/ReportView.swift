//
//  RateOnMapView.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 7/10/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit

protocol ReportViewDelegate: class {
    func learnMorePressed()
    func reportStatusChanged(to result: Bool)
}

class ReportView: ReloadableFromXibView {
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var learnMoreButton: UIButton!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var noButton: UIButton!
    @IBOutlet weak var findLabel: UILabel!
    @IBOutlet weak var notFindLabel: UILabel!
    
    var finds = 1 {
        didSet {
            self.findLabel.text = "\(self.finds) have visited"
        }
    }
    
    var notFinds = 0 {
        didSet {
            self.notFindLabel.text = "\(self.notFinds) were misled"
        }
    }
    
    weak var delegate: ReportViewDelegate?
    
    private var _isDisplayingArcades = false
    var isDisplayingArcades: Bool! {
        get {
            return _isDisplayingArcades
        }
        set(newValue) {
            self._isDisplayingArcades = newValue
            if self._isDisplayingArcades {
               self.questionLabel.text = "Were you able to find this arcade?"
            } else {
                self.questionLabel.text = "Were you able to find this machine?"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addBlurEffect()
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 11.0
        self.clipsToBounds = true
        self.yesButton.backgroundColor = Colors.yesColor
        self.noButton.backgroundColor = Colors.noColor
        self.noButton.titleLabel?.addTextSpacing()
        self.yesButton.titleLabel?.addTextSpacing()
        self.yesButton.layer.cornerRadius = 15
        self.noButton.layer.cornerRadius = 15
    }
    
    @IBAction func learnMorePressed(_ sender: UIButton) {
        self.delegate?.learnMorePressed()
    }

    @IBAction func yesButtonPressed(_ sender: Any) {
        self.delegate?.reportStatusChanged(to: true)
        self.yesButton.layer.borderWidth = 1.0
        self.yesButton.layer.borderColor = UIColor.black.cgColor
        self.yesButton.backgroundColor = Colors.yesColor
        self.noButton.layer.borderWidth = 0.0
        self.noButton.backgroundColor = UIColor.lightGray
        self.layer.borderColor = Colors.yesColor.cgColor
        self.questionLabel.text = "Thanks for your feedback!"
    }
    
    @IBAction func noButtonPressed(_ sender: Any) {
        self.delegate?.reportStatusChanged(to: false)
        self.noButton.layer.borderWidth = 1.0
        self.noButton.layer.borderColor = UIColor.black.cgColor
        self.noButton.backgroundColor = Colors.noColor
        self.yesButton.layer.borderWidth = 0.0
        self.layer.borderColor = Colors.noColor.cgColor
        self.yesButton.backgroundColor = UIColor.lightGray
        self.questionLabel.text = "Thanks for your feedback!"
    }
}
