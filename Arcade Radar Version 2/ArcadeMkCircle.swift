//
//  ArcadeMkCircle.swift
//  Arcade Radar
//
//  Created by Matthew Krager on 6/6/16.
//  Copyright © 2016 Matthew Krager. All rights reserved.
//

import UIKit
import MapKit

class ArcadeMkCircle: RateableLocationMKCircle {
    public var arcade: Arcade? {
        get {
            guard let arcade = self.rateableLocation as? Arcade else {
                return nil
            }
            return arcade
        }
        set(arcade) {
            guard let arcade = arcade else {
                return
            }
            self.rateableLocation = arcade
            self.title = arcade.name
            if arcade.status == .open {
                self.subtitle = "\(arcade.machineIds?.count ?? 0) Games"
            } else if arcade.status == .unsure {
                self.subtitle = "We aren't sure if this arcade still exists"
            } else {
                self.subtitle = "CLOSED"
            }

        }
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let arcadeObj = (object as? ArcadeMkCircle)?.arcade else {
            return false
        }
        return self.arcade?.objectId == arcadeObj.objectId
    }

}
