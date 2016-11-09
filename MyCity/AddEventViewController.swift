//
//  AddEventViewController.swift
//  MyCity
//
//  Created by Nelia Perez on 11/8/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {

    // MARK: Properties
    
    var currentOrg: Org?
    
    @IBOutlet var eventNameField: UITextField!
    @IBOutlet var eventAddressField: UITextField!
    @IBOutlet var eventStartField: UITextField!
    @IBOutlet var eventEndField: UITextField!
    @IBOutlet var eventDescritpionField: UITextField!
    @IBOutlet var eventTagsField: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageSelector)))
        imageView.isUserInteractionEnabled = true
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
    }
    
    func handleImageSelector() {
        print("Clicked on Image")
    }

}
