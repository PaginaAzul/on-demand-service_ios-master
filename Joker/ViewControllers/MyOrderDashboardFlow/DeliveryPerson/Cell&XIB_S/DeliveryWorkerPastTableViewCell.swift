//
//  DeliveryWorkerPastTableViewCell.swift
//  Joker
//
//  Created by Callsoft on 07/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import Cosmos

class DeliveryWorkerPastTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var lblOrderID: UILabel!
    
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    @IBOutlet weak var lblInvoiceDate: UILabel!
    
    @IBOutlet weak var lblDeliveryOffer: UILabel!
    
    @IBOutlet weak var lblTax: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var lblAvgRating: UILabel!
    
    @IBOutlet weak var lblInvoiceAmount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
