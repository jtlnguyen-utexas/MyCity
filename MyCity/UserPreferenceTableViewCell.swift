//
//  UserPreferenceTableViewCell.swift
//  MyCity
//
//  Created by Nelia Perez on 10/25/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class UserPreferenceTableViewCell: UITableViewCell {

    // MARK: Properties

    @IBOutlet weak var preferenceLabel: UILabel!
    @IBOutlet weak var preferenceSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
