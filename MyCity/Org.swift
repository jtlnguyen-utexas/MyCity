////
////  User.swift
////  MyCity
////
////  Created by Alec Griffin on 10/16/16.
////  Copyright © 2016 cs378. All rights reserved.
////

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class Org: NSObject {
    
    private var orgRef: FIRDatabaseReference?
    
    
    private var _isUser: Bool = false
    private var _orgKey: String!
    private var _orgName: String!
    private var _emailAddress: String!
    private var _location: String!
    private var _category: String!
    private var _userViewCount: Int!
    private var _userEventsAttended: Int!
    
    var isUser: Bool {
        return _isUser
    }
    
    var orgKey: String {
        return _orgKey
    }
    
    var orgName: String {
        return _orgName
    }
    
    var emailAddress: String {
        return _emailAddress
    }
    
    var location: String {
        return _location
    }
    
    var category: String {
        return _category
    }
    
    var userViewCount: Int {
        return _userViewCount
    }
    
    var userEventsAttended: Int {
        return _userEventsAttended
    }

    // Initialize the new User
    
    init(orgKey: String, orgName: String, emailAddress: String, location: String, category: String, userViewCount: Int, userEventsAttended: Int) {
        
        self._orgKey = orgKey
        self._orgName = orgName
        self._emailAddress = emailAddress
        self._location = location
        self._category = category
        self._userViewCount = userViewCount
        self._userEventsAttended = userEventsAttended
    }
    
    init(snapshot: FIRDataSnapshot) {
        _orgKey = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        _isUser = snapshotValue["isUser"] as! Bool
        _orgName = snapshotValue["orgName"] as! String
        _emailAddress = snapshotValue["emailAddress"] as! String
        _location = snapshotValue["location"] as! String
        _category = snapshotValue["category"] as! String
        _userViewCount = snapshotValue["userViewCount"] as! Int
        _userEventsAttended = snapshotValue["userEventsAttended"] as! Int
        orgRef = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "orgKey": _orgKey,
            "isUser": _isUser,
            "orgName": _orgName,
            "emailAddress": _emailAddress,
            "location": _location,
            "category": _category,
            "userViewCount": _userViewCount,
            "userEventsAttended": _userEventsAttended
        ]
    }
}

