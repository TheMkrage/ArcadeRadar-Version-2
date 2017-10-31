//
//  ReportButton.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 7/17/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit

enum ReportButtonState {
    case normal, selected, greyed
}

class ReportButton: UIButton {
    
    private var reportState: ReportButtonState = .normal {
        didSet {
            self.updateAppearanceToState()
        }
    }

    var isYesButton: Bool = true {
        didSet {
            self.updateAppearanceToState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupBackground()
    }
    
    private func setupBackground() {
        if self.titleLabel?.text == "No" {
            self.isYesButton = false
        }
        self.layer.cornerRadius = 12.0
        self.updateAppearanceToState()
    }
    
    private func updateAppearanceToState() {
        // check for special cases where appearance must be updated
        switch self.reportState {
        case .selected:
            self.layer.borderColor = UIColor.black.cgColor
        case .greyed:
            self.layer.borderColor = UIColor.clear.cgColor
            self.backgroundColor = UIColor.gray
        default:
            self.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
}
