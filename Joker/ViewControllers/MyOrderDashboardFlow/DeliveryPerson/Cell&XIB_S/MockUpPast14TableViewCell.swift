//
//  MockUpPast14TableViewCell.swift
//  Joker
//
//  Created by abc on 31/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class MockUpPending14TableViewCell: UITableViewCell {
    //MARK: - Outlet
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var btnReportOrder: UIButton!
    
    
    @IBOutlet weak var btnContactAdmin: UIButton!
    
    @IBOutlet weak var btnReportCancelOrder: UIButton!
    
    @IBOutlet weak var lblOrderId: UILabel!
    
    @IBOutlet weak var btnViewRating: UIButton!
    
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    
    
    @IBOutlet weak var lblMeToPickup: UILabel!
    
    @IBOutlet weak var lblPickupToDrop: UILabel!
    
    @IBOutlet weak var lblAddressDetail: UILabel!
    
    @IBOutlet weak var lblContactNumber: UILabel!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var lblWorkCompletionTime: UILabel!
    
    @IBOutlet weak var lblInvoiceDateAndTime: UILabel!
    
    @IBOutlet weak var lblDeliveryOffer: UILabel!
    
    @IBOutlet weak var lblTax: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var lblAvgRating: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        imgProfile.layer.cornerRadius = imgProfile.frame.width/2
        imgProfile.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
