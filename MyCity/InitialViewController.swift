//
//  InitialViewController.swift
//  MyCity
//
//  Created by Alec Griffin on 10/17/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth


class InitialViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    // User and Org objects to store after retrieval
    var currentUser: User?
    var currentOrg: Org?
    
    // Text Fields
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    // Labels
    @IBOutlet var alertLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        alertLabel.text = ""
        
        emailField.delegate = self
        passwordField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Used to dismiss the keyboard upon tapping outside of the keyboard region
    func dismissKeyboard(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    // Used to dismiss the keyboard upon the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return true
    }
    
    func signInUser(email:String, password:String) {
        
        // Ensure fields are not empty
        if email != "" && password != ""{
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                // Determine if login was successful
                if error == nil {
                    print("Login Successful!")
                    
                    // here, we have to retrieve the user object
                    let ref = FIRDatabase.database().reference()
                    
                    // have to parse email
                    let newString = (email as NSString).replacingOccurrences(of: ".", with: "@")
                    
                    // get a firebase snapchat
                    ref.child(newString).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        // Get user values
                        let value = snapshot.value as? NSDictionary
                        
                        let isUser = value?["isUser"] as! Bool
                        
                        if isUser == true {
                            // means we are dealing with a USER object
                            let userKey = value?["userKey"] as! String
                            let firstName = value?["firstName"] as! String
                            let lastName = value?["lastName"] as! String
                            let emailAddress = value?["emailAddress"] as! String
                            let location = value?["location"] as! String
                            let nightlife = value?["nightlife"] as! Bool
                            let sports = value?["sports"] as! Bool
                            let food = value?["food"] as! Bool
                            let free = value?["free"] as! Bool
                            let radius = value?["radius"] as! Float
                            let checkInRatio = value?["checkInRatio"] as! String
                            let numEventsAttended = value?["numEventsAttended"] as! Int
                            self.currentUser = User(userKey: userKey, firstName: firstName, lastName: lastName, emailAddress: emailAddress, location: location, nightlife: nightlife, sports: sports, food: food, free: free, radius: radius, checkInRatio: checkInRatio, numEventsAttended: numEventsAttended)
                            
                            self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                        }
                        else {
                            // have an ORG object
                            let orgKey = value?["orgKey"] as! String
                            let orgName = value?["orgName"] as! String
                            let emailAddress = value?["emailAddress"] as! String
                            let location = value?["location"] as! String
                            let category = value?["category"] as! String
                            let userViewCount = value?["userViewCount"] as! Int
                            let userEventsAttended = value?["userEventsAttended"] as! Int
                            self.currentOrg = Org(orgKey: orgKey, orgName: orgName, emailAddress: emailAddress, location: location, category: category, userViewCount: userViewCount, userEventsAttended: userEventsAttended)
                            
                            self.performSegue(withIdentifier: "OrgLoginSegue", sender: nil)
                        }
                        
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
                else {
                    print("Login Failed!")
                    self.alertLabel.text = "Invalid email/password"
                }
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        // here, we check whether the fields are filled
        if emailField.text == "" && passwordField.text == "" {
            alertLabel.text = "Please fill out both fields!"
        }
        else { // then check the validity of login
            signInUser(email: emailField.text!, password: passwordField.text!)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "LoginSegue" {
            
            // make sure that the proper user data is passed in:
            let tabBarController = segue.destination as! UITabBarController
            let navBarController = tabBarController.viewControllers?[0] as! UINavigationController
            let eventListViewController = navBarController.topViewController as! EventListViewController
            eventListViewController.currentUser = self.currentUser
            
            let navMapViewController = tabBarController.viewControllers?[1] as! UINavigationController
            let eventMapViewController = navMapViewController.topViewController as! EventMapViewController
            eventMapViewController.currentUser = self.currentUser
            
            let navSettingsViewController = tabBarController.viewControllers?[2] as! UINavigationController
            let settingsViewController = navSettingsViewController.topViewController as! SettingsViewController
            settingsViewController.currentUser = self.currentUser
        }
    
        if segue.identifier == "OrgLoginSegue" {
            
            // make sure that the proper user data is passed in:
            let tabBarController = segue.destination as! UITabBarController
            let navBarController = tabBarController.viewControllers?[0] as! UINavigationController
            let orgEventListViewController = navBarController.topViewController as! OrgEventListViewController
            orgEventListViewController.currentOrg = self.currentOrg
            
            let addNavBarController = tabBarController.viewControllers?[1] as! UINavigationController
            let addEventViewController = addNavBarController.topViewController as! AddEventViewController
            addEventViewController.currentOrg = self.currentOrg
            
            let navSettingsViewController = tabBarController.viewControllers?[2] as! UINavigationController
            let orgSettingsViewController = navSettingsViewController.topViewController as! OrgSettingsViewController
            orgSettingsViewController.currentOrg = self.currentOrg
        }
    }
}
