//
//  MyWalletTableViewCellAndXib.swift
//  Joker
//
//  Created by abc on 23/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class MyWalletTableViewCellAndXib: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblMiddle: UILabel!
    @IBOutlet weak var lblTotalRate: UILabel!
    @IBOutlet weak var imgViewHeader: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
