//
//  OfferViewTableViewCellAndXibTableViewCell.swift
//  Joker
//
//  Created by abc on 18/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class OfferViewTableViewCellAndXibTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var lblDescription: UILabel!
    
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
    
    @IBOutlet weak var lblContactNumber: UILabel!
    
    @IBOutlet weak var txtFldMsg: UITextField!
    
    @IBOutlet weak var txtFldDeliveryTime: UITextField!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        imgUser.layer.cornerRadius = imgUser.frame.width/2
        imgUser.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
