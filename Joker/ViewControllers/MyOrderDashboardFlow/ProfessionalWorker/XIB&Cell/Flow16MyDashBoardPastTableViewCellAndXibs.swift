//
//  Flow16MyDashBoardPastTableViewCellAndXibs.swift
//  Joker
//
//  Created by abc on 01/02/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class Flow16MyDashBoardPastTableViewCellAndXibs: UITableViewCell {

    //MARK: - Outlets
  //  @IBOutlet weak var lblDescription: UILabel!
  //  @IBOutlet weak var lblMessages: UILabel!
    
    @IBOutlet weak var lblOrderId: UILabel!
    
    //@IBOutlet weak var btnRateRef: UIButton!
    
    @IBOutlet weak var lblDateAndTime: UILabel!
    
   // @IBOutlet weak var lblOrderDetails: UILabel!
    
   // @IBOutlet weak var lblAddressDetails: UILabel!
    
   // @IBOutlet weak var lblServiceLocation: UILabel!
    
    @IBOutlet weak var lblOfferAmount: UILabel!
    
    @IBOutlet weak var lblInvoiceDate: UILabel!
    
    @IBOutlet weak var lblDeliveryOffer: UILabel!
    
    @IBOutlet weak var lblTax: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var lblRating: UILabel!
    
    @IBOutlet weak var btnTapAvgRating: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
