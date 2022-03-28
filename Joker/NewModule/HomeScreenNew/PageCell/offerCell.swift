//
//  offerCell.swift
//  Joker
//
//  Created by cst on 23/10/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit

class offerCell: UICollectionViewCell {

    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var mainView:UIView!
    
    var item: ExclusiveOffer?  {
        didSet{
            imgBanner.contentMode = .scaleAspectFill
            imgBanner.setImage(withImageId: item?.image ?? "", placeholderImage: UIImage(named: "food_icon")!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
