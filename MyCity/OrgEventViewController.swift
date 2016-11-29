//
//  OrgEventViewController.swift
//  MyCity
//
//  Created by Hamza Muhammad on 11/8/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class OrgEventViewController: UIViewController, UITextFieldDelegate {
    
    var currentOrg: Org?
    var currEvent: Event?
    var dateField: String?
    var _latitude: String?
    var _longitude: String?
    
    
    @IBOutlet var eventNameField: UITextField!
    @IBOutlet var eventLocationField: UITextField!
    @IBOutlet var eventDescriptionField: UITextField!
    @IBOutlet var eventTagsField: UITextField!
    @IBOutlet var startField: UITextField!
    @IBOutlet var endField: UITextField!
    
    @IBOutlet var checkInLabel: UILabel!
    @IBOutlet var rsvpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        startField.delegate = self
        endField.delegate = self
        
        // here, we fill all of the fields with the appropriate event data
        eventNameField.text = currEvent?.eventName
        eventLocationField.text = currEvent?.eventAddress
        eventDescriptionField.text = currEvent?.eventDescription
        eventTagsField.text = (currEvent?.eventTags)!
        let checkInCount = (currEvent?.eventCheckIns)!
        let rsvpCount = (currEvent?.eventRSVPs)!
        checkInLabel.text = String(checkInCount)
        rsvpLabel.text = String(rsvpCount)
        startField.text = currEvent?.eventStart
        endField.text = currEvent?.eventEnd
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // when the user exits, save all of this data!

        CLGeocoder().geocodeAddressString(eventLocationField.text!, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            let placemark = placemarks?[0]
            let location = placemark?.location
            let coordinate = location?.coordinate
            self._latitude = "\(coordinate!.latitude)"
            self._longitude = "\(coordinate!.longitude)"
            
            let prefsRef = FIRDatabase.database().reference()
            let toBePosted : Dictionary<String, Any> = [
                "eventKey": self.currEvent!.eventKey,
                "eventName": self.eventNameField.text!,
                "eventStart": self.startField.text!,
                "eventEnd": self.endField.text!,
                "eventDescription": self.eventDescriptionField.text!,
                "eventAddress": self.eventLocationField.text!,
                "eventTags": self.eventTagsField.text!,
                "eventCheckIns": self.currEvent!.eventCheckIns,
                "eventRSVPs": self.currEvent!.eventRSVPs,
                "latitude": self._latitude!,
                "longitude": self._longitude!,
                "orgEmail": self.currEvent!.orgEmail,
                "eventHash": self.currEvent!.eventHash
            ]
            
            let email = ((self.currEvent!.orgEmail) as NSString).replacingOccurrences(of: ".", with: "@")
            let newString = "e \(email) \(self.currEvent!.eventHash)"
            let childUpdates = ["\(newString)": toBePosted]
            
            prefsRef.updateChildValues(childUpdates)
        })
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dateField = textField.text
        let datePicker = UIDatePicker()
        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(self.datePickerChanged(sender:)), for: .allEvents)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.text = dateField
        return true
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let dateStr:String = formatter.string(from: sender.date)
        dateField = dateStr
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
