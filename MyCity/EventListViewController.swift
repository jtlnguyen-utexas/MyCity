//
//  EventListViewController.swift
//  MyCity
//
//  Created by Hamza Muhammad on 10/26/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController {
    
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("got here with user: \(currentUser?.toAnyObject())")
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
