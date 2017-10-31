//
//  DoubleExtension.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 7/16/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
