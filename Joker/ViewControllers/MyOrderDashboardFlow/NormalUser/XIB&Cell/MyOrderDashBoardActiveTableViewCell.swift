//
//  MyOrderDashBoardActiveTableViewCell.swift
//  Joker
//
//  Created by abc on 30/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class MyOrderDashBoardActiveTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var btnReportOrder: UIButton!
  //  @IBOutlet weak var btnContactAdmin: UIButton!
    
 //   @IBOutlet weak var btnCancelOrder: UIButton!
    
    @IBOutlet weak var lblOrderID: UILabel!
    
  //  @IBOutlet weak var lblNote: UILabel!
    
   // @IBOutlet weak var btnMessage: UIButton!
    
  //  @IBOutlet weak var btnCall: UIButton!
  
  //  @IBOutlet weak var btnTrack: UIButton!
    
    
    @IBOutlet weak var btnViewRating: UIButton!
    
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblStartToPickupLocation: UILabel!
    
    @IBOutlet weak var lblPickupToDropOffLocation: UILabel!
    
    @IBOutlet weak var lblDropOffToDeliveredLocation: UILabel!
    
    @IBOutlet weak var lblDeliveryChargesOffer: UILabel!
    
    @IBOutlet weak var lblDeliveryTime: UILabel!
    
    @IBOutlet weak var lblDeliveryMessage: UILabel!
    
    @IBOutlet weak var lblPickupName: UILabel!
    
    @IBOutlet weak var lblContactNumber: UILabel!
    
    @IBOutlet weak var lblInvoiceDetail: UILabel!
    
    @IBOutlet weak var lblDeliveryOfferAmount: UILabel!
    
    @IBOutlet weak var lblTax: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var lblAvgRating: UILabel!
    
    @IBOutlet weak var btnGo: UIButton!
    
    @IBOutlet weak var btnInvoiceCreated: UIButton!
    
    @IBOutlet weak var btnArrived: UIButton!
    
    @IBOutlet weak var btnDone: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
