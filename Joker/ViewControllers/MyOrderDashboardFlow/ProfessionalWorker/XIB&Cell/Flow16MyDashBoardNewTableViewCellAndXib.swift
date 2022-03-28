//
//  Flow16MyDashBoardNewTableViewCellAndXib.swift
//  Joker
//
//  Created by abc on 01/02/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class Flow16MyDashBoardNewTableViewCellAndXib: UITableViewCell {
    //MARK: - Outlets
   // @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var btnMakeAnOffer: UIButton!
    
    @IBOutlet weak var lblOrderId: UILabel!
    
   // @IBOutlet weak var txtFieldNew: UITextField!
    
    @IBOutlet weak var btnViewRating: UIButton!
    
    @IBOutlet weak var lblDateAndTime: UILabel!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var lblAvgRating: UILabel!
    
    @IBOutlet weak var lblMyLocationToDropLocation: UILabel!
    
    @IBOutlet weak var lblOrderDetail: UILabel!
    
  //  @IBOutlet weak var lblContactNo: UILabel!
    
  //  @IBOutlet weak var txtMsg: UITextField!
    
 //   @IBOutlet weak var txtApproxTime: UITextField!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
