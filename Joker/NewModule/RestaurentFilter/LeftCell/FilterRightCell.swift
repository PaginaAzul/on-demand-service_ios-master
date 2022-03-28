//
//  FilterRightCell.swift
//  OWIN
//
//  Created by SinhaAirBook on 06/08/20.
//  Copyright © 2020 Mobulous. All rights reserved.
//

import UIKit

class FilterRightCell: UITableViewCell {

    @IBOutlet weak var btnCheck: UIButton!
    
    
    
//
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func btnCheckShow(_ sender:UIButton){
        
        if  sender.isSelected{
            sender.setImage(#imageLiteral(resourceName: "check_box_s"), for: .normal)
            sender.setTitleColor(#colorLiteral(red: 0.04062839597, green: 0.5208723545, blue: 0.7463775277, alpha: 1), for: .normal)
        }else{
            sender.setImage(#imageLiteral(resourceName: "check_box_un"), for: .normal)
            sender.setTitleColor(.darkGray, for: .normal)
        }
        
    }
    
    
}
