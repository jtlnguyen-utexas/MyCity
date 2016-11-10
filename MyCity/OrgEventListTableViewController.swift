//
//  OrgEventListTableViewController.swift
//  MyCity
//
//  Created by Hamza Muhammad on 11/8/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class OrgEventListTableViewController: UITableViewController {
    
    var currentOrg: Org?
    var events = [Event]()
    var timer = Timer()
    var orgEventListViewController: OrgEventListViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // we retrieve all of the org data (their events)
        
        print("events length: \(events.count)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(OrgEventListTableViewController.updateTable), userInfo: nil, repeats: true)
    }
    
    func updateTable() {
        // here, we update the
        print("events before call: \(events.count)")
        var tempEvents = [Event]()
        
        var filter: String!
        if orgEventListViewController?.filterChoice.selectedSegmentIndex == 0 {
            filter = "Previous"
        }
        else if orgEventListViewController?.filterChoice.selectedSegmentIndex == 1 {
            filter = "Ongoing"
        }
        else {
            filter = "Future"
        }
        
        let ref = FIRDatabase.database().reference()
        ref.observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                print(rest.value)
                let value = rest.value as? NSDictionary
                
                // see if this object has this field (if so, its an event)
                if let email = value?["orgEmail"] as? String {
                    // here, we have to filter
                    
                    let date = NSDate()
                    let unitFlags = Set<Calendar.Component>([.day, .month, .year, .hour])
                    let components = NSCalendar.current.dateComponents(unitFlags, from: date as Date)
                    
                    let month = Int(components.month!)
                    let day = Int(components.day!)
                    let hour = Int(components.hour!)
                    
                    let startEvent : String = value?["eventStart"] as! String
                    let startDate : [String] = startEvent.components(separatedBy: " ")
                    
                    // And then to access the individual words:
                    let startEventMonth = Int(startDate[0])!
                    let startEventDay = Int(startDate[1])!
                    var startEventHour: Int = Int(startDate[2])!
                    if startDate[3] == "PM" {
                        startEventHour += 12
                    }
                    
                    let endEvent : String = value?["eventStart"] as! String
                    let endDate : [String] = endEvent.components(separatedBy: " ")
                    
                    // And then to access the individual words:
                    let endEventMonth = Int(endDate[0])!
                    let endEventDay = Int(endDate[1])!
                    var endEventHour = Int(endDate[2])!
                    if endDate[3] == "PM" {
                        endEventHour += 12
                    }
                    
                    self.events.removeAll()
                    
                    var getEvent: Bool = false
                    
                    if filter == "Previous" {
                        if month > endEventMonth {
                            getEvent = true
                        }
                        else if month == endEventMonth && day > endEventDay {
                            getEvent = true
                        }
                        else if month == endEventMonth && day == endEventDay && hour > endEventHour {
                            getEvent = true
                        }
                    }
                    else if filter == "Future" {
                        if month < startEventMonth {
                            getEvent = true
                        }
                        else if month == startEventMonth && day < startEventDay {
                            getEvent = true
                        }
                        else if month == startEventMonth && day == startEventDay && hour < startEventHour {
                            getEvent = true
                        }
                    }
                    else if filter == "Ongoing" {
                        
                        var isPrev: Bool = false
                        if month > endEventMonth {
                            isPrev = true
                        }
                        else if month == endEventMonth && day > endEventDay {
                            isPrev = true
                        }
                        else if month == endEventMonth && day == endEventDay && hour > endEventHour {
                            isPrev = true
                        }
                        
                        var isFuture: Bool = false
                        if month < startEventMonth {
                            isFuture = true
                        }
                        else if month == startEventMonth && day < startEventDay {
                            isFuture = true
                        }
                        else if month == startEventMonth && day == startEventDay && hour < startEventHour {
                            isFuture = true
                        }
                        
                        if isPrev == false && isFuture == false {
                            getEvent = true
                        }
                    }
                    
                    if email == self.currentOrg?.emailAddress && getEvent == true {
                        // add event if its ours
                        let event = Event(eventKey: value?["eventKey"] as! String, eventName: value?["eventName"] as! String, eventStart: value?["eventStart"] as! String, eventEnd: value?["eventEnd"] as! String, eventDescription: value?["eventDescription"] as! String, eventAddress: value?["eventAddress"] as! String, eventTags: value?["eventTags"] as! [String], eventCheckIns: value?["eventCheckIns"] as! Int, eventRSVPs: value?["eventRSVPs"] as! Int, orgEmail: email)
                        print("i am dude")
                        tempEvents.append(event);
                        self.events.removeAll()
                        for event in tempEvents {
                            self.events.append(event)
                        }
                        print("TEMPevents within call: \(tempEvents.count)")
                    }
                }
            }
        })
        
        print("events after call: \(events.count)")

        self.tableView.reloadData()
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
        
        print("wtf is this")
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)

        // Configure the cell...
        let item = events[indexPath.row]
        
        print("we get here with \(item)")
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
