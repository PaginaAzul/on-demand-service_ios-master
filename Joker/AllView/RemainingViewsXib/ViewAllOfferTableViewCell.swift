//
//  ViewAllOfferTableViewCell.swift
//  Joker
//
//  Created by abc on 30/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class ViewAllOfferTableViewCell: UITableViewCell {

    @IBOutlet weak var btnAcceptOffer: UIButton!
    
    @IBOutlet weak var btnCancelOrder: UIButton!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblDeliveryOffer: UILabel!
    
    @IBOutlet weak var lblDeliveryMessage: UILabel!
    
    @IBOutlet weak var lblEstimatedDeliveryTime: UILabel!
    
    
    @IBOutlet weak var lblDeliveryPersonToPickupLocation: UILabel!
    
    @IBOutlet weak var lblPickupLocationToDropLocation: UILabel!
    
    @IBOutlet weak var btnTotalRating: UIButton!
    
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
