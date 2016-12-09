//
//  CalendarView.swift
//  MyCity
//
//  Created by Hamza Muhammad on 12/8/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation
import JTAppleCalendar
import Firebase

class CalendarView: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "CellView") // Registering your cell is manditory
    }
}

extension CalendarView: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = Date() // You can use date generated from a formatter
        let endDate = Date()                                // You can also use dates created from this function
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfGrid,
            firstDayOfWeek: .sunday)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let myCustomCell = cell as! CellView
        
        // Setup Cell text
        myCustomCell.dayLabel.text = cellState.text

        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy, hh:mm aa"
        
        var isEvent: Bool = false
        
        for event in events {
            let endDate = formatter.date(from: event.eventEnd)

            if date >= Date() && endDate! >= date {
                if event.eventTags == "nightlife" {
                    myCustomCell.dayLabel.textColor = UIColor.red
                }
                if event.eventTags == "sports" {
                    myCustomCell.dayLabel.textColor = UIColor.blue
                }
                if event.eventTags == "food" {
                    myCustomCell.dayLabel.textColor = UIColor.brown
                }
                if event.eventTags == "free" {
                    myCustomCell.dayLabel.textColor = UIColor.yellow
                }
                isEvent = true
            }
        }
        
        // Setup text color
        if isEvent == false {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dayLabel.textColor = UIColor.black
            } else {
                myCustomCell.dayLabel.textColor = UIColor.gray
            }
        }
    }
}
