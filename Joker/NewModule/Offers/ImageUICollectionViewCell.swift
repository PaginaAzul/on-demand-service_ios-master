//
//  ImageUICollectionViewCell.swift
//  CHTWaterfallSwift
//
//  Created by Sophie Fader on 3/21/15.
//  Copyright (c) 2015 Sophie Fader. All rights reserved.
//

import UIKit

class ImageUICollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var blackView: UIView!
    
    var productOfferItem:OfferCategoryData? {
        didSet {
            
            image.setImage(withImageId: productOfferItem?.image ?? "", placeholderImage: #imageLiteral(resourceName: "catImageNew"))
            lblCategory.text = productOfferItem?.name ?? ""
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        image.cornerRadius = 6
        image.layer.masksToBounds = true
        
        blackView.cornerRadius = 6
        blackView.layer.masksToBounds = true
        layer.cornerRadius = 6
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.clear.cgColor
        
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.clear.cgColor
        
        
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        
    }
    
}
