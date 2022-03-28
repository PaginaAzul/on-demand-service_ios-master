//
//  TableViewCell.swift
//  Joker
//
//  Created by SinhaAirBook on 07/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {

    //MARK:- Outlet
    @IBOutlet weak var lbl_ItemName:UILabel!
    @IBOutlet weak var lbl_ItemQuantity:UILabel!
    
    var item:MenuItemData?{
        didSet{
            lbl_ItemName.text = item?.cuisine
            lbl_ItemQuantity.text = item?.count?.description
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
