//
//  InnerTableViewCell.swift
//  JustBite
//
//  Created by Aman on 16/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import UIKit

class InnerTableViewCell: UITableViewCell {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var btnCustomizeRef: UIButton!
    @IBOutlet weak var imgSymbol: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgVeg: UIImageView!
    
    var item:OrderData?{
        didSet{
            
            let prices = (item?.productData?.price?.description) as NSString?
            
            var strDescription = ""
            
            if item?.productData?.description?.count ?? 0 > 30{
                strDescription = item?.productData?.description?.prefix(30).description ?? "" + ".."
            }else{
                strDescription = item?.productData?.description ?? ""
            }
            
            lblDetails.attributedText = CommonClass.sharedInstance.attributedString(title: item?.productData?.productName ?? "" , title1: strDescription, subTitle: "\(getCurrencyFormat(amount: prices?.doubleValue ?? 0.0)) \(item?.productData?.currency == "Kz" ? "Kz" : "$")", delemit: "\n", sizeTitle: 15, sizeSubtitle: 16, titleColor: AppColor.placeHolderColor, SubtitleColor: AppColor.textColor, newText: "Yes")
            
            btnCustomizeRef.setTitle("\(item?.quantity ?? 0) x \(getCurrencyFormat(amount: prices?.doubleValue ?? 0.0)) \(item?.productData?.currency ?? "")", for: .normal)
            
            imgSymbol.isHidden = false
            
            if item?.productData?.productType == "Veg" {
                imgSymbol.image = #imageLiteral(resourceName: "veg_symbol")
                
            }else{
                imgSymbol.image = #imageLiteral(resourceName: "nonveg_symbol")
                
            }
            
            imgView.setImage(withImageId: item?.productData?.productImage ?? "", placeholderImage: #imageLiteral(resourceName: "food_icon"))
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
       
    }
    
    
    //Price Change Currancy
    
    func getCurrencyFormat(amount: Double) -> String
    {
        let amountFormatter = NumberFormatter()
        amountFormatter.numberStyle = .decimal ///ERROR
        amountFormatter.locale = NSLocale.system
        let price = amountFormatter.string(from: amount as NSNumber)! as NSString
        return String(price.description)
        //        return String(price.description.prefix(price.description.count - 3))
    }
    
}
