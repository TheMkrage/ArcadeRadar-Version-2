//
//  ArcadeSession.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 8/10/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct ArcadeSession {
    static var shared = ArcadeSession()
    
    private init() {    }
    
    func get(byId id: String, completion: @escaping (Arcade?) -> Void ) {
        Database.database().reference().child("arcade").child(id).observeSingleEvent(of: .value) { (snapshot) in
            completion(Arcade(snapshot: snapshot))
        }
    }
    
    func add(arcade: Arcade) -> String {
        arcade.createdAt = Date()
        arcade.lastSeen = Date()
        let id = Database.database().reference().child("arcade").childByAutoId()
        id.setValue(arcade.toJSON())
        return id.key
    }
    
    func update(arcade: Arcade) {
        guard let json = arcade.toJSON() else {
            return
        }
        Database.database().reference().child("arcade").child(arcade.objectId).updateChildValues(json)
    }
}
