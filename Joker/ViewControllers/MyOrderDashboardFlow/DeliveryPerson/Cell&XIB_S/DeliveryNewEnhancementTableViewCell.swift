//
//  DeliveryNewEnhancementTableViewCell.swift
//  Joker
//
//  Created by retina on 02/09/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class DeliveryNewEnhancementTableViewCell: UITableViewCell {

    @IBOutlet weak var lblOrderId: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var lblAvgRating: UILabel!
    
    @IBOutlet weak var btnViewAllRating: UIButton!
    @IBOutlet weak var lblMyLocationToPickup: UILabel!
    
    @IBOutlet weak var lblPickupToDropoff: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var btnMakeAnOffer: UIButton!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
