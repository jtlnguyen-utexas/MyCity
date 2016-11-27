//
//  OrgSettingsViewController.swift
//  MyCity
//
//  Created by Nelia Perez on 10/26/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

class OrgSettingsViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    // Organization's data
    var currentOrg: Org?
    var category: String?

    // Text Fields
    @IBOutlet var orgNameField: UITextField!
    @IBOutlet var orgAddressField: UITextField!
    
    // Switches
    @IBOutlet var nightlifeSwitch: UISwitch!
    @IBOutlet var sportsSwitch: UISwitch!
    @IBOutlet var foodSwitch: UISwitch!
    @IBOutlet var freeSwitch: UISwitch!
    
    // Labels
    @IBOutlet var viewCountLabel: UILabel!
    @IBOutlet var eventCountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        orgNameField.delegate = self
        orgAddressField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Used to dismiss the keyboard upon tapping outside of the keyboard region
    func dismissKeyboard(){
        orgNameField.resignFirstResponder()
        orgAddressField.resignFirstResponder()
    }
    
    // Used to dismiss the keyboard upon the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        orgNameField.resignFirstResponder()
        orgAddressField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // here, we have to retrieve the user object
        let ref = FIRDatabase.database().reference()
        
        // have to parse email
        let newString = ((currentOrg?.emailAddress)! as NSString).replacingOccurrences(of: ".", with: "@")
        
        // get a firebase snapchat
        ref.child("\(newString)pref").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user values
            let value = snapshot.value as? NSDictionary
            
            self.nightlifeSwitch.setOn(false, animated: false)
            self.sportsSwitch.setOn(false, animated: false)
            self.foodSwitch.setOn(false, animated: false)
            self.freeSwitch.setOn(false, animated: false)
            
            let retrievedCategory = value?["category"] as! String
            
            if retrievedCategory == "Nightlife" {
                self.nightlifeSwitch.setOn(true, animated: false)
                self.category = "Nightlife"
            }
            else if retrievedCategory == "Sports" {
                self.sportsSwitch.setOn(true, animated: false)
                self.category = "Sports"
            }
            else if retrievedCategory == "Food" {
                self.foodSwitch.setOn(true, animated: false)
                self.category = "Food"
            }
            else if retrievedCategory == "Free!" {
                self.freeSwitch.setOn(true, animated: false)
                self.category = "Free!"
            }
            else {
                self.category = ""
            }
            
            self.orgNameField.text = "\(value?["orgName"] as! String)"
            self.orgAddressField.text = "\(value?["location"] as! String)"
            
            self.viewCountLabel.text = "0"
            self.eventCountLabel.text = "0"
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // we will save the data here
        let prefsRef = FIRDatabase.database().reference()
        let toBePosted : Dictionary<String, Any> = [
            "orgName": self.orgNameField.text!,
            "location": self.orgAddressField.text!,
            "category": self.category! as NSString,
            "free": self.freeSwitch.isOn,
            "userViewCount": 0,
            "numEventsAttended": 0
        ]
        
        let newString = ((currentOrg?.emailAddress)! as NSString).replacingOccurrences(of: ".", with: "@")
        let childUpdates = ["\(newString)pref": toBePosted]
        
        prefsRef.updateChildValues(childUpdates)
    }
    
    // MARK: Actions
    
    @IBAction func nightlifeSwitchPressed(_ sender: AnyObject) {
        foodSwitch.setOn(false, animated: true)
        sportsSwitch.setOn(false, animated: true)
        freeSwitch.setOn(false, animated: true)
        category = "Nightlife"
    }
    
    @IBAction func sportsSwitchPressed(_ sender: AnyObject) {
        nightlifeSwitch.setOn(false, animated: true)
        foodSwitch.setOn(false, animated: true)
        freeSwitch.setOn(false, animated: true)
        category = "Sports"
    }
    
    @IBAction func foodSwitchPressed(_ sender: AnyObject) {
        nightlifeSwitch.setOn(false, animated: true)
        sportsSwitch.setOn(false, animated: true)
        freeSwitch.setOn(false, animated: true)
        category = "Food"
    }
    
    @IBAction func freeSwitchPressed(_ sender: AnyObject) {
        nightlifeSwitch.setOn(false, animated: true)
        foodSwitch.setOn(false, animated: true)
        sportsSwitch.setOn(false, animated: true)
        category = "Free!"
    }

    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        viewWillDisappear(true)
        try! FIRAuth.auth()!.signOut()
        performSegue(withIdentifier: "BackLoginSegue", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
