//
//  RateableModel.swift
//  Arcade Radar Version 2
//
//  Created by iOS Developer on 7/28/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import CoreLocation
import Gloss

protocol RateableLocation: class, Model {
    var finds: Int! { get set }
    var notFinds: Int! { get set }
    var latitude: Double! { get set }
    var longitude: Double! { get set }
    var comments: [Comment]! { get set }
}

extension RateableLocation {
    
    func setLocationData(json: JSON) {
        if let finds = json["Finds"] as? Int {
            self.finds = finds
        }
        if let notFinds = json["NotFinds"] as? Int  {
            self.notFinds = notFinds
        }
        self.latitude = "Latitude" <~~ json
        self.longitude = "Longitude" <~~ json
        if let jsonArray = json["Comments"] as? NSDictionary {
            for key in jsonArray.allKeys {
                if let jsonRep = jsonArray[key] as? JSON, let currentComment = Comment(json: jsonRep) {
                    self.comments.append(currentComment)
                }
            }
        }
        
    }
    
    func getLocationJSON() -> JSON? {
        return jsonify([
            "Finds" ~~> self.finds,
            "NotFinds" ~~> self.notFinds,
            "Latitude" ~~> self.latitude,
            "Longitude" ~~> self.longitude,
            "Comments" ~~> self.comments
            ])
    }

}


/* var geoPoint: CLLocationCoordinate2D! {
 get {
 return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
 }
 }*/
