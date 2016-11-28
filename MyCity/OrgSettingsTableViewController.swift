//
//  OrgSettingsTableViewController.swift
//  MyCity
//
//  Created by Nelia Perez on 11/28/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

class OrgSettingsTableViewController: UITableViewController, OrgSettingsTableViewCellDelegate {

    var orgSettingsViewController: OrgSettingsViewController?
    var currentOrg: Org?
    var category: String?
    
    let categoriesArr = ["Nightlife", "Sports", "Food", "Free"]
    
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        print("Inside OrgSettings Table. Value of category is \(category)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let newString = ((currentOrg?.emailAddress)! as NSString).replacingOccurrences(of: ".", with: "@")
        
        // get a firebase snapchat
        self.ref.child("\(newString)pref").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user values
            let value = snapshot.value as? [String: Any]

            self.category = (value?["category"] as! String)
            
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changedSwitchValue(category: String, value: Bool) {
        self.category = category
        self.orgSettingsViewController?.category = self.category
        for row in 0..<categoriesArr.count {
            var cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! OrgSettingsTableViewCell
            cell.categorySwitch.setOn(false, animated: false)
        }
        var cell = tableView.cellForRow(at: IndexPath(row: categoriesArr.index(of: category)!, section: 0)) as! OrgSettingsTableViewCell
        cell.categorySwitch.setOn(value, animated: false)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoriesArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrgSettingsCell", for: indexPath) as! OrgSettingsTableViewCell

        // Configure the cell...
        cell.delegate = self
        cell.categoryLabel.text = categoriesArr[indexPath.row]
        if category == cell.categoryLabel.text {
            cell.categorySwitch.setOn(true, animated: false)
        }
        else {
            cell.categorySwitch.setOn(false, animated: false)
        }
        
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
