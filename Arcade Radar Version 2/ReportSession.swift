//
//  ReportSession.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 7/17/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct ReportSession {
    static var shared = ReportSession()
    
    private init() {    }

    // Meant to be run AFTER the finds or notFinds have been updated in the model
    // JUST updates current finds and notFinds from model object to the server
    func report(rateableLocation: RateableLocation, isDisplayingArcade: Bool) {
        let directory = isDisplayingArcade ? "arcade" : "machine"
        Database.database().reference().child(directory).child(rateableLocation.objectId).updateChildValues(["Finds": rateableLocation.finds, "NotFinds": rateableLocation.notFinds, "LastSeen" : Date().getBackendDate()])
        
    }
}
