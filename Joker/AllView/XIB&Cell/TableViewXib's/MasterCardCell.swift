//
//  MasterCardTableViewCell.swift
//  Joker
//
//  Created by Apple on 23/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class MasterCardCell: UITableViewCell {

    @IBOutlet weak var cardImg: UIImageView!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var checkBoximg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
