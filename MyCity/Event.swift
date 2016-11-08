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

class Event{

    private var _eventKey: String!
    private var _eventName: String!
    private var _eventImage: UIImage!
    private var _eventStart: Date!
    private var _eventEnd: Date!
    private var _eventDescription: String!
    private var _eventAddress: String!
    private var _eventTags: [String]!
    private var _eventCheckIns: Int!
    private var _eventRSVPs: Int!
    private var _eventOrgKey: String!
    
    init(eventKey: String, eventName: String, eventImage: UIImage, eventStart: Date, eventEnd: Date, eventDescription: String, eventAddress: String!, eventTags: [String], eventCheckIns: Int, eventRSVPs: Int, eventOrgKey: String){
        
        self._eventKey = eventKey
        self._eventName = eventName
        self._eventImage = eventImage
        self._eventStart = eventStart
        self._eventEnd = eventEnd
        self._eventDescription = eventDescription
        self._eventAddress = eventAddress
        self._eventTags = eventTags
        self._eventCheckIns = eventCheckIns
        self._eventRSVPs = eventRSVPs
        self._eventOrgKey = eventOrgKey
        
    }
    
//    init(snapshot: FIRDataSnapshot) {
//     
//    }
    
    func toAnyObject() -> Any {
        return [
            "eventKey": _eventKey,
            "eventName": _eventName,
            "eventImage": _eventImage,
            "eventStart": _eventStart,
            "eventEnd": _eventEnd,
            "eventDescription": _eventDescription,
            "eventAddress": _eventAddress,
            "eventTags": _eventTags,
            "eventCheckIns": _eventCheckIns,
            "eventRSVPs": _eventRSVPs,
            "eventOrgKey": _eventOrgKey
        ]
    }
}
