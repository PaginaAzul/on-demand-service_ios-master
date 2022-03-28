//
//  CartCollectionViewCellAndXib.swift
//  JustBite
//
//  Created by Aman on 14/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import UIKit

class CartCollectionViewCellAndXib: UICollectionViewCell {

    
    //MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    
    public func configureCollection(info:CategoryDataModel){ //Baad main model ka data lana hai
        
        lblTitle.text = info.name
        lblTitle.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 15)
        
        if info.isSelected == true{
            lblTitle.textColor = AppColor.themeColor
            viewBottom.backgroundColor = AppColor.themeColor
        }else{
            lblTitle.textColor = AppColor.placeHolderColor
            viewBottom.backgroundColor = AppColor.placeHolderColor
        }
    }

}
