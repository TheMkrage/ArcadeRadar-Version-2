//
//  News.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 6/30/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import Gloss
import FirebaseDatabase

struct News: Decodable {
    var title: String?
    var description: String?
    var article: String?
    var date: Date?
    var objectId: String?
    
    init?(snapshot: DataSnapshot) {
        let json: JSON = snapshot.value as! JSON
        self.init(json:json)
        self.objectId = snapshot.key
        guard objectId != nil else {
            return nil
        }
    }
    
    init?(json: JSON) {
        self.title = "Title" <~~ json
        self.description = "Description" <~~ json
        self.article = "Article" <~~ json
        self.date = "Date" <~~ json
    }
}
