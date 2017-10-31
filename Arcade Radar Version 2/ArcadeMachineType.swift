//
//  ArcadeMachineType.swift
//  Arcade Radar
//
//  Created by Matthew Krager on 6/6/16.
//  Copyright © 2016 Matthew Krager. All rights reserved.
//

import UIKit
import Gloss
import FirebaseDatabase

struct ArcadeMachineType: Decodable {
    var objectId: String! = "KragerAdmin"
    var name: String! = "Default Name"
    var year: Int?
    var manufacturer: String?
    var genre: String?
    var creatorId: String! = "KragerAdmin"
    var lowercasedName: String! {
        get {
            return name.lowercased()
        }
    }
    
    init () { }
    
    init?(snapshot: DataSnapshot) {
        guard let json = snapshot.value as? JSON else {
            return nil
        }
        self.init(json:json)
        self.objectId = snapshot.key
        guard self.objectId != nil else {
            return nil
        }
    }
    
    init?(json: JSON) {
        self.name = "Name" <~~ json
        self.creatorId = "CreatorId" <~~ json
        self.genre = "Genre" <~~ json
        self.manufacturer = "Manufacturer" <~~ json
        self.year = "Year" <~~ json
    }

}
