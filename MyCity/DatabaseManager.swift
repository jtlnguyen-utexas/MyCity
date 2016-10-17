//
//  DatabaseManager.swift
//  MyCity
//
//  Created by Alec Griffin on 10/16/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class DatabaseManager{
    
    // Class Data:
    private static var successfulLogin:Bool = false;
    private static var successfulAccountCreation:Bool = false;
    
    class func createNewUser(email:String, password:String, retypedPassword:String, viewcontroller:UIViewController) -> Bool{
        if email != "" && password != "" && password == retypedPassword{
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                if error == nil {
                    print("Success - Account Created!")
                    successfulAccountCreation = true
                }else{
                    print("Failure - Account Creation Failed!")
                    successfulAccountCreation = false
                    print(error)
                }

            }
        }
        return successfulAccountCreation;
    }
    
    class func signInUser(email:String, password:String, viewcontroller:UIViewController) -> Bool{
        
        // Ensure fields are not empty
        if email != "" && password != ""{
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            
                
                // Determine if login was successful
                if error == nil{
                    print("Login Succesful!")
                    successfulLogin = true
                    viewcontroller.performSegue(withIdentifier: "mainViewSegue", sender: nil)
                }else{
                    print("Login Failed!")
                    successfulLogin = false
                    print(error)
                }
            }
        }else{
            print("Either email or password field is empty!")
        }
        return successfulLogin
    }
}
