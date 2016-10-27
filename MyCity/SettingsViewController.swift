//
//  SettingsViewController.swift
//  MyCity
//
//  Created by Hamza Muhammad on 10/26/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    var currentUser: User?
    
    @IBOutlet var nightlifeSwitch: UISwitch!
    @IBOutlet var sportsSwitch: UISwitch!
    @IBOutlet var foodSwitch: UISwitch!
    @IBOutlet var freeSwitch: UISwitch!
    
    @IBOutlet var checkInLabel: UILabel!
    @IBOutlet var eventsAttendedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
            // here, we have to retrieve the user object
            let ref = FIRDatabase.database().reference()
        
            // have to parse email
            let newString = ((currentUser?.emailAddress)! as NSString).replacingOccurrences(of: ".", with: "@")
        
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
                print("we get in here")
                self.currentUser = User(userKey: userKey, firstName: firstName, lastName: lastName, emailAddress: emailAddress, location: location, nightlife: nightlife, sports: sports, food: food, free: free, radius: radius, checkInRatio: checkInRatio, numEventsAttended: numEventsAttended)
                print("user in VWL: \((self.currentUser?.nightlife)!)")
            } })
    }

    override func viewWillAppear(_ animated: Bool) {
        print("user in VWA: \((currentUser?.nightlife)!)")
        nightlifeSwitch.setOn((currentUser?.nightlife)!, animated: false)
        sportsSwitch.setOn((currentUser?.sports)!, animated: false)
        foodSwitch.setOn((currentUser?.food)!, animated: false)
        freeSwitch.setOn((currentUser?.free)!, animated: false)
        
        checkInLabel.text = currentUser?.checkInRatio
        eventsAttendedLabel.text = "\(currentUser?.numEventsAttended)"
    }

    override func viewWillDisappear(_ animated: Bool) {
        // we will save the data here
        print("emailAddress: \(currentUser?.emailAddress)")
        let userRef = FIRDatabase.database().reference()
        print("get here")
        let user: [String:String] = ["isUser": "\((currentUser?.isUser)!)",
                    "userKey": "\((currentUser?.userKey)!)",
                    "firstName": "\((currentUser?.firstName)!)",
                    "lastName": "\((currentUser?.lastName)!)",
                    "emailAddress": "\((currentUser?.emailAddress)!)",
                    "location": "\((currentUser?.emailAddress)!)",
                    "nightlife": "\(nightlifeSwitch.isOn)",
                    "sports": "\(sportsSwitch.isOn)",
                    "food": "\(foodSwitch.isOn)",
                    "free": "\(freeSwitch.isOn)",
                    "radius": "\((currentUser?.radius)!)",
                    "checkInRatio": "\((currentUser?.checkInRatio)!)",
                    "numEventsAttended": String((describing: (currentUser?.numEventsAttended)!))
                    ]
        let newString = ((currentUser?.emailAddress)! as NSString).replacingOccurrences(of: ".", with: "@")
        let childUpdates = ["\(newString)": user]
        userRef.updateChildValues(childUpdates)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButton(_ sender: AnyObject) {
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
