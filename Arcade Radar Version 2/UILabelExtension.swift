//
//  UILabelExtension.swift
//  Arcade Radar Version 2
//
//  Created by iOS Developer on 7/24/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit

extension UILabel {
    func addTextSpacing() {
        if let textString = text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSKernAttributeName, value: 1.2, range: NSRange(location: 0, length: attributedString.length - 1))
         
            attributedText = attributedString
        }
    }
}
