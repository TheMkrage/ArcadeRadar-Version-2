//
//  Arcade.swift
//  Arcade Radar
//
//  Created by Matthew Krager on 6/6/16.
//  Copyright © 2016 Matthew Krager. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase
import Gloss

class Arcade: RateableLocation {

    enum ArcadeStatus {
        case open, unsure, closed
    }
    
    var objectId: String! = "KragerAdmin"
    var lastSeen: Date?
    var creatorId: String! = "KragerAdmin"
    var createdAt: Date?
    
    var finds: Int! = 1
    var notFinds: Int! = 0
    var latitude: Double! = 0
    var longitude: Double! = 0
    var comments: [Comment]! = [Comment]()
    
    var name: String! = "Default Name"
    var lowercasedName: String! {
        get {
            return name.lowercased()
        }
    }
    var website: String?
    var address: String?
    var phoneNumber: String?
    var schedule: String?
    var machineIds: [String]?
    var geoPoint: CLLocationCoordinate2D! {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    var status: ArcadeStatus {
        if notFinds > 50 {
            return .closed
        } else if self.machineIds == nil || self.machineIds?.count == 0 || notFinds > 25 {
            return .unsure
        }
        return .open
    }
    
    init() { }
    
    convenience init?(snapshot: DataSnapshot) {
        guard let json = snapshot.value as? JSON else {
            return nil
        }
        self.init(json: json)
        self.objectId = snapshot.key
        guard objectId != nil else {
            return nil
        }
    }
    
    required convenience init?(json: JSON) {
        self.init()
        self.setLocationData(json: json)
        self.setModel(json: json)
        if let name = json["Name"] as? String {
            self.name = name.replacingOccurrences(of: "&amp;", with: "&")
        }
        
        self.website = "Website" <~~ json
        self.address = "Address" <~~ json
        self.phoneNumber = "PhoneNumber" <~~ json
        self.schedule = "Schedule" <~~ json
        self.machineIds = "MachineIds" <~~ json
        //self.lowercasedName = "LowercasedName" <~~ json
    }
    
    func toJSON() -> JSON? {
        var dictionary = [
            "Name" ~~> self.name,
            "Website" ~~> self.website,
            "Address" ~~> self.address,
            "PhoneNumber" ~~> self.phoneNumber,
            "Schedule" ~~> self.schedule,
            "LowercasedName" ~~> self.lowercasedName,
            "MachineIds" ~~> self.machineIds,
        ]
        dictionary.append(self.getModelJSON())
        dictionary.append(self.getLocationJSON())
        return jsonify(dictionary)
    }
}
