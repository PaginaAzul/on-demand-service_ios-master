//
//  MyDashboardDeliveryWorkerActiveTableViewCellAndXib.swift
//  Joker
//
//  Created by abc on 01/02/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class MyDashboardDeliveryWorkerActiveTableViewCellAndXib: UITableViewCell {
    //MARK: - Outlet
    
    @IBOutlet weak var btnWorkDone: UIButton!
    
    @IBOutlet weak var lblOrderId: UILabel!
    
    @IBOutlet weak var tapViewRating: UIButton!
    
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblAvgRating: UILabel!
    
    @IBOutlet weak var lblStartToPickupLocation: UILabel!
    
    @IBOutlet weak var lblPickupToDropoffLocation: UILabel!
    
    @IBOutlet weak var lblDropOffToDeliveredLocation: UILabel!
    
    @IBOutlet weak var lblContactNo: UILabel!
    
    @IBOutlet weak var lblOrderDetail: UILabel!
    
    @IBOutlet weak var lblInvoiceDate: UILabel!
    
    @IBOutlet weak var lblDeliveryOffer: UILabel!
    
    @IBOutlet weak var lblTax: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var btnGo: UIButton!
    
    @IBOutlet weak var btnCreateInvoice: UIButton!
    
    @IBOutlet weak var btnArrived: UIButton!
    
    @IBOutlet weak var btnDone: UIButton!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
