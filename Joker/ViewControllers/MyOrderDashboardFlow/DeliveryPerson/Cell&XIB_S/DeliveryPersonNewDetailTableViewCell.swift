//
//  DeliveryPersonNewDetailTableViewCell.swift
//  Joker
//
//  Created by retina on 02/09/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class DeliveryPersonNewDetailTableViewCell: UITableViewCell {
    //MARK: - Outlets
  
    
    @IBOutlet weak var btnMakeOffer: UIButton!
    
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var txtFieldNew: UITextField!
    
    @IBOutlet weak var btnViewRating: UIButton!
    
    @IBOutlet weak var lblDateTime: UILabel!
    
    @IBOutlet weak var lblAvgRating: UILabel!
    
    @IBOutlet weak var lblMeToPickupLocation: UILabel!
    
    @IBOutlet weak var lblMeToDropLocation: UILabel!
    
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var txtFldMsg: UITextField!
    
    @IBOutlet weak var txtFldDeliveryTime: UITextField!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var viewTrackUsingForDelivery: UIView!
    
    @IBOutlet weak var viewTrackUsingForProfessional: UIView!
    
    @IBOutlet weak var lblServiceDistance: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
