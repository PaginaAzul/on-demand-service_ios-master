//
//  ChooseYorTasteTableViewCell.swift
//  JustBite
//
//  Created by Aman on 14/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import UIKit

class ChooseYorTasteTableViewCell: UITableViewCell {

    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(info:AddOnDataModel,type:Int){
        
        self.lblDetails.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 14)
        self.lblPrice.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 14)
        
       
        self.lblDetails.text = info.name
        self.lblPrice.text = "USD \(info.price).00"
        
       
        if info.isSelected{
            
            print("Selected!!")
            
            self.lblDetails.textColor = AppColor.themeColor
            self.lblPrice.textColor = AppColor.themeColor
            
            imageView?.image = #imageLiteral(resourceName: "r_selected")
            
        }else{
            
            self.lblDetails.textColor = AppColor.placeHolderColor
            self.lblPrice.textColor = AppColor.placeHolderColor
            
            imageView?.image = #imageLiteral(resourceName: "r_unselected")
            
            print("Selected Not!!")
        }
       
    }
    
}
