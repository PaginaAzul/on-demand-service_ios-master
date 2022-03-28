//
//  MyOrderDashBoardProffessionalActiveTableViewCellAndXib.swift
//  Joker
//
//  Created by abc on 01/02/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class MyOrderDashBoardProffessionalActiveTableViewCellAndXib: UITableViewCell {

    //MARK: - Outlets
  //  @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var btnReportOrder: UIButton!
    
   // @IBOutlet weak var btnContactAdmin: UIButton!
    
   // @IBOutlet weak var btnCancelOrder: UIButton!
    
    @IBOutlet weak var lblOrderID: UILabel!
    
    @IBOutlet weak var lblNote: UILabel!
    
//    @IBOutlet weak var btnMessage: UIButton!
//
//
//    @IBOutlet weak var btnTrack: UIButton!
//
//    @IBOutlet weak var btnCall: UIButton!
    
    @IBOutlet weak var btnViewRating: UIButton!
    
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var lblAvgRating: UILabel!
    
    @IBOutlet weak var lblChargeOffer: UILabel!
    
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var lblWorkCompletionTime: UILabel!
    
    @IBOutlet weak var lblOrderDetail: UILabel!
    
    @IBOutlet weak var lblOrderDetailValue: UILabel!
    
    @IBOutlet weak var lblInvoiceDate: UILabel!
    
    @IBOutlet weak var lblDeliveryOffer: UILabel!
    
    @IBOutlet weak var lblTax: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var btnGo: UIButton!
    
    @IBOutlet weak var btnInvoiceCreated: UIButton!
    
    @IBOutlet weak var btnArrived: UIButton!
    
    @IBOutlet weak var btnDone: UIButton!
    
    @IBOutlet weak var lblStartToDropOffLocation: UILabel!
    
    @IBOutlet weak var lblDropOffToProfWorkingLocation: UILabel!
    
    @IBOutlet weak var lblProfessionalToDeliveredLocation: UILabel!
    
    @IBOutlet weak var lblCategory: UILabel!
    
    @IBOutlet weak var lblSubcategory: UILabel!
    
    @IBOutlet weak var lblStartHeading: UILabel!
    
    @IBOutlet weak var lblArrivedHeading: UILabel!
    
    @IBOutlet weak var lblProfessionalWorkingHeading: UILabel!
    
    @IBOutlet weak var lblDeliveredHeading: UILabel!
    
    @IBOutlet weak var lblChangeOfferHeading: UILabel!
    
    @IBOutlet weak var lblProfessionalMessageHeading: UILabel!
    
    @IBOutlet weak var lblWorkCompletionTimeHeading: UILabel!
    
    @IBOutlet weak var lblCategoryHeading: UILabel!
    
    @IBOutlet weak var lblSubcategoryHeading: UILabel!
    
    @IBOutlet weak var lblInvoiceDetailsHeading: UILabel!
    
    @IBOutlet weak var lblDeliveryOfferHeading: UILabel!
    
    @IBOutlet weak var lblTax5Percent: UILabel!
    
    @IBOutlet weak var lblTotalHeading: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
