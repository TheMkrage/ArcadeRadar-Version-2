//
//  UserSession.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 7/8/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import FirebaseDatabase

/* class UserSession: NSObject {
    static var shared: UserSession = UserSession()
    var username: String?
    var userId: String?
    var hasStartedRequest = false
    
    private override init() {
        self.username = UserDefaults.standard.string(forKey: "Username")
        self.userId =  UserDefaults.standard.string(forKey: "UserId")
    }
    
    func hasAccountMade() -> Bool {
        return self.username != nil
    }
    
    // Should be called to initially create an account
    func createAccount(withUsername username: String, email: String, password: String, callback: @escaping (Bool) -> Void) {
        if hasStartedRequest {
            return
        }
        if hasAccountMade() {
            fatalError("This should never happen")
        }
        hasStartedRequest = true
        let username = username.lowercased()
        Database.database().reference().child("users").queryOrdered(byChild: "Username").queryEqual(toValue: username).observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                let userData = ["Username" : username, "Email" : email, "Password" : password] as [String : Any]
                Database.database().reference().child("users").childByAutoId().setValue(userData, withCompletionBlock: { (error, ref) in
                    UserDefaults.standard.set(ref.key, forKey: "UserId")
                    UserDefaults.standard.set(username, forKey: "Username")
                    self.username = username
                    self.userId = ref.key
                    callback(true)
                })
            } else {
                self.hasStartedRequest = false
                callback(false)
            }
        })
    }
    
    func loginToAccount(username: String, password: String, callback: @escaping (Bool, String) -> Void) {
        let username = username.lowercased()
        
        Database.database().reference().child("users").queryOrdered(byChild: "Username").queryEqual(toValue: username).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? Dictionary<String, Any>, snapshot.exists() {
                if (dictionary["Password"] as? String) == password {
                    callback(true, "Successfully logged in")
                } else {
                    callback(false, "Incorrect username and password")
                }
            } else {
                callback(false, "Username not found")
            }
        })
    }
    
    func signout() {
        
    }
    
    func getUser(forId id: String, callback: @escaping (User?) -> Void) {
        Database.database().reference().child("users").child(id).observeSingleEvent(of: .value) { (snapshot) in
            callback(User(snapshot: snapshot))
        }
    }
}*/
