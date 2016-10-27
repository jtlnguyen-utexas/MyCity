//
//  CreateAccountViewController.swift
//  MyCity
//
//  Created by Alec Griffin on 10/16/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var rePasswordField: UITextField!

    @IBOutlet var alertLabel: UILabel!
    
    @IBAction func userCreateButton(_ sender: AnyObject) {
        if passwordField.text == rePasswordField.text {
            performSegue(withIdentifier: "UserCreateSegue", sender: nil)
        }
        else {
            alertLabel.text = "Passwords do not match!"
        }
    }
    
    @IBAction func orgCreateButton(_ sender: AnyObject) {
        if passwordField.text == rePasswordField.text {
            performSegue(withIdentifier: "OrgCreateSegue", sender: nil)
        }
        else {
            alertLabel.text = "Passwords do not match!"
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
