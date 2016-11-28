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

class UserCreateViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    // Objects used to store User into Firebase
    var userEmail: String?
    var userPassword: String?
    var currentUser: User?
    
    let categoriesArr = ["Nightlife", "Sports", "Food", "Free"]
    var categoriesDict: [String:Bool] = ["Nightlife":false, "Sports":false, "Food":false, "Free":false]
    
    // Fields
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    
    // Labels
    @IBOutlet var alertLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        alertLabel.text = ""
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    // Used to dismiss the keyboard upon tapping outside of the keyboard region
    func dismissKeyboard(){
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
    }
    
    // Used to dismiss the keyboard upon the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        return true
    }

    func createNewUser(email: String, password: String) {
        if email != "" && password != "" {
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                
                if error == nil {
                    print("Success - Account Created!")
                    // make new user and add an empty object to database
                    let newUser = User(userKey: email, firstName: self.firstNameField.text!, lastName: self.lastNameField.text!, emailAddress: email, location: "", nightlife: self.categoriesDict["Nightlife"]!, sports: self.categoriesDict["Sports"]!, food: self.categoriesDict["Food"]!, free: self.categoriesDict["Free"]!, radius: 0.0, checkInRatio: "", numEventsAttended: 0)
                    self.currentUser = newUser
                    let newString = (email as NSString).replacingOccurrences(of: ".", with: "@")
                    let userRef = FIRDatabase.database().reference(withPath: newString)
                    userRef.setValue(newUser.toAnyObject())
                    
                    // make a separate one for preferences (for faster loading)
                    let prefRef = FIRDatabase.database().reference(withPath: "\(newString)pref")
                    prefRef.setValue([
                        "nightlife": self.categoriesDict["Nightlife"]!,
                        "sports": self.categoriesDict["Sports"]!,
                        "food": self.categoriesDict["Food"]!,
                        "free": self.categoriesDict["Free"]!,
                        "radius": 25.0,
                        "checkInRatio": "",
                        "numEventsAttended": 0
                        ])
                    
                    self.performSegue(withIdentifier: "UserSuccessRegistrationSegue", sender: nil)
                }
                else {
                    print("Failure - Account Creation Failed!")
                    self.alertLabel.text = "Email already in use!"
                }
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func nextBtnClicked(_ sender: AnyObject) {
        // HERE is where we actually make the account with the given info
        createNewUser(email: userEmail!, password: userPassword!)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "userCreateSettingsSegue" {
            let userCreateSettingsTableViewController = segue.destination as! UserCreateSettingsTableViewController
            userCreateSettingsTableViewController.userCreateViewController = self
        }
        
        // upon successful registration, send user obj to event list
        if segue.identifier == "UserSuccessRegistrationSegue" {
            let tabBarController = segue.destination as! UITabBarController
            let navSettingsViewController = tabBarController.viewControllers?[2] as! UINavigationController
            let settingsViewController = navSettingsViewController.topViewController as! SettingsViewController
            settingsViewController.currentUser = self.currentUser
        }
    }
}
