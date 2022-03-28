//
//  Flow16MyOrderDashboardPendingTableViewCellAndXib.swift
//  Joker
//
//  Created by abc on 01/02/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class Flow16MyOrderDashboardPendingTableViewCellAndXib: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var btnReportOrder: UIButton!
    
    @IBOutlet weak var btnContactAdmin: UIButton!
    
    @IBOutlet weak var btnCancelOrder: UIButton!
    
    @IBOutlet weak var lblOrderID: UILabel!
    
    @IBOutlet weak var btnViewRating: UIButton!
    
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var lblAvgRating: UILabel!
    
    @IBOutlet weak var lblMyLocationToDropLocation: UILabel!
    
    @IBOutlet weak var lblOfferAmount: UILabel!
    
    @IBOutlet weak var lblDeliveryMessage: UILabel!
    
    @IBOutlet weak var lblApproxTime: UILabel!
    
    @IBOutlet weak var lblContactNumber: UILabel!
    
    @IBOutlet weak var lblOrderDetail: UILabel!
    
    @IBOutlet weak var lblInvoiceDetail: UILabel!
    
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
