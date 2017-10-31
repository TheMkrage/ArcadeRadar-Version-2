//
//  VisitSaver.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 7/28/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit

// Class for saving the last time a user visited somewhere (used for awarding XP)
struct VisitSaver {
    static var shared = VisitSaver()
    
    private init() { }
    
    func shouldAwardXpForVisitingArcade(withId id: String) -> Bool {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDateString = dateFormatter.string(from: date)
        guard let dateLastVisited = UserDefaults.standard.string(forKey: "LastVisit" + id) else {
            UserDefaults.standard.set(currentDateString, forKey: "LastVisit" + id)
            return true
        }
        if dateLastVisited == currentDateString {
            return false
        }
        UserDefaults.standard.set(currentDateString, forKey: "LastVisit" + id)
        return true
    }
}
