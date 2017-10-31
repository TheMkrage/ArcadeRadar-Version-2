//
//  CommentSession.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 8/8/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import Firebase

struct CommentSession {
    static var shared = CommentSession()
    
    private init() {    }
    
    func save(comment: Comment, isArcade: Bool, locationId: String) {
        var path = "machine"
        if isArcade {
            path = "arcade"
        }
         Database.database().reference().child(path).child(locationId).child("Comments").childByAutoId().setValue(comment.toJSON())
    }
}
