//
//  SettingsTableViewController.swift
//  MyCity
//
//  Created by Nelia Perez on 11/27/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

class SettingsTableViewController: UITableViewController {

    var settingsViewController: SettingsViewController?
    var currentUser: User?
    
    var categoriesArr: [String]?
    var categoriesDict: [String:Bool] = [:]
    
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.layer.cornerRadius = 10
        self.tableView.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let newString = ((currentUser?.emailAddress)! as NSString).replacingOccurrences(of: ".", with: "@")
        
        // get a firebase snapchat
        self.ref.child("\(newString)pref").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user values
            let value = snapshot.value as? [String: Any]
            
            self.categoriesDict["Nightlife"] = (value?["nightlife"] as! Bool)
            self.categoriesDict["Sports"] = (value?["sports"] as! Bool)
            self.categoriesDict["Food"] = (value?["food"] as! Bool)
            self.categoriesDict["Free"] = (value?["free"] as! Bool)
            
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categoriesDict["Nightlife"] = false
        categoriesDict["Sports"] = false
        categoriesDict["Food"] = false
        categoriesDict["Free"] = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changedSwitchValue(category: String, value: Bool) {
        categoriesDict[category] = value
        self.settingsViewController?.categoriesDict = self.categoriesDict
        for (key, value) in categoriesDict {
            print("\(key) = \(value)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (categoriesArr?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
        
        // Configure the cell...
        cell.categoryLabel.text = categoriesArr?[indexPath.row]
        cell.categorySwitch.setOn((categoriesDict[cell.categoryLabel.text!])!, animated: false)
        cell.delegate = self
        
        
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
