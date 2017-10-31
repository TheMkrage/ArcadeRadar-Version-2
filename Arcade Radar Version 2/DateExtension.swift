//
//  DateExtension.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 8/12/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit

extension Date {
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: self)
    }
    
    func getBackendDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
}
