//
//  OfferTableViewCellAndXib.swift
//  JustBite
//
//  Created by Aman on 16/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import UIKit
import Foundation

/////// New code


class OfferTableViewCellAndXib : UITableViewCell {
    

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblValidity: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var strikePrice: UILabel!
    @IBOutlet weak var addToCartWidth: NSLayoutConstraint!
    @IBOutlet weak var addToCartHeight: NSLayoutConstraint!
    @IBOutlet weak var btnAddToCart: UIButton!
    
    @IBOutlet weak var vwMainHeight: NSLayoutConstraint!

    @IBOutlet weak var lblWas: UILabel!{
        didSet{
            lblWas.text = "Was".localized()
        }
    }
    @IBOutlet weak var lblNow: UILabel!{
        didSet{
            lblNow.text = "Now".localized()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        CommonClass.sharedInstance.provideCustomCornarRadius(btnRef: viewMain, radius: 5)
        CommonClass.sharedInstance.provideShadowFourSide(btnRef: viewMain)
        CommonClass.sharedInstance.provideShadowFourSide(btnRef: imgThumbnail)
        btnAddToCart.setTitle("Add to cart".localized(), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    public func configureWith(info: DataOffer ) {
       
        if MyHelper.isValidNewOfferPeriod(endDate: info.endDate ?? ""){
            self.viewMain.isHidden = false
            lblValidity.text = "\("This offer is valid from".localized()) \(dateTimeConversion(createdAt: info.startDate ?? "")) \("till".localized()) \(dateTimeConversion(createdAt: info.endDate ?? ""))"
            
            imgThumbnail.setImage(withImageId: info.productImage ?? "", placeholderImage: #imageLiteral(resourceName: "catImageNew"))

            print("Localize.currentLanguage() At Offer List VC \(Localize.currentLanguage())")
            
            if Localize.currentLanguage() == "en" {
                
            } else {
                
                self.addToCartWidth.constant =  150

            }
            
            lblTitle.attributedText = CommonClass.sharedInstance.setOfferList(productName: info.productName ?? "", shopeName: info.resAndStoreId?.name ?? "", productDetail: info.description ?? "", price: "\(info.price ?? 0) \(info.currency ?? "")", lastPrice: "\(info.offerPrice ?? 0) \(info.currency ?? "")")
            
            lblTitle.numberOfLines = 4
            
            let infoOfferPricee = (info.offerPrice?.description) as NSString?
            let infoPricee = (info.price?.description) as NSString?
            
            lblPrice.attributedText = makeSlashText(price: "\(infoOfferPricee ?? "") \(info.currency ?? "")", strikeText: "\(infoPricee ?? "") \(info.currency ?? "")")
            
            let locOffer = (info.offerPrice?.description) as NSString?
            let locPrice = (info.price?.description) as NSString?
            
            lblPrice.text = "\(getCurrencyFormat(amount: locOffer?.doubleValue ?? 0.0)) \(info.currency ?? "")"
            strikePrice.text = "\(getCurrencyFormat(amount: locPrice?.doubleValue ?? 0.0)) \(info.currency ?? "")"
            
    //        let informationPrice = (info.price?.description) as NSString?
            
            let infoCurrency = (info.currency?.description) as NSString?

            let example = NSAttributedString(string: "\(getCurrencyFormat(amount: locPrice?.doubleValue ?? 0)) \(info.currency ?? "")").withStrikeThrough(1)
            strikePrice.attributedText = example
        }
        else
        {
            self.addToCartHeight.constant = 0
            self.vwMainHeight.constant = 0
            self.viewMain.isHidden = true
            
        }
        
    }
    
    //MARK:- change currancy
    
    func getCurrencyFormat(amount: Double) -> String{
        let amountFormatter = NumberFormatter()
        amountFormatter.numberStyle = .decimal ///ERROR
        amountFormatter.locale = NSLocale.system
        let price = amountFormatter.string(from: amount as NSNumber)! as NSString
        return String(price.description)
//        return String(price.description.prefix(price.description.count - 3))
    }
    
    
}

func makeSlashText(price:String , strikeText:String ) -> NSAttributedString {
    
    
    let myMutableString1 = NSMutableAttributedString()
    
    let normalText1 = "\(price) "
    
    let myMutableString2 = NSAttributedString(string: "\(normalText1)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 14.0)!, .foregroundColor :AppColor.themeColor])
    
//    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: strikeText)
//
//
//    let myMutableString3 = NSAttributedString(string: "\(attributeString) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :UIColor.lightGray])
    
    
 //   attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
    
    myMutableString1.append(myMutableString2)
    //myMutableString1.append(myMutableString3)
   
    return myMutableString1
    
}

extension NSAttributedString {

    /// Returns a new instance of NSAttributedString with same contents and attributes with strike through added.
     /// - Parameter style: value for style you wish to assign to the text.
     /// - Returns: a new instance of NSAttributedString with given strike through.
     func withStrikeThrough(_ style: Int = 1) -> NSAttributedString {
         let attributedString = NSMutableAttributedString(attributedString: self)
         attributedString.addAttribute(.strikethroughStyle,
                                       value: style,
                                       range: NSRange(location: 0, length: string.count))
         return NSAttributedString(attributedString: attributedString)
     }
}
