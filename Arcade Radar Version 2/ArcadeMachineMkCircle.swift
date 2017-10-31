//
//  ArcadeMachineMkCircle.swift
//  Arcade Radar
//
//  Created by Matthew Krager on 5/7/16.
//  Copyright © 2016 Matthew Krager. All rights reserved.
//

import UIKit
import MapKit

class ArcadeMachineMkCircle: RateableLocationMKCircle {
    public var machine: ArcadeMachine? {
        get {
            guard let machine = self.rateableLocation as? ArcadeMachine else {
                return nil
            }
            return machine
        }
        set(machine) {
            self.rateableLocation = machine
            guard let machine = machine else {
                return
            }
            self.title = machine.name
            if let lastSeen = machine.lastSeen {
                self.subtitle = "Last Seen on \(lastSeen.getFormattedDate())"
            }
        }
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let machineObj = (object as? ArcadeMachineMkCircle)?.machine else {
            return false
        }
        return self.machine?.objectId == machineObj.objectId
    }
}
