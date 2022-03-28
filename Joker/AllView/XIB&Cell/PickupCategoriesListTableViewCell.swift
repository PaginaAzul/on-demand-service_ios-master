//
//  PickupCategoriesListTableViewCell.swift
//  Joker
//
//  Created by Dacall soft on 01/07/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import Cosmos

class PickupCategoriesListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgPlace: UIImageView!
    
    @IBOutlet weak var lblPlacename: UILabel!
    
    @IBOutlet weak var lblPlaceRating: UILabel!
    
    @IBOutlet weak var lblTotalRating: UILabel!
    
    @IBOutlet weak var viewRating: CosmosView!
    
    @IBOutlet weak var lblCategories: UILabel!
    
    @IBOutlet weak var lblOpenCloseStatus: UILabel!
    
    @IBOutlet weak var lblDistanceKm: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
