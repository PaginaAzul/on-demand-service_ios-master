//
//  CategoriesCollectionViewCell.swift
//  Joker
//
//  Created by retina on 16/06/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblCategoriesName: UILabel!
    @IBOutlet weak var lblCategoryNameHeight:NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var smallCollectionView: UICollectionView!
    
    var itemCuisines: DataCuisines? {
        didSet{
            
            imgView.setImage(withImageId: itemCuisines?.image ?? "", placeholderImage: #imageLiteral(resourceName: "catImageNew"))
            lblCategoriesName.text = itemCuisines?.name ?? ""
            lblCategoriesName.textAlignment = .center
            //imgView.contentMode = .redraw
            
            imgView.cornerRadius = 8
            imgView.layer.masksToBounds = true
            
            mainView.layer.cornerRadius = 8
            mainView.layer.borderWidth = 1.0
            mainView.layer.borderColor = UIColor.white.cgColor
            
            mainView.layer.backgroundColor = UIColor.white.cgColor
            mainView.layer.shadowColor = UIColor.lightGray.cgColor
            
            mainView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            mainView.layer.shadowRadius = 2.0
            mainView.layer.shadowOpacity = 1.0
            mainView.layer.masksToBounds = false

        }

    }
    
    var itemFromBanner : HomeBanner?{
        didSet{
            
            imgView.setImage(withImageId: itemFromBanner?.image ?? "", placeholderImage: #imageLiteral(resourceName: "catImageNew"))
           // lblCategoriesName.isHidden = true
            lblCategoriesName.textAlignment = .left
            imgView.contentMode = .redraw

        }
    }
  
    var itemFromMainServices: MainService?{
        didSet{
            
            imgView.setImage(withImageId: itemFromMainServices?.image ?? "", placeholderImage: #imageLiteral(resourceName: "catImageNew"))
                        
            lblCategoriesName.text =  itemFromMainServices?.englishName ?? ""
            
            lblCategoriesName.textAlignment = .left
            imgView.contentMode = .redraw

        }
    }
    
    
    
    var categoryData:GroceryData?{
        didSet{
            
            lblCategoriesName.text = categoryData?.name
            
            imgView.setImage(withImageId: categoryData?.image ?? "", placeholderImage: #imageLiteral(resourceName: "catImageNew"))
            imgView.cornerRadius = 8
            imgView.layer.masksToBounds = true
            
            mainView.layer.cornerRadius = 8
            mainView.layer.borderWidth = 1.0
            mainView.layer.borderColor = UIColor.white.cgColor
            
            mainView.layer.backgroundColor = UIColor.white.cgColor
            mainView.layer.shadowColor = UIColor.lightGray.cgColor
            
            mainView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            mainView.layer.shadowRadius = 2.0
            mainView.layer.shadowOpacity = 1.0
            mainView.layer.masksToBounds = false
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }
    
    
    
}

