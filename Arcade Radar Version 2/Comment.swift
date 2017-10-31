
//
//  Comment.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 8/5/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import Gloss
import UIKit

class Comment: Model {
    var objectId: String! = "KragerAdmin"
    var lastSeen: Date?
    var creatorId: String! = "KragerAdmin"
    var createdAt: Date?
    
    var comment: String!
    var title: String!
    var index: Int?
    
    init() {  }
    
    required convenience init?(json: JSON) {
        self.init()
        self.setModel(json: json)
        self.comment = "Comment" <~~ json
        self.title = "Title" <~~ json
    }
    
    func toJSON() -> JSON? {
        var dictionary = [
            "Comment" ~~> self.comment,
            "Title" ~~> self.title
        ]
        dictionary.append(self.getModelJSON())
        return jsonify(dictionary)
    }

}
