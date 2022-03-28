//
//  MenuItemTableViewCell.swift
//  JustBite
//
//  Created by Aman on 14/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    internal func configure(info:CategoryDataModel){
        self.lblDetails.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 15)
        self.lblPrice.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 15)
        self.lblDetails.textColor = AppColor.placeHolderColor
        self.lblPrice.textColor = AppColor.placeHolderColor
        self.lblDetails.text = info.name
        self.lblPrice.text = info.menuCount
      
    }
    
}
