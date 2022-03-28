//
//  NotificationCell.swift
//  Joker
//
//  Created by Apple on 01/02/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var lbl_Data: UILabel!
    
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
