//
//  CreateAccountViewController.swift
//  MyCity
//
//  Created by Alec Griffin on 10/16/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    // Fields
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var rePasswordField: UITextField!

    // Labels
    @IBOutlet var alertLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        rePasswordField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))

        // Do any additional setup after loading the view.
        alertLabel.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Used to dismiss the keyboard upon tapping outside of the keyboard region
    func dismissKeyboard(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        rePasswordField.resignFirstResponder()
    }
    
    // Used to dismiss the keyboard upon the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        rePasswordField.resignFirstResponder()
        return true
    }
    
    // MARK: Properties
    
    @IBAction func userCreateButton(_ sender: AnyObject) {
        if(emailField.text == "" || passwordField.text == "" || rePasswordField.text == ""){
            alertLabel.text = "Please Fill out all Fields Above!"
        }else if passwordField.text == rePasswordField.text {
            performSegue(withIdentifier: "UserCreateSegue", sender: nil)
        }
        else {
            alertLabel.text = "Passwords do not match!"
        }
    }
    
    @IBAction func orgCreateButton(_ sender: AnyObject) {
        if(emailField.text == "" || passwordField.text == "" || rePasswordField.text == ""){
            alertLabel.text = "Please Fill out all Fields Above!"
        }else if passwordField.text == rePasswordField.text {
            performSegue(withIdentifier: "OrgCreateSegue", sender: nil)
        }
        else {
            alertLabel.text = "Passwords do not match!"
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "UserCreateSegue" {
            let userCreateViewController = segue.destination as! UserCreateViewController
            userCreateViewController.userEmail = emailField.text
            userCreateViewController.userPassword = passwordField.text
        }
        
        if segue.identifier == "OrgCreateSegue" {
            //TODO LATER
            let orgCreateViewController = segue.destination as! OrgCreateViewController
            orgCreateViewController.orgEmail = emailField.text
            orgCreateViewController.orgPassword = passwordField.text
        }
    }
}
