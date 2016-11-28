//
//  SettingsTableViewCell.swift
//  MyCity
//
//  Created by Nelia Perez on 11/27/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

protocol SettingsTableViewCellDelegate {
    func changedSwitchValue(category: String, value: Bool)
}

class SettingsTableViewCell: UITableViewCell {

    var delegate: SettingsTableViewController?
    
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var categorySwitch: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchChanged(_ sender: UISwitch) {
        self.delegate?.changedSwitchValue(category: categoryLabel.text!, value: categorySwitch.isOn)
    }
}
