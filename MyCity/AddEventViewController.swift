//
//  AddEventViewController.swift
//  MyCity
//
//  Created by Nelia Perez on 11/8/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class AddEventViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    
    var currentOrg: Org?
    var dateField: String?
    
    @IBOutlet var eventNameField: UITextField!
    @IBOutlet var eventAddressField: UITextField!
    @IBOutlet var startField: UITextField!
    @IBOutlet var endField: UITextField!
    
    @IBOutlet var eventTagsField: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var eventDescriptionField: UITextField!
    
    @IBOutlet var eventMsgLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageSelector)))
        imageView.isUserInteractionEnabled = true
        
        startField.delegate = self
        endField.delegate = self
        
        eventMsgLabel.text = ""
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
    
    // MARK: Actions
    @IBAction func eventAddBtn(_ sender: AnyObject) {
        let newEvent = Event(eventKey: (currentOrg?.emailAddress)!, eventName: eventNameField.text!, eventStart: startField.text!, eventEnd: endField.text!, eventDescription: eventDescriptionField.text!, eventAddress: eventAddressField.text!, eventTags: eventTagsField.text!, eventCheckIns: 0, eventRSVPs: 0, orgEmail: (currentOrg?.emailAddress)!, latitude: "", longitude: "", eventHash: "")
        newEvent.forwardGeocoding(address: newEvent.eventAddress)
        print("get here")

        //eventMsgLabel.text = "Event added!"
        
        eventNameField.text = ""
        eventAddressField.text = ""
        startField.text = ""
        endField.text = ""
        eventDescriptionField.text = ""
        eventTagsField.text = ""
        
        let alert = UIAlertController(title: "Alert", message: "Event added!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleImageSelector() {
        print("Clicked on Image")
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


}
