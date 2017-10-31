//
//  LocationSession.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 7/12/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreLocation

struct LocationSession {
    static var shared = LocationSession()
    
    private init() {    }
    
    func getArcadesInsideOf(seCoord: CLLocationCoordinate2D, nwCoord: CLLocationCoordinate2D, childAddedResponse: @escaping (_ arcade: Arcade) -> Void) {
        Database.database().reference().removeAllObservers()
        print(nwCoord.longitude)
        print(seCoord.longitude)
        Database.database().reference().child("arcade").queryOrdered(byChild: "Longitude").queryStarting(atValue: nwCoord.longitude, childKey: "Longitude").queryEnding(atValue: seCoord.longitude, childKey: "Longitude").queryLimited(toFirst: 50).observe(.childAdded, with: { (snapshot) in
            guard let arcade = Arcade(snapshot: snapshot) else {
                return
            }
            // TODO: Implement longitude check before returning (can be done once data has correct coordinates
            //if arcade.longitude > nwCoord.longitude && arcade.longitude < seCoord.longitude {
            childAddedResponse(arcade)
            //}
        })
    }
    
    func getArcadeMachinesInsideOf(seCoord: CLLocationCoordinate2D, nwCoord: CLLocationCoordinate2D, childAddedResponse: @escaping (_ machine: ArcadeMachine) -> Void) {
        Database.database().reference().removeAllObservers()
        Database.database().reference().child("machine").queryOrdered(byChild: "Longitude").queryStarting(atValue: nwCoord.longitude, childKey: "Longitude").queryEnding(atValue: seCoord.longitude, childKey: "Longitude").queryLimited(toFirst: 250).observe(.childAdded, with: { (snapshot) in
            guard let machine = ArcadeMachine(snapshot: snapshot) else {
                return
            }
            childAddedResponse(machine)
        })
    }
}
