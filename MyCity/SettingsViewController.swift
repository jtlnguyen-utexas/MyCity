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
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // here, we have to retrieve the user object
        let ref = FIRDatabase.database().reference()
        
        // have to parse email
        let newString = ((currentUser?.emailAddress)! as NSString).replacingOccurrences(of: ".", with: "@")
        
        // get a firebase snapchat
        ref.child("\(newString)pref").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user values
            let value = snapshot.value as? NSDictionary
    
            self.nightlifeSwitch.setOn((value?["nightlife"] as! Bool), animated: false)
            self.sportsSwitch.setOn((value?["sports"] as! Bool), animated: false)
            self.foodSwitch.setOn((value?["food"] as! Bool), animated: false)
            self.freeSwitch.setOn((value?["free"] as! Bool), animated: false)
            
            self.checkInLabel.text = "\(value?["checkInRatio"] as! String)"
            self.eventsAttendedLabel.text = "\(value?["numEventsAttended"] as! Int)"
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        // we will save the data here
        let prefsRef = FIRDatabase.database().reference()
        let toBePosted : Dictionary<String, Any> = [
            "nightlife": self.nightlifeSwitch.isOn,
            "sports": self.sportsSwitch.isOn,
            "food": self.foodSwitch.isOn,
            "free": self.freeSwitch.isOn,
            "radius": 0.0,
            "checkInRatio": String(describing: checkInLabel.text!),
            "numEventsAttended": 0
        ]
        let newString = ((currentUser?.emailAddress)! as NSString).replacingOccurrences(of: ".", with: "@")
        let childUpdates = ["\(newString)pref": toBePosted]
        
        prefsRef.updateChildValues(childUpdates)
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
