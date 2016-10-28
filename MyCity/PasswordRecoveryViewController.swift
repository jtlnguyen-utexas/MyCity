//
//  PasswordRecoveryViewController.swift
//  MyCity
//
//  Created by Alec Griffin on 10/27/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class PasswordRecoveryViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var recoveryMessage: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard)))
        
        recoveryMessage.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        emailTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        return true
    }
    
    // MARK: Actions
    
    @IBAction func sendRecoveryEmailBtn(_ sender: AnyObject) {
        let email = emailTextField.text!
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: email) { error in
            if error != nil {
                // An error happened.
                self.recoveryMessage.text = "Please Enter a Valid Email Address!"
            } else {
                // Password reset email sent.
                self.recoveryMessage.text = "Password Reovery Email Sent!"
            }
        }
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
