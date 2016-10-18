//
//  TestMainViewController.swift
//  MyCity
//
//  Created by Alec Griffin on 10/17/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class TestMainViewController: UIViewController {

    @IBOutlet weak var registerContainer: UIView!
    @IBOutlet weak var loginContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showComponent(_ sender: AnyObject) {
        if sender.selectedSegmentIndex == 0{
            UIView.animate(withDuration: 0.2, animations: {
                self.registerContainer.alpha = 1
                self.loginContainer.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.registerContainer.alpha = 0
                self.loginContainer.alpha = 1
            })
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
