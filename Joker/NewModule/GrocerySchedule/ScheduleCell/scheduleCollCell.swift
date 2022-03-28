//
//  scheduleCollCell.swift
//  Joker
//
//  Created by User on 05/01/21.
//  Copyright © 2021 Callsoft. All rights reserved.
//

import UIKit

class scheduleCollCell: UICollectionViewCell {

    
    @IBOutlet weak var lblSlotTime: UILabel!
    @IBOutlet weak var mainView: UIView!

    var timingItem:String?{
        didSet{
            lblSlotTime.text = timingItem
        }
    }
    /*
    
    var backcolor:Bool?{
        
        didSet{
            mainView.backgroundColor = (backcolor == true) ? AppColor.themeColor : AppColor.whiteColor

        }
        

    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
     //   lblSlotTime.text = "timingItem"

        mainView.layer.cornerRadius = 8
        mainView.layer.borderWidth = 1.0
        mainView.layer.borderColor = UIColor.lightGray.cgColor
        
        mainView.layer.backgroundColor = UIColor.white.cgColor
        mainView.layer.masksToBounds = false
        
       
        
        // Initialization code
        
    }

    
    
}
