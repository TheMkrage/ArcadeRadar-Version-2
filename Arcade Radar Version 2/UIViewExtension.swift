//
//  UIViewExtension.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 7/16/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit

extension UIView {

    func addBlurEffect() {
        self.backgroundColor = UIColor.clear
        var blurEffect = UIBlurEffect(style: .extraLight)
        if #available(iOS 10.0, *) {
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
            
        }
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.bounds
        blurEffectView.alpha = 0.95
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.cornerRadius = 25.0
        blurEffectView.clipsToBounds = true
        self.addSubview(blurEffectView)
        self.sendSubview(toBack: blurEffectView)
    }
    
    func addHeavyBlurEffect() {
        self.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        self.sendSubview(toBack: blurEffectView)
    }
}
