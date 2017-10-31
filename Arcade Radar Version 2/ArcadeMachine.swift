//
//  ArcadeMachine.swift
//  Arcade Radar
//
//  Created by Matthew Krager on 4/24/16.
//  Copyright © 2016 Matthew Krager. All rights reserved.
//

import UIKit
import CoreLocation
import Gloss
import FirebaseDatabase

class ArcadeMachine: RateableLocation {
    
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
    var geoPoint: CLLocationCoordinate2D! {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    var pricePerPlayString: String? // Example: "25 cents for 1 play"
    var arcadeId: String?
    var typeId: String! = "KragerAdmin"

    init() { }
    
    convenience init?(snapshot: DataSnapshot) {
        guard let json: JSON = snapshot.value as? JSON else {
            return nil
        }
        self.init(json:json)
        self.objectId = snapshot.key
        guard objectId != nil else {
            return nil
        }
    }
    
    required init?(json: JSON) {
        self.setModel(json: json)
        self.setLocationData(json: json)
        self.name = "Name" <~~ json
        self.pricePerPlayString = "Price" <~~ json
        self.arcadeId = "ArcadeId" <~~ json
        self.typeId = "TypeId" <~~ json
    }
    
    func toJSON() -> JSON? {
        var dictionary = [
            "Name" ~~> self.name,
            "Price" ~~> self.pricePerPlayString,
            "ArcadeId" ~~> self.arcadeId,
            "TypeId" ~~> self.typeId
        ]
        dictionary.append(self.getModelJSON())
        dictionary.append(self.getLocationJSON())
        return jsonify(dictionary)
    }
}
