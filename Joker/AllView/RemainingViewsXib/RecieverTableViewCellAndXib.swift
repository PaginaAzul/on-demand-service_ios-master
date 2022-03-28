//
//  RecieverTableViewCellAndXib.swift
//  Joker
//
//  Created by abc on 02/02/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class RecieverTableViewCellAndXib: UITableViewCell {

    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblMessageText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        imgUser.layer.cornerRadius = imgUser.frame.size.height/2
        imgUser.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
