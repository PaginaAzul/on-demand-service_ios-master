//
//  ManageWalletPassbookNewTableViewCell.swift
//  Joker
//
//  Created by abc on 31/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class ManageWalletPassbookNewTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDateAndTime: UILabel!
    
    @IBOutlet weak var lblDeliveryOffer: UILabel!
    
    @IBOutlet weak var lblTax: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
