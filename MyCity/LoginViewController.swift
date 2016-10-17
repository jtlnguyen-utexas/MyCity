//
//  LoginViewController.swift
//  MyCity
//
//  Created by Alec Griffin on 10/16/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginBtn(_ sender: AnyObject) {
        let successfulLogin = DatabaseManager.signInUser(email: self.email.text!, password: self.password.text!, viewcontroller: self)
    }
    
    // Handle the situation when the user doesn't have an account
    @IBAction func noUserAccountBtn(_ sender: AnyObject) {
        
    }
    
    
    // Handle the situation when the user has forgoten his password
    @IBAction func forgotPasswordBtn(_ sender: AnyObject) {
        
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
