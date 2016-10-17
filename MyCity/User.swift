//
//  User.swift
//  MyCity
//
//  Created by Alec Griffin on 10/16/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class User{
    
    var user:FIRUser?
    var firstName:String
    var lastName:String
    var ref: FIRDatabaseReference!

    
    init() {
        // Initialize Database
        ref = FIRDatabase.database().reference()
        
        // Initalize Current User
//        var currentUser:FIRUser? = nil;
//        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
//            
//            if user != nil {
//                print("User Currently Logged In!")
//                currentUser = user!
//            } else {
//                print("User not Logged In!")
//                
//            }
//        }
//        user = currentUser
//        
//        let userID = FIRAuth.auth()?.currentUser?.uid
//        ref.child("users").child(userID).observeSingleEvent
        
        
        
        
    }
    



}
