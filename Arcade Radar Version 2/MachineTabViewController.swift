//
//  MachineTabViewController.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 8/5/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit

class MachineTabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = Colors.yesColor
    }
    
    var machine: ArcadeMachine?
}
