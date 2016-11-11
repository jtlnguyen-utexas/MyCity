//
//  OrgEventViewController.swift
//  MyCity
//
//  Created by Hamza Muhammad on 11/8/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class OrgEventViewController: UIViewController {
    
    var currentOrg: Org?
    var currEvent: Event?
    
    @IBOutlet var eventNameField: UITextField!
    @IBOutlet var orgNameLabel: UILabel!
    @IBOutlet var eventLocationField: UITextField!
    @IBOutlet var eventDescriptionField: UITextField!
    @IBOutlet var eventTagsField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        // here, we fill all of the fields with the appropriate event data
        eventNameField.text = currEvent?.eventName
        eventLocationField.text = currEvent?.eventAddress
        eventDescriptionField.text = currEvent?.eventDescription
        eventTagsField.text = (currEvent?.eventTags)!
        orgNameLabel.text = currentOrg?.orgName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // when the user exits, save all of this data!

        let prefsRef = FIRDatabase.database().reference()
        let toBePosted : Dictionary<String, Any> = [
            "eventKey": currEvent!.eventKey,
            "eventName": eventNameField.text!,
            "eventStart": currEvent!.eventStart,
            "eventEnd": currEvent!.eventEnd,
            "eventDescription": eventDescriptionField.text!,
            "eventAddress": eventLocationField.text!,
            "eventTags": eventTagsField.text!,
            "eventCheckIns": currEvent!.eventCheckIns,
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
