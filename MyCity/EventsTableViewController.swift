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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        eventListViewController?.filterControl.addTarget(self, action: #selector(self.segmentedControllerChanged), for: .allEvents)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchOutsideSearchBar))
        self.tableView.addGestureRecognizer(tap)
        
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
    
    func tappedTableView() {
        eventListViewController?.searchBar.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(OrgEventListTableViewController.updateTable), userInfo: nil, repeats: true)
        // Start getting location
        locationManager.startUpdatingLocation()
    }
    
    func segmentedControllerChanged() {
        events.self.removeAll()
    }
    
    func updateTable() {
        // here, we update the
        var tempEvents = [Event]()
        
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
        
        let ref = FIRDatabase.database().reference()
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                let value = rest.value as? NSDictionary
                
                // see if this object has this field (if so, its an event)
                if let email = value?["orgEmail"] as? String {
                    
                    // now, we have an event, so:
                    
                    if filter == "Time" {
                        // have to add all ongoing events first
                        let date = Date()
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MM/dd/yy, hh:mm aa"
                        
                        let startEvent : String = value?["eventStart"] as! String
                        let startDate = formatter.date(from: startEvent)
                        
                        let endEvent : String = value?["eventEnd"] as! String
                        let endDate = formatter.date(from: endEvent)
                        
                        if endDate! >= date && startDate! <= date {
                            // is an ongoing event, so add it:
                            let event = Event(eventKey: value?["eventKey"] as! String, eventName: value?["eventName"] as! String, eventStart: value?["eventStart"] as! String, eventEnd: value?["eventEnd"] as! String, eventDescription: value?["eventDescription"] as! String, eventAddress: value?["eventAddress"] as! String, eventTags: value?["eventTags"] as! String, eventCheckIns: value?["eventCheckIns"] as! Int, eventRSVPs: value?["eventRSVPs"] as! Int, orgEmail: email, latitude: value?["latitude"] as! String, longitude: value?["longitude"] as! String, eventHash: value?["eventHash"] as! String)
                            tempEvents.append(event)
                            self.events.removeAll()
                            for event in tempEvents {
                                self.events.append(event)
                            }
                        }
                    }
                    else if filter == "Location" {
                        // otherwise, find all events within the range
                        let latitude = Float(value?["latitude"] as! String)
                        let longitude = Float(value?["longitude"] as! String)
                        
                        let radius = self.currentUser?.radius
                        if latitude! + radius! > Float(self.currentLat!) && latitude! - radius! < Float(self.currentLat!) && longitude! + radius! > Float(self.currentLong!) && longitude! - radius! < Float(self.currentLong!) {
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
                        let numPeople = value?["eventCheckIns"] as! Int
                        
                        if numPeople > 0 {
                            let event = Event(eventKey: value?["eventKey"] as! String, eventName: value?["eventName"] as! String, eventStart: value?["eventStart"] as! String, eventEnd: value?["eventEnd"] as! String, eventDescription: value?["eventDescription"] as! String, eventAddress: value?["eventAddress"] as! String, eventTags: value?["eventTags"] as! String, eventCheckIns: value?["eventCheckIns"] as! Int, eventRSVPs: value?["eventRSVPs"] as! Int, orgEmail: email, latitude: value?["latitude"] as! String, longitude: value?["longitude"] as! String, eventHash: value?["eventHash"] as! String)
                            tempEvents.append(event)
                            self.events.removeAll()
                            for event in tempEvents {
                                self.events.append(event)
                            }

                        }
                    }
                    

                }
            }
        })
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func touchOutsideSearchBar() {
        eventListViewController?.searchBar.endEditing(true)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventListViewController?.searchBar.endEditing(true)
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
