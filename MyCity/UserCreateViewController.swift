//
//  UserCreateViewController.swift
//  MyCity
//
//  Created by Nelia Perez on 10/25/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

class UserCreateViewController: UIViewController {
        
    // put email/password info
    var userEmail: String?
    var userPassword: String?
    
    // user object we will pass down
    var currentUser: User?
    
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    
    @IBOutlet var nightlifeSwitch: UISwitch!
    @IBOutlet var foodSwitch: UISwitch!
    @IBOutlet var sportsSwitch: UISwitch!
    @IBOutlet var freeSwitch: UISwitch!
    
    @IBOutlet var alertLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        alertLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createNewUser(email: String, password: String) {
        if email != "" && password != "" {
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                
                if error == nil {
                    print("Success - Account Created!")
                    // make new user and add an empty object to database
                    let newUser = User(userKey: email, firstName: self.firstNameField.text!, lastName: self.lastNameField.text!, emailAddress: email, location: "", nightlife: self.nightlifeSwitch.isOn, sports: self.sportsSwitch.isOn, food: self.foodSwitch.isOn, free: self.freeSwitch.isOn, radius: 0.0, checkInRatio: "", numEventsAttended: 0)
                    self.currentUser = newUser
                    let newString = (email as NSString).replacingOccurrences(of: ".", with: "@")
                    let userRef = FIRDatabase.database().reference(withPath: newString)
                    userRef.setValue(newUser.toAnyObject())
                    self.performSegue(withIdentifier: "UserSuccessRegistrationSegue", sender: nil)
                }
                else {
                    print("Failure - Account Creation Failed!")
                    print(error)
                    self.alertLabel.text = "Email already in use!"
                }
            }
        }
    }
    
    @IBAction func nextBtnClicked(_ sender: AnyObject) {
        // HERE is where we actually make the account with the given info
        createNewUser(email: userEmail!, password: userPassword!)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // upon successful registration, send user obj to event list
        if segue.identifier == "UserSuccessRegistrationSegue" {
            let tabBarController = segue.destination as! UITabBarController
            let settingsViewController = tabBarController.viewControllers?[2] as! SettingsViewController
            settingsViewController.currentUser = self.currentUser
        }
    }
}
