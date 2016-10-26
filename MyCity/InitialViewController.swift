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

class InitialViewController: UIViewController {
    
    var currentUser: User?
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var alertLabel: UILabel!
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        
        // here, we check whether the fields are filled
        if emailField.text == "" && passwordField.text == "" {
            alertLabel.text = "Please fill out both fields!"
        }
        else { // then check the validity of login
            signInUser(email: emailField.text!, password: passwordField.text!)
        }
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
                        
                        print("retrieved user! user email: \(self.currentUser?.emailAddress)")
                        self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
                else {
                    print("Login Failed!")
                    print(error)
                    self.alertLabel.text = "Invalid email/password"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        alertLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            print("our current user val is: \(self.currentUser!)")
            eventListViewController.currentUser = self.currentUser
        }
    }
}
