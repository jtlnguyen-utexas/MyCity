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

    @IBOutlet var filterControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        if segue.identifier == "eventListSegue" {
            let eventsTableViewController = segue.destination as! EventsTableViewController
            eventsTableViewController.currentUser = self.currentUser
            eventsTableViewController.eventListViewController = self
        }
        
        if segue.identifier == "ShowCalendarSegue" {
            let calendarView = segue.destination as! CalendarView
            let eventsTVC = self.childViewControllers[0] as! EventsTableViewController
            calendarView.events = eventsTVC.events
        }
    }
    
}
