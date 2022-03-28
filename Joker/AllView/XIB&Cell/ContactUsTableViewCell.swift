//
//  ContactUsTableViewCell.swift
//  Joker
//
//  Created by Dacall soft on 22/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class ContactUsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var contentImg: UIImageView!
    
    @IBOutlet weak var contentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
