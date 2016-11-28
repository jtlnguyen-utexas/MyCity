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

class OrgCreateViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    // Objects to store to Firebase
    var currentOrg: Org?
    var orgEmail: String?
    var orgPassword: String?
    var category: String = ""
    
    // Fields
    @IBOutlet var orgNameField: UITextField!
    @IBOutlet var orgAddressField: UITextField!
    
    // Label
    @IBOutlet var alertMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        orgNameField.delegate = self
        orgAddressField.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
        
        alertMessageLabel.text = ""
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
    
    // MARK: Actions
    
    @IBAction func nextBtnClicked(_ sender: AnyObject) {
        createNewOrg(email: orgEmail!, password: orgPassword!)
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
                    self.alertMessageLabel.text = "Email already in use!"
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "OrgCreateSettingsSegue" {
            let orgCreateSettingsTableViewController = segue.destination as! OrgCreateSettingsTableViewController
            orgCreateSettingsTableViewController.orgCreateViewController = self
        }
        
        // upon successful registration, send user obj to event list
        if segue.identifier == "OrgSuccessRegistrationSegue" {
            
            let tabBarController = segue.destination as! UITabBarController
            let navSettingsViewController = tabBarController.viewControllers?[2] as! UINavigationController
            let orgSettingsViewController = navSettingsViewController.topViewController as! OrgSettingsViewController
            orgSettingsViewController.currentOrg = self.currentOrg
            
            let addNavBarController = tabBarController.viewControllers?[1] as! UINavigationController
            let addEventViewController = addNavBarController.topViewController as! AddEventViewController
            addEventViewController.currentOrg = self.currentOrg
            
            let navBarController = tabBarController.viewControllers?[0] as! UINavigationController
            let orgEventListViewController = navBarController.topViewController as! OrgEventListViewController
            orgEventListViewController.currentOrg = self.currentOrg
        }
    }
}
