//
//  MyOrderDashboardPastCellAndXib.swift
//  Joker
//
//  Created by abc on 31/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class MyOrderDashboardPastCellAndXib: UITableViewCell {
    //MARK: - Outlets
  
    
    @IBOutlet weak var lblOrderID: UILabel!
    
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    @IBOutlet weak var lblInvoiceDate: UILabel!
    
    @IBOutlet weak var lblDeliveryOffer: UILabel!
    
    @IBOutlet weak var lblTax: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var btnRateToOrder: UIButton!
    
    @IBOutlet weak var lblAvgRatingOrder: UILabel!
    
    @IBOutlet weak var lblInvoiceTotal: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
