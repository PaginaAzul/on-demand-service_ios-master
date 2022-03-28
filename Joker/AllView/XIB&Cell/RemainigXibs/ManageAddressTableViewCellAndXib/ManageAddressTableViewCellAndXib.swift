//
//  ManageAddressTableViewCellAndXib.swift
//  Joker
//
//  Created by abc on 22/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class ManageAddressTableViewCellAndXib: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var viewStack: UIStackView!
    
    @IBOutlet weak var imgAddress: UIImageView!
    
    @IBOutlet weak var viewContentHolder: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
