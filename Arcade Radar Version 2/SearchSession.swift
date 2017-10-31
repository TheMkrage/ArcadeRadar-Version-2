//
//  SearchSession.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 7/19/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct SearchSession {
    static var shared = SearchSession()
    static var lastHandler: UInt = 0
    
    private init() {    }
    
    func search(forMachineType name: String, completionHandler: @escaping (_ machine: ArcadeMachineType) -> Void) {
        let ref = Database.database().reference()
        ref.removeObserver(withHandle: SearchSession.lastHandler)
        SearchSession.lastHandler = ref.child("arcadetype").queryOrdered(byChild: "LowercasedName").queryLimited(toFirst: 15).queryStarting(atValue: name.lowercased()).observe(.childAdded, with: { (snapshot:DataSnapshot) in
            if let type = ArcadeMachineType(snapshot: snapshot) {
                completionHandler(type)
            }       
        }, withCancel: nil)
    }
    
    func search(forArcade name: String, completionHandler: @escaping (_ arcade: Arcade) -> Void) {
        let ref = Database.database().reference()
        ref.removeObserver(withHandle: SearchSession.lastHandler)
        SearchSession.lastHandler = ref.child("arcade").queryOrdered(byChild: "LowercasedName").queryLimited(toFirst: 15).queryStarting(atValue: name.lowercased()).observe(.childAdded, with: { (snapshot:DataSnapshot) in
            if let arcade = Arcade(snapshot: snapshot) {
                completionHandler(arcade)
            }
        }, withCancel: nil)
    }
}
