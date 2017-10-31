//
//  Model.swift
//  Arcade Radar Version 2
//
//  Created by iOS Developer on 7/28/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import Gloss

// basic protocol for all items coming from api (contains ID)
protocol Model: class, Glossy {
    
    var objectId: String! { get set }
    var lastSeen: Date? { get set }
    var creatorId: String! { get set }
    var createdAt: Date? { get set }
    
}

extension Model {
    func setModel(json: JSON) {
        self.createdAt = getDate(key: "CreatedAt", json: json)
        self.creatorId = "CreatorId" <~~ json
        self.lastSeen = getDate(key: "LastSeen", json: json)
    }
    
    func getDate(key: String, json: JSON) -> Date? {
        guard let stringFormat: String = key <~~ json else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: stringFormat)
    }
    
    func getModelJSON() -> JSON? {
        let dictionary = [
            "CreatedAt" ~~> self.createdAt?.getBackendDate(),
            "CreatorId" ~~> self.creatorId,
            "LastSeen" ~~> self.lastSeen?.getBackendDate()
        ]
        return jsonify(dictionary)
    }
}


