//
//  MachineSession.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 8/18/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import Firebase

struct MachineSession {
    static var shared = MachineSession()
    
    private init() {    }
    
    func get(byId id: String, completion: @escaping (ArcadeMachine?) -> Void ) {
        Database.database().reference().child("machine").child(id).observeSingleEvent(of: .value) { (snapshot) in
            completion(ArcadeMachine(snapshot: snapshot))
        }
    }
    
    func add(machine: ArcadeMachine) -> String {
        let autoId = Database.database().reference().child("machine").childByAutoId()
        autoId.setValue(machine.toJSON())
        Database.database().reference().child("arcade").child(machine.arcadeId ?? "").child("MachineIds").observeSingleEvent(of: .value, with: { (snapshot) in
            var machineIds = snapshot.value as? [String] ?? [String]()
            machineIds.append(autoId.key)
            Database.database().reference().child("arcade").child(machine.arcadeId ?? "").child("MachineIds").setValue(machineIds)
        })
        return autoId.key
    }
    
    func update(machine: ArcadeMachine) {
        guard let json = machine.toJSON() else {
            return
        }
        Database.database().reference().child("machine").child(machine.objectId).updateChildValues(json)
    }

}
