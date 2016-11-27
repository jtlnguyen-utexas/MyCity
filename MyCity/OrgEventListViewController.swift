//
//  OrgEventListViewController.swift
//  MyCity
//
//  Created by Nelia Perez on 10/26/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class OrgEventListViewController: UIViewController, UISearchBarDelegate {
    
    var currentOrg: Org?

    @IBOutlet var seachBar: UISearchBar!
    @IBOutlet var filterChoice: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        seachBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.seachBar.endEditing(true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "eventOrgListSegue" {
            let orgEventListTableViewController = segue.destination  as! OrgEventListTableViewController
            orgEventListTableViewController.currentOrg = self.currentOrg
            orgEventListTableViewController.orgEventListViewController = self
        }
    }
}
