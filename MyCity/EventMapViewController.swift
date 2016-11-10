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

class EventMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    
    @IBOutlet weak var mapView: MKMapView!

    let locationManager = CLLocationManager()
    
    let regionRadius: CLLocationDistance = 1000
    var initialLocationSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}
