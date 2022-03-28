//
//  ProffessionalViewAllOrdersTableViewCell.swift
//  Joker
//
//  Created by abc on 01/02/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class ProffessionalViewAllOrdersTableViewCell: UITableViewCell {

    
    @IBOutlet weak var btnAcceptOffer: UIButton!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var lblAvgRating: UILabel!
    
    @IBOutlet weak var btnTotalRating: UIButton!
    
    @IBOutlet weak var lblDeliveryChargesOffer: UILabel!
    
    @IBOutlet weak var lblDeliveryMsg: UILabel!
    
    @IBOutlet weak var lblDeliveryTime: UILabel!
    
    @IBOutlet weak var lblPickupToDropoffLocation: UILabel!
    
    @IBOutlet weak var btnReject: UIButton!
    
    @IBOutlet weak var lblModeOfTransport: UILabel!
    
    @IBOutlet weak var btnViewProfile: UIButton!
    
    @IBOutlet weak var lblChargeOfferHeading: UILabel!
    
    @IBOutlet weak var lblMessageHeading: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblModeOfTransportHeading: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
