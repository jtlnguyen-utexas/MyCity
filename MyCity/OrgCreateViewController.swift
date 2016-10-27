//
//  OrgPreferenceViewController.swift
//  MyCity
//
//  Created by Nelia Perez on 10/25/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

class OrgCreateViewController: UIViewController {
    
    // org object
    var currentOrg: Org?
    
    var orgEmail: String?
    var orgPassword: String?
    
    var category: String = ""
    
    @IBOutlet var orgNameField: UITextField!
    @IBOutlet var orgAddressField: UITextField!
    
    @IBOutlet var nightlifeSwitch: UISwitch!
    @IBOutlet var switchFood: UISwitch!
    @IBOutlet var sportsSwitch: UISwitch!
    @IBOutlet var freeSwitch: UISwitch!
    
    @IBOutlet var alertMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        alertMessageLabel.text = ""
        nightlifeSwitch.setOn(false, animated: true)
        switchFood.setOn(false, animated: true)
        sportsSwitch.setOn(false, animated: true)
        freeSwitch.setOn(false, animated: true)
    }

    @IBAction func nightlifeSwitchChanged(_ sender: AnyObject) {
        switchFood.setOn(false, animated: true)
        sportsSwitch.setOn(false, animated: true)
        freeSwitch.setOn(false, animated: true)
        category = "Nightlife"
    }
    
    @IBAction func foodSwitchChanged(_ sender: AnyObject) {
        nightlifeSwitch.setOn(false, animated: true)
        sportsSwitch.setOn(false, animated: true)
        freeSwitch.setOn(false, animated: true)
        category = "Food"
    }
    
    @IBAction func sportsSwitchChanged(_ sender: AnyObject) {
        nightlifeSwitch.setOn(false, animated: true)
        switchFood.setOn(false, animated: true)
        freeSwitch.setOn(false, animated: true)
        category = "Sports"
    }
    
    @IBAction func freeSwitchChanged(_ sender: AnyObject) {
        nightlifeSwitch.setOn(false, animated: true)
        switchFood.setOn(false, animated: true)
        sportsSwitch.setOn(false, animated: true)
        category = "Free!"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createNewOrg(email: String, password: String) {
        if email != "" && password != "" {
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                
                if error == nil {
                    print("Success - Account Created!")
                    // make new user and add an empty object to database
                    let newOrg = Org(orgKey: self.orgEmail!, orgName: self.orgNameField.text!, emailAddress: self.orgEmail!, location: self.orgAddressField.text!, category: self.category, userViewCount: 0, userEventsAttended: 0)
                    self.currentOrg = newOrg
                    let newString = (email as NSString).replacingOccurrences(of: ".", with: "@")
                    let userRef = FIRDatabase.database().reference(withPath: newString)
                    userRef.setValue(newOrg.toAnyObject())
                    
                    // make a separate one for preferences (for faster loading)
                    let prefRef = FIRDatabase.database().reference(withPath: "\(newString)pref")
                    prefRef.setValue([
                        "orgName": self.orgNameField.text!,
                        "location": self.orgAddressField.text!,
                        "category": self.category,
                        "userViewCount": 0,
                        "userEventsAttended": 0
                        ])
                    
                    self.performSegue(withIdentifier: "OrgSuccessRegistrationSegue", sender: nil)
                }
                else {
                    print("Failure - Account Creation Failed!")
                    print(error)
                    self.alertMessageLabel.text = "Email already in use!"
                }
            }
        }
    }


    // MARK: Action
    
    @IBAction func nextBtnClicked(_ sender: AnyObject) {
        createNewOrg(email: orgEmail!, password: orgPassword!)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // upon successful registration, send user obj to event list
        if segue.identifier == "OrgSuccessRegistrationSegue" {
            let tabBarController = segue.destination as! UITabBarController
            let orgSettingsViewController = tabBarController.viewControllers?[2] as! OrgSettingsViewController
            orgSettingsViewController.currentOrg = self.currentOrg
        }
    }
}
