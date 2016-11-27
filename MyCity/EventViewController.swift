//
//  EventViewController.swift
//  MyCity
//
//  Created by Hamza Muhammad on 10/26/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class EventViewController: UIViewController {
    
    var currEvent: Event?
    var currentUser: User?
    
    @IBOutlet var eventImage: UIImageView!
    @IBOutlet var eventName: UILabel!
    @IBOutlet var eventAddress: UILabel!
    @IBOutlet var eventDescription: UILabel!
    
    @IBAction func userGoing(_ sender: Any) {
        let prefsRef = FIRDatabase.database().reference()
        let toBePosted : Dictionary<String, Any> = [
            "eventKey": currEvent!.eventKey,
            "eventName": currEvent!.eventName,
            "eventStart": currEvent!.eventStart,
            "eventEnd": currEvent!.eventEnd,
            "eventDescription": currEvent!.eventDescription,
            "eventAddress": currEvent!.eventAddress,
            "eventTags": currEvent!.eventTags,
            "eventCheckIns": currEvent!.eventCheckIns + 1,
            "eventRSVPs": currEvent!.eventRSVPs,
            "latitude": currEvent!.latitude,
            "longitude": currEvent!.longitude,
            "orgEmail": currEvent!.orgEmail,
            "eventHash": currEvent!.eventHash
        ]
        
        let email = ((currEvent!.orgEmail) as NSString).replacingOccurrences(of: ".", with: "@")
        let newString = "e \(email) \(currEvent!.eventHash)"
        let childUpdates = ["\(newString)": toBePosted]
        
        prefsRef.updateChildValues(childUpdates)
    }
    
    @IBAction func userInterested(_ sender: Any) {
        let prefsRef = FIRDatabase.database().reference()
        let toBePosted : Dictionary<String, Any> = [
            "eventKey": currEvent!.eventKey,
            "eventName": currEvent!.eventName,
            "eventStart": currEvent!.eventStart,
            "eventEnd": currEvent!.eventEnd,
            "eventDescription": currEvent!.eventDescription,
            "eventAddress": currEvent!.eventAddress,
            "eventTags": currEvent!.eventTags,
            "eventCheckIns": currEvent!.eventCheckIns,
            "eventRSVPs": currEvent!.eventRSVPs + 1,
            "latitude": currEvent!.latitude,
            "longitude": currEvent!.longitude,
            "orgEmail": currEvent!.orgEmail,
            "eventHash": currEvent!.eventHash
        ]
        
        let email = ((currEvent!.orgEmail) as NSString).replacingOccurrences(of: ".", with: "@")
        let newString = "e \(email) \(currEvent!.eventHash)"
        let childUpdates = ["\(newString)": toBePosted]
        
        prefsRef.updateChildValues(childUpdates)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // fill the fields out
        eventName.text = currEvent?.eventName
        eventAddress.text = currEvent?.eventAddress
        eventDescription.text = currEvent?.eventDescription
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
