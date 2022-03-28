//
//  SettingsTableViewCell.swift
//  Joker
//
//  Created by abc on 22/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var lblSettingName: UILabel!
    @IBOutlet weak var switchNotification: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
