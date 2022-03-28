//
//  MoreTableViewCell.swift
//  Joker
//
//  Created by abc on 22/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class MoreTableViewCell: UITableViewCell {

    //MARK: - Outlet
    @IBOutlet weak var lblContain: UILabel!
    @IBOutlet weak var viewContains: UIView!
    
    @IBOutlet weak var imgSide: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
