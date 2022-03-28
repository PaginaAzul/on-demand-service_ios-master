//
//  ReceiverMediaTableViewCell.swift
//  Joker
//
//  Created by Dacall soft on 04/06/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class ReceiverMediaTableViewCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var imgReceiverMedia: UIImageView!
    
    @IBOutlet weak var viewLocationHolder: UIView!
    
    @IBOutlet weak var lblLocationName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        imgUser.layer.cornerRadius = imgUser.frame.size.height/2
        imgUser.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
