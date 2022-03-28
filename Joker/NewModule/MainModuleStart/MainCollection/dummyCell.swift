//
//  dummyCell.swift
//  Joker
//
//  Created by User on 10/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit

class dummyCell: UICollectionViewCell {

    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var lblTitle:UILabel!
    
    var item:TopArrayModel?{
        didSet{
            imgView.image = item?.img
            lblTitle.text = item?.name
            imgView.contentMode = .scaleAspectFit
            lblTitle.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13.0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

struct TopArrayModel {
    var img:UIImage
    var name:String
}


