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

class User: NSObject {
    
    private var userRef: FIRDatabaseReference?
    
    private var _isUser: Bool = true
    private var _userKey: String!
    private var _firstName: String!
    private var _lastName: String!
    private var _emailAddress: String!
    private var _location: String!
    private var _nightlife: Bool!
    private var _sports: Bool!
    private var _food: Bool!
    private var _free: Bool!
    private var _radius: Float!
    private var _checkInRatio: String!
    private var _numEventsAttended: Int!
    
    var isUser: Bool {
        return _isUser
    }
    
    var userKey: String {
        return _userKey
    }
    
    var firstName: String {
        return _firstName
    }
    
    var lastName: String {
        return _lastName
    }
    
    var emailAddress: String {
        return _emailAddress
    }
    
    var location: String {
        return _location
    }
    
    var nightlife: Bool {
        return _nightlife
    }
    
    var sports: Bool {
        return _sports
    }
    
    var food: Bool {
        return _food
    }
    
    var free: Bool {
        return _free
    }
    
    var radius: Float {
        return _radius
    }
    
    var checkInRatio: String! {
        return _checkInRatio
    }
    
    var numEventsAttended: Int! {
        return _numEventsAttended
    }
    
    // Initialize the new User
    
    init(userKey: String, firstName: String, lastName: String, emailAddress: String, location: String, nightlife: Bool, sports: Bool, food: Bool, free: Bool, radius: Float, checkInRatio: String, numEventsAttended: Int) {
        
        self._userKey = userKey
        self._firstName = firstName
        self._lastName = lastName
        self._emailAddress = emailAddress
        self._location = location
        self._nightlife = nightlife
        self._sports = sports
        self._food = food
        self._free = free
        self._radius = radius
        self._checkInRatio = checkInRatio
        self._numEventsAttended = numEventsAttended
    }
    
    init(snapshot: FIRDataSnapshot) {
        _userKey = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        _isUser = snapshotValue["isUser"] as! Bool
        _firstName = snapshotValue["firstName"] as! String
        _lastName = snapshotValue["lastName"] as! String
        _emailAddress = snapshotValue["emailAddress"] as! String
        _location = snapshotValue["location"] as! String
        _nightlife = snapshotValue["nightlife"] as! Bool
        _sports = snapshotValue["sports"] as! Bool
        _food = snapshotValue["food"] as! Bool
        _free = snapshotValue["free"] as! Bool
        _radius = snapshotValue["radius"] as! Float
        _checkInRatio = snapshotValue["checkInRatio"] as! String
        _numEventsAttended = snapshotValue["numEventsAttended"] as! Int
        userRef = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "isUser": _isUser,
            "userKey": _userKey,
            "firstName": _firstName,
            "lastName": _lastName,
            "emailAddress": _emailAddress,
            "location": _location,
            "nightlife": _nightlife,
            "sports": _sports,
            "food": _food,
            "free": _free,
            "radius": _radius,
            "checkInRatio": _checkInRatio,
            "numEventsAttended": _numEventsAttended
        ]
    }
}

