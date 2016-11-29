//
//  EventMapViewController.swift
//  MyCity
//
//  Created by Alec Griffin on 11/8/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class EventMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    
    @IBOutlet weak var mapView: MKMapView!

    let locationManager = CLLocationManager()
    
    let regionRadius: CLLocationDistance = 1000
    var initialLocationSet = false
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad() - Map")
        // Core Location Data
        if CLLocationManager.locationServicesEnabled() {
            print("Location Services Enabled!")
            
            // Ask for authorization to access the user’s location when the app is in use
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            
            // Set the desired accuracy of CLLocationManager’s location output
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // Start getting location
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        } else {
            print("Location Services Disabled!")
        }
        
        self.mapView.delegate = self
        self.mapView.mapType = MKMapType.standard
//        print("ViewDidLoad() - Map")
        updateEventList()
//        placePins()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Centers Map on a CLLocation
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // Uses Users current Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let currentLong = userLocation.coordinate.longitude;
        let currentLat = userLocation.coordinate.latitude;
        
        // Center Map Location upon current Location only once
        if !initialLocationSet {
            centerMapOnLocation(CLLocation(latitude: currentLat, longitude: currentLong) )
            initialLocationSet = true
        }
    }
    
    func updateEventList() {
        // updateEventList()
        var tempEvents = [Event]()
        
        let ref = FIRDatabase.database().reference()
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                print("Cycle Through Events!")
                let value = rest.value as? NSDictionary
                
                // see if this object has this field (if so, its an event)
                if let email = value?["orgEmail"] as? String {
                print("Event Object!")
                    // now, we have an event, so:
                        
                        // have to add all ongoing events first
                        let date = Date()
                    
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MM/dd/yy, hh:mm aa"
                    
//                        let startEvent : String = value?["eventStart"] as! String
//                        let startDate = formatter.date(from: startEvent)
                    
                        let endEvent : String = value?["eventEnd"] as! String
                        let endDate = formatter.date(from: endEvent)
                    
                        // Only Show Events that are currently happening or that are going to happen at some point in the future
                        if endDate! >= date {
                            print("Valid Event Date!")
                            // is an ongoing event, so add it:
                            let event = Event(eventKey: value?["eventKey"] as! String, eventName: value?["eventName"] as! String, eventStart: value?["eventStart"] as! String, eventEnd: value?["eventEnd"] as! String, eventDescription: value?["eventDescription"] as! String, eventAddress: value?["eventAddress"] as! String, eventTags: value?["eventTags"] as! String, eventCheckIns: value?["eventCheckIns"] as! Int, eventRSVPs: value?["eventRSVPs"] as! Int, orgEmail: email, latitude: value?["latitude"] as! String, longitude: value?["longitude"] as! String, eventHash: value?["eventHash"] as! String)
                            tempEvents.append(event)
                            print("Event Added")
                            self.events.removeAll()
                            for event in tempEvents {
                                print("Add Event Date!")
                                self.events.append(event)
                            }
                        }
                
                    
                }
                self.placePins()
            }
        })
    }
    
    func placePins(){
        print("placePins()")
        print("Number of Events: \(events.count)")
        for event in events{
            print("placePins()")
            print("latitude: \(event.latitude)")
            print("Longitude: \(event.longitude)")
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(event.latitude)!, longitude: Double(event.longitude)!)
            annotation.title = event.eventName
            annotation.subtitle = "\(event.eventStart) - \(event.eventEnd)"
            mapView.addAnnotation(annotation)
        }
    }
}
