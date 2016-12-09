//
//  EventsTableViewController.swift
//  MyCity
//
//  Created by Hamza Muhammad on 10/26/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class EventsTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var currentLong: CLLocationDegrees?
    var currentLat: CLLocationDegrees?
    
    var currentUser: User?
    var events = [Event]()
    var timer = Timer()
    var eventListViewController: EventListViewController?
    
    var nightlife: Bool = false
    var sports: Bool = false
    var food: Bool = false
    var free: Bool = false
    
    var radius = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        eventListViewController?.filterControl.addTarget(self, action: #selector(self.segmentedControllerChanged), for: .allEvents)
        
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
        } else {
            print("Location Services Disabled!")
        }
    }
    
    // Uses Users current Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        currentLong = userLocation.coordinate.longitude;
        currentLat = userLocation.coordinate.latitude;
    }
    

    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(OrgEventListTableViewController.updateTable), userInfo: nil, repeats: true)
        // Start getting location
        locationManager.startUpdatingLocation()
        
        let ref = FIRDatabase.database().reference()
        
        // have to parse email
        let newString = ((currentUser?.emailAddress)! as NSString).replacingOccurrences(of: ".", with: "@")
        
        // get a firebase snapchat
        ref.child("\(newString)pref").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user values
            let value = snapshot.value as? NSDictionary
            
            let strRad = value?["radius"] as! Float
            self.radius = Int(strRad)
            print("I've completed the block")
            
            self.updateTable()
        })
    }
    
    func segmentedControllerChanged() {
        events.self.removeAll()
    }
    
    func getUserPreferences() {
        // here, we have to retrieve the user object
        let ref = FIRDatabase.database().reference()
        
        // have to parse email
        let newString = ((currentUser?.emailAddress)! as NSString).replacingOccurrences(of: ".", with: "@")
        
        // get a firebase snapchat
        ref.child("\(newString)pref").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user values
            let value = snapshot.value as? NSDictionary
            
            self.nightlife = (value?["nightlife"] as! Bool)
            self.sports = (value?["sports"] as! Bool)
            self.food = (value?["food"] as! Bool)
            self.free = (value?["free"] as! Bool)
            
//            self.radiusSlider.value = value?["radius"] as! Float
//            self.radiusLabel.text = "\(value?["radius"] as! Float)"
//            
//            self.checkInLabel.text = "\(value?["checkInRatio"] as! String)"
//            self.eventsAttendedLabel.text = "\(value?["numEventsAttended"] as! Int)"
        })
    }
    
    func updateTable() {
        // here, we update the
        var tempEvents = [Event]()
        
        // now, we have to take into account the user's preferences as well
        getUserPreferences()
        
        var filter: String!
        if eventListViewController?.filterControl.selectedSegmentIndex == 0 {
            filter = "Time"
        }
        else if eventListViewController?.filterControl.selectedSegmentIndex == 1 {
            filter = "Location"
        }
        else {
            filter = "Popularity"
        }
        
        var currentLocation = CLLocation(latitude: self.currentLat!, longitude: self.currentLong!)
        
        let ref = FIRDatabase.database().reference()
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                let value = rest.value as? NSDictionary
                
                // see if this object has this field (if so, its an event)
                if let email = value?["orgEmail"] as? String {
                    
                    // now, we have an event, so:
                    
                    var strEventLatitude = value?["latitude"] as! String
                    var strEventLongitude = value?["longitude"] as! String
                    
                    var eventLatitude = Double(strEventLatitude)
                    var eventLongitude = Double(strEventLongitude)
                    
                    
                    var coordinate₁ = CLLocation(latitude: eventLatitude!, longitude: eventLongitude!)
                    
                    let distanceInMiles = Int(currentLocation.distance(from: coordinate₁) / 1609)
                    
                    if distanceInMiles <= self.radius {
                    
                    // Get Event Date
                    let date = Date()
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MM/dd/yy, hh:mm aa"
                    
                    let endEvent : String = value?["eventEnd"] as! String
                    let endDate = formatter.date(from: endEvent)
                    
                    let eventTag: String = value?["eventTags"] as! String
                    
                    // if this event does not match to any of our preferences
                    if ((self.nightlife && eventTag == "nightlife") || (self.sports && eventTag == "sports") || (self.food && eventTag == "food") || (self.free && eventTag == "free")) {
                    
                    if filter == "Time" {
                        if endDate! >= date {
                            // is an ongoing event, so add it:
                            let event = Event(eventKey: value?["eventKey"] as! String, eventName: value?["eventName"] as! String, eventStart: value?["eventStart"] as! String, eventEnd: value?["eventEnd"] as! String, eventDescription: value?["eventDescription"] as! String, eventAddress: value?["eventAddress"] as! String, eventTags: value?["eventTags"] as! String, eventCheckIns: value?["eventCheckIns"] as! Int, eventRSVPs: value?["eventRSVPs"] as! Int, orgEmail: email, latitude: value?["latitude"] as! String, longitude: value?["longitude"] as! String, eventHash: value?["eventHash"] as! String)
                            tempEvents.append(event)
                            self.events.removeAll()
                            for event in tempEvents {
                                self.events.append(event)
//
                            }
                            // Sort Event List by Start Time
                            self.events.sort(by: self.eventTimeComparator)
                        }
                    }
                    else if filter == "Location" {
                        
                        // otherwise, find all events within the range
                        let latitude = Float(value?["latitude"] as! String)
                        let longitude = Float(value?["longitude"] as! String)
                        
                        let radius = self.currentUser?.radius
//                        if latitude! + radius! > Float(self.currentLat!) && latitude! - radius! < Float(self.currentLat!) && longitude! + radius! > Float(self.currentLong!) && longitude! - radius! < Float(self.currentLong!) {
                        
                        if endDate! >= date{
                            // event falls within our lat/long radius
                            let event = Event(eventKey: value?["eventKey"] as! String, eventName: value?["eventName"] as! String, eventStart: value?["eventStart"] as! String, eventEnd: value?["eventEnd"] as! String, eventDescription: value?["eventDescription"] as! String, eventAddress: value?["eventAddress"] as! String, eventTags: value?["eventTags"] as! String, eventCheckIns: value?["eventCheckIns"] as! Int, eventRSVPs: value?["eventRSVPs"] as! Int, orgEmail: email, latitude: value?["latitude"] as! String, longitude: value?["longitude"] as! String, eventHash: value?["eventHash"] as! String)
                            tempEvents.append(event)
                            self.events.removeAll()
                            for event in tempEvents {
                                self.events.append(event)
                            }
                        }
                    }
                    else {
                        // lastly, filter by popularity (default is any event that has at least 1 person)
                        if endDate! >= date{
                            let event = Event(eventKey: value?["eventKey"] as! String, eventName: value?["eventName"] as! String, eventStart: value?["eventStart"] as! String, eventEnd: value?["eventEnd"] as! String, eventDescription: value?["eventDescription"] as! String, eventAddress: value?["eventAddress"] as! String, eventTags: value?["eventTags"] as! String, eventCheckIns: value?["eventCheckIns"] as! Int, eventRSVPs: value?["eventRSVPs"] as! Int, orgEmail: email, latitude: value?["latitude"] as! String, longitude: value?["longitude"] as! String, eventHash: value?["eventHash"] as! String)
                            tempEvents.append(event)
                            self.events.removeAll()
                            for event in tempEvents {
                                self.events.append(event)
                            }
                            // Sort Event List by the number of people attending
                            self.events.sort(by: self.eventPopularityComparator)
                        }
                    }
                }
                }
                }
            }
        })
        
        self.tableView.reloadData()
    }
    
//    Sort Event List by distance from the user Time
//    func eventLocationComparator(event1: Event, event2: Event) -> Bool{
//        return event1.
//    }
    
    // Sort Event List by the number of people attending
    func eventPopularityComparator(event1: Event, event2: Event) -> Bool{
        return event1.eventCheckIns > event2.eventCheckIns
    }
    
    // Sort Event List by Start Time
    func eventTimeComparator(event1: Event, event2: Event) -> Bool{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy, hh:mm aa"
        
        let startDate1 = formatter.date(from: event1.eventStart)
        let startDate2 = formatter.date(from: event2.eventStart)
        
        return startDate1! < startDate2!
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userEventCell", for: indexPath)
        
        // Configure the cell...
        let item = events[indexPath.row]
        
        // Configure the cell with the Item
        cell.textLabel?.text = item.eventName
        cell.detailTextLabel?.text = "\(item.eventCheckIns)"
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showUserEventSegue" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let eventViewController = segue.destination as! EventViewController
                eventViewController.currEvent = events[row]
                eventViewController.currentUser = self.currentUser
            }
        }
    }
}
