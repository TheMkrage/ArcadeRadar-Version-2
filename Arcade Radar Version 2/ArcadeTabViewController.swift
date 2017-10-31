//
//  ArcadeTabViewController.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 7/1/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit

class ArcadeTabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = Colors.yesColor
    }
    
    var arcade: Arcade?
}
