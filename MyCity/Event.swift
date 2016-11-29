//
//  Event.swift
//  MyCity
//
//  Created by Alec Griffin on 10/16/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MapKit
import CoreLocation
import AddressBookUI

class Event: NSObject {
    
    private var eventRef: FIRDatabaseReference?
    
    private var _eventKey: String!
    private var _eventName: String!
    //private var _eventImage: UIImage!
    private var _eventStart: String!
    private var _eventEnd: String!
    private var _eventDescription: String!
    private var _eventAddress: String!
    private var _eventTags: String!
    private var _eventCheckIns: Int!
    private var _eventRSVPs: Int!
    private var _latitude: String!
    private var _longitude: String!
    private var _orgEmail: String!
    private var _eventHash: String!
    
    var eventKey: String {
        return _eventKey
    }
    
    var eventName: String {
        return _eventName
    }
    
    //    var eventImage: UIImage {
    //        return _eventImage
    //    }
    
    var eventStart: String {
        return _eventStart
    }
    
    var eventEnd: String {
        return _eventEnd
    }
    
    var eventDescription: String {
        return _eventDescription
    }
    
    var eventAddress: String {
        return _eventAddress
    }
    
    var eventTags: String {
        return _eventTags
    }
    
    var eventCheckIns: Int {
        return _eventCheckIns
    }
    
    var eventRSVPs: Int {
        return _eventRSVPs
    }
    
    var latitude: String {
        return _latitude
    }
    
    var longitude: String {
        return _longitude
    }
    
    var orgEmail: String {
        return _orgEmail
    }
    
    var eventHash: String {
        return _eventHash
    }
    
    init(eventKey: String, eventName: String, eventStart: String, eventEnd: String, eventDescription: String, eventAddress: String, eventTags: String, eventCheckIns: Int, eventRSVPs: Int, orgEmail: String, latitude: String, longitude: String, eventHash: String){
        
        self._eventKey = eventKey
        self._eventName = eventName
        //self._eventImage = eventImage
        self._eventStart = eventStart
        self._eventEnd = eventEnd
        self._eventDescription = eventDescription
        self._eventAddress = eventAddress
        self._eventTags = eventTags
        self._eventCheckIns = eventCheckIns
        self._eventRSVPs = eventRSVPs
        self._orgEmail = orgEmail
        if latitude != "" && longitude != "" && eventHash != "" {
            self._latitude = latitude
            self._longitude = longitude
            self._eventHash = eventHash
        }
    }
    
    func forwardGeocoding(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                self._latitude = "\(coordinate!.latitude)"
                self._longitude = "\(coordinate!.longitude)"
                
                let hash = ("\(NSDate().timeIntervalSince1970)" as NSString).replacingOccurrences(of: ".", with: "@")
                let email = (self.orgEmail as NSString).replacingOccurrences(of: ".", with: "@")
                let newString = "e \(email) \(hash)"
                
                self._eventHash = hash

                let orgRef = FIRDatabase.database().reference(withPath: newString)
                orgRef.setValue(self.toAnyObject())
                
//                if (placemark?.areasOfInterest?.count)! > 0 {
//                    let areaOfInterest = placemark!.areasOfInterest![0]
//                    print(areaOfInterest)
//                } else {
//                    print("No area of interest found.")
//                }
            }
        })
    }
    
    init(snapshot: FIRDataSnapshot) {
        _eventKey = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        _eventName = snapshotValue["eventName"] as! String
        _eventStart = snapshotValue["eventStart"] as! String
        _eventEnd = snapshotValue["eventEnd"] as! String
        _eventDescription = snapshotValue["eventDescription"] as! String
        _eventAddress = snapshotValue["eventAddress"] as! String
        _eventTags = snapshotValue["eventTags"] as! String
        _eventCheckIns = snapshotValue["eventCheckIns"] as! Int
        _eventRSVPs = snapshotValue["eventRSVPs"] as! Int
        _latitude = snapshotValue["latitude"] as! String
        _longitude = snapshotValue["longitude"] as! String
        _orgEmail = snapshotValue["orgEmail"] as! String
        _eventHash = snapshotValue["eventHash"] as! String
        eventRef = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "eventKey": _eventKey,
            "eventName": _eventName,
            "eventStart": _eventStart,
            "eventEnd": _eventEnd,
            "eventDescription": _eventDescription,
            "eventAddress": _eventAddress,
            "eventTags": _eventTags,
            "eventCheckIns": _eventCheckIns,
            "eventRSVPs": _eventRSVPs,
            "latitude": _latitude,
            "longitude": _longitude,
            "orgEmail": _orgEmail,
            "eventHash": _eventHash
        ]
    }
}
