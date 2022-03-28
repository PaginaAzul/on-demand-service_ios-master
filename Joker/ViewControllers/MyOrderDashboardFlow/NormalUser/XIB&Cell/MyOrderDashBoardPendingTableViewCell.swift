//
//  MyOrderDashBoardPendingTableViewCell.swift
//  Joker
//
//  Created by abc on 30/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class MyOrderDashBoardPendingTableViewCell: UITableViewCell {
    //MARK: - Outlets
   
    @IBOutlet weak var btnViewAllOffers: UIButton!
    
    @IBOutlet weak var btnEditOrder: UIButton!
    
    
    @IBOutlet weak var btnDeleteOrder: UIButton!
    
    @IBOutlet weak var lblOrderID: UILabel!
    
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    @IBOutlet weak var lblAddressDetail: UILabel!
    
    @IBOutlet weak var lblMeToPickup: UILabel!
    
    @IBOutlet weak var lblPickupToDrop: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        //Flow 13
        
    }
    
}
