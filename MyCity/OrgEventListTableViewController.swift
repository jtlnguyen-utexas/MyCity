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
        
        orgEventListViewController?.filterChoice.addTarget(self, action: #selector(self.segmentedControllerChanged), for: .allEvents)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedTableView))
        self.tableView.addGestureRecognizer(tap)
    }
    
    func tappedTableView(sender:UITapGestureRecognizer) {
        orgEventListViewController?.seachBar.endEditing(true)
        
        sender.cancelsTouchesInView = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(OrgEventListTableViewController.updateTable), userInfo: nil, repeats: true)
    }
    
    func segmentedControllerChanged() {
        events.self.removeAll()
    }
    
    func updateTable() {
        // here, we update the
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
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                let value = rest.value as? NSDictionary
                
                // see if this object has this field (if so, its an event)
                if let email = value?["orgEmail"] as? String {
                    
                    if email == self.currentOrg?.emailAddress {
                        // here, we have to filter
                        
                        let date = Date()
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "MM/dd/yy, hh:mm aa"
                        
                        let startEvent : String = value?["eventStart"] as! String
                        let startDate = formatter.date(from: startEvent)

                        let endEvent : String = value?["eventEnd"] as! String
                        let endDate = formatter.date(from: endEvent)
                        
                        var getEvent: Bool = false
                        
                        if filter == "Previous" {
                            if endDate! < date {
                                getEvent = true
                            }
                        }
                            
                        else if filter == "Future" {
                            if startDate! > date {
                                getEvent = true
                            }
                        }
                        else if filter == "Ongoing" {
                            if endDate! >= date && startDate! <= date {
                                getEvent = true
                            }
                        }
                    
                        if email == self.currentOrg?.emailAddress && getEvent == true {
                            // add event if its ours
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.events.count
    }
    
    func touchOutsideSearchBar() {
        orgEventListViewController?.seachBar.endEditing(true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)

        // Configure the cell...
        let item = events[indexPath.row]
                
        // Configure the cell with the Item
        cell.textLabel?.text = item.eventName
        cell.detailTextLabel?.text = "\(item.eventCheckIns)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        orgEventListViewController?.seachBar.endEditing(true)
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
        if segue.identifier == "showEventSegue" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let orgEventViewController = segue.destination as! OrgEventViewController
                orgEventViewController.currEvent = events[row]
                orgEventViewController.currentOrg = self.currentOrg
            }
        }
    }

}
