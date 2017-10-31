//
//  LocationTrackingViewController.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 8/9/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import MapKit

class LocationTrackingViewController: UIViewController, CLLocationManagerDelegate {
    
    var lastLocation: CLLocation?
    var lastHeading: CLHeading?
    
    let locationManager: CLLocationManager = {
        $0.requestWhenInUseAuthorization()
        $0.startUpdatingLocation() // now we request to monitor the device location!
        $0.startUpdatingHeading()
        return $0
    }(CLLocationManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        // Do any additional setup after loading the view.
    }

    // MArk: Location Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        lastLocation = currentLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.lastHeading = newHeading
    }
}
