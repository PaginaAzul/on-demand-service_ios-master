//
//  SenderMediaTableViewCell.swift
//  Joker
//
//  Created by Dacall soft on 04/06/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class SenderMediaTableViewCell: UITableViewCell {

    @IBOutlet weak var imgSender: UIImageView!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var imgSenderMedia: UIImageView!
    
    @IBOutlet weak var viewLocationHolder: UIView!
    
    @IBOutlet weak var lblLocationName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        imgSender.layer.cornerRadius = imgSender.frame.size.height/2
        imgSender.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
