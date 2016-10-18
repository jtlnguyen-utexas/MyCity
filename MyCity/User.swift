////
////  User.swift
////  MyCity
////
////  Created by Alec Griffin on 10/16/16.
////  Copyright © 2016 cs378. All rights reserved.
////
//
//import Foundation
//import Firebase
//import FirebaseAuth
//import FirebaseDatabase
//
//class User{
//    // main
//    var firstName:String
//    var lastName:String
//    var email:String
//    
//    //others
//    var profilePicture:UIImage?
//    var dateOfBirth:String
//    var age:Int
//    
//    // Location
//    var country:String
//    var state:String
//    var address:String
//    var zipCode:String
//
//    
//    init() {
//    }
//
//    func obtainUserDataFromFireBase(){
//        var ref: FIRDatabaseReference!
//        ref = FIRDatabase.database().reference()
//        
//        let userID = FIRAuth.auth()?.currentUser?.uid
//        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let value = snapshot.value as? NSDictionary
//            let username = value?["username"] as! String
//            let user = User.init(username: username)
//            
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//    }
//
//
//        
//        
//        
////    }
//    
//
//
//
////}
