//
//  MyOrderDashBoardProffessionalPendingTableViewCell.swift
//  Joker
//
//  Created by abc on 01/02/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class MyOrderDashBoardProffessionalPendingTableViewCell: UITableViewCell {
    //MARK: - Outlets
  //  @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var btnViewAllOffers: UIButton!
    
    @IBOutlet weak var btnEditOrder: UIButton!
    
    @IBOutlet weak var btnDeleteOrder: UIButton!
    
    @IBOutlet weak var lblOrderID: UILabel!
    
    @IBOutlet weak var lblDateAndTime: UILabel!
    
   // @IBOutlet weak var lblOrderDetail: UILabel!
    
    @IBOutlet weak var lblAddressDetail: UILabel!
    
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var lblMe: UILabel!
    
    @IBOutlet weak var lblServiceLocationHeading: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
