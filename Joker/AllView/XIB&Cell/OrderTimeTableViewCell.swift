//
//  OrderTimeTableViewCell.swift
//  Joker
//
//  Created by Callsoft on 22/01/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class OrderTimeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var viewSelectedLine: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
