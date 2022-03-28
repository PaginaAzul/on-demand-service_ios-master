//
//  InnerTableViewFooter.swift
//  JustBite
//
//  Created by Aman on 16/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import UIKit

class InnerTableViewFooter: UIView {

    @IBOutlet weak var locationBtn: UIButton!
    
    @IBOutlet weak var pickdataLbl: UILabel!
    @IBOutlet weak var pickdateLblValue: UILabel!
    
    @IBOutlet weak var pickUpTmeLbl: UILabel!
    @IBOutlet weak var pickUpTmeLblValue: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTotolPrice: UILabel!
   
    @IBOutlet weak var statusLbl: UILabel!
   
    @IBOutlet weak var lblPaymentMode: UILabel!
    
    @IBOutlet weak var statusLblValue: UILabel!
    @IBOutlet weak var btnViewMore:UIButton!
    
    @IBOutlet weak var btnReOrder: UIButton!
    
    @IBOutlet weak var lblResName: UILabel!
    
    @IBOutlet weak var lblTotolTopConstraint: NSLayoutConstraint!
    
    var item:DataGetOrder? {
        
        didSet{
            let str:NSAttributedString = CommonClass.sharedInstance.setStartStatusWithUnderLineText("View more".localized())
            btnViewMore.setAttributedTitle(str, for: .normal)
            
            lblAddress.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: item?.address ?? "", subTitle: "", delemit: " ", sizeTitle: 15, sizeSubtitle: 14, titleColor: UIColor.black, SubtitleColor: UIColor.black)
            
            lblResName.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: item?.sellerData?.name ?? "", subTitle: "", delemit: " ", sizeTitle: 15, sizeSubtitle: 15, titleColor: AppColor.textColor, SubtitleColor: UIColor.black)
            
            pickdataLbl.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: "Pick Up Date".localized(), subTitle: "", delemit: " ", sizeTitle: 14, sizeSubtitle: 14, titleColor: AppColor.textColor, SubtitleColor: AppColor.subtitleColor)
            
            pickdateLblValue.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: item?.deliveryDate ?? "", subTitle: "", delemit: " ", sizeTitle: 13, sizeSubtitle: 13, titleColor: AppColor.placeHolderColor, SubtitleColor: AppColor.placeHolderColor)
            
            pickUpTmeLbl.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: "Pick Up Time".localized(), subTitle: "", delemit: " ", sizeTitle: 14, sizeSubtitle: 14, titleColor: AppColor.textColor, SubtitleColor: AppColor.subtitleColor)
            
            let setTime = (item?.orderType == "Menu") ? "\(item?.excepetdDeliveryTime ?? 0 ) min" : "\(item?.deliveryTimeSlot ?? "")"
            
            pickUpTmeLblValue.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: setTime, subTitle: "", delemit: " ", sizeTitle: 13, sizeSubtitle: 13, titleColor: AppColor.placeHolderColor, SubtitleColor: AppColor.placeHolderColor)
            
            statusLbl.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: "Status".localized(), subTitle: "", delemit: " ", sizeTitle: 14, sizeSubtitle: 14, titleColor: AppColor.textColor, SubtitleColor: AppColor.subtitleColor)
            
            statusLblValue.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: (item?.status ?? "").localized(), subTitle: "", delemit: " ", sizeTitle: 15, sizeSubtitle: 12, titleColor: AppColor.darkGreenColor, SubtitleColor: UIColor.green)
            
            let myMutableStringPaymentMode = NSMutableAttributedString()
            
            let myMutableStringMode = NSAttributedString(string: "\("\("Payment Mode".localized()) : ")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 16.0)!, .foregroundColor : AppColor.textColor])
            
            
            let myMutableStringDeliveryMode = NSAttributedString(string: "\("Cash on Delivery".localized())", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 15.0)!, .foregroundColor :UIColor.black])
            
            myMutableStringPaymentMode.append(myMutableStringMode)
            
            myMutableStringPaymentMode.append(myMutableStringDeliveryMode)
            
            lblPaymentMode.attributedText = myMutableStringPaymentMode
            
            let myMutableStringTotalPrice = NSMutableAttributedString()
            
            
            
            let myMutableStringTotal = NSAttributedString(string: "\("Total Price".localized()) : ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 17.0)!, .foregroundColor :UIColor.darkGray])
            
            let toalPrice = (item?.totalPrice?.description) as NSString?
            
            let myMutableStringPriceValue = NSAttributedString(string: "\("\(getCurrencyFormat(amount: toalPrice?.doubleValue ?? 0.0)) Kz")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 17.0)!, .foregroundColor :UIColor.black])
            
            myMutableStringTotalPrice.append(myMutableStringTotal)
            
            myMutableStringTotalPrice.append(myMutableStringPriceValue)
            
            lblTotolPrice.attributedText = myMutableStringTotalPrice
            
            
        }
       
    }
    
    var itemOnGoing : DataGetOrder? {
        didSet {
            
            let str:NSAttributedString = CommonClass.sharedInstance.setStartStatusWithUnderLineText("View more".localized())
            btnViewMore.setAttributedTitle(str, for: .normal)
            
            lblAddress.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: itemOnGoing?.address ?? "", subTitle: "", delemit: " ", sizeTitle: 15, sizeSubtitle: 14, titleColor: UIColor.black, SubtitleColor: AppColor.placeHolderColor)
            lblResName.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: itemOnGoing?.sellerData?.name ?? "", subTitle: "", delemit: " ", sizeTitle: 15, sizeSubtitle: 15, titleColor: AppColor.textColor, SubtitleColor: UIColor.black)
            
            pickdataLbl.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: "Expected Delivery Time".localized(), subTitle: "", delemit: " ", sizeTitle: 14, sizeSubtitle: 14, titleColor: AppColor.textColor, SubtitleColor: AppColor.subtitleColor)
            
            pickdateLblValue.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: "\(itemOnGoing?.excepetdDeliveryTime ?? 0) min", subTitle: "", delemit: " ", sizeTitle: 13, sizeSubtitle: 13, titleColor: AppColor.placeHolderColor, SubtitleColor: AppColor.placeHolderColor)
            
            pickUpTmeLbl.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: "Delivery Person".localized(), subTitle: "", delemit: " ", sizeTitle: 14, sizeSubtitle: 14, titleColor: AppColor.textColor, SubtitleColor: AppColor.subtitleColor)
            
            pickUpTmeLblValue.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: itemOnGoing?.driverData?.name ?? "", subTitle: "", delemit: " ", sizeTitle: 13, sizeSubtitle: 13, titleColor: AppColor.placeHolderColor, SubtitleColor: AppColor.placeHolderColor)
            
            statusLbl.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: "Phone Number".localized(), subTitle: "", delemit: " ", sizeTitle: 14, sizeSubtitle: 14, titleColor: AppColor.textColor, SubtitleColor: AppColor.subtitleColor)
            
            statusLblValue.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: itemOnGoing?.driverData?.mobileNumber ?? "", subTitle: "", delemit: " ", sizeTitle: 13, sizeSubtitle: 13, titleColor: AppColor.placeHolderColor, SubtitleColor: AppColor.placeHolderColor)
            
            let myMutableStringPaymentMode = NSMutableAttributedString()
            
            let myMutableStringMode = NSAttributedString(string: "\("\("Payment Mode".localized()) : ")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 16.0)!, .foregroundColor : AppColor.textColor])
            
            
            let myMutableStringDeliveryMode = NSAttributedString(string: "\("Cash on Delivery".localized())", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 15.0)!, .foregroundColor :UIColor.black])
            
            myMutableStringPaymentMode.append(myMutableStringMode)
            
            myMutableStringPaymentMode.append(myMutableStringDeliveryMode)
            
            lblPaymentMode.attributedText = myMutableStringPaymentMode
            
            let myMutableStringTotalPrice = NSMutableAttributedString()
            
            let myMutableStringTotal = NSAttributedString(string: "\("\("Total Price".localized()) : ")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 17.0)!, .foregroundColor :UIColor.darkGray])
            
            let toalPricess = (itemOnGoing?.totalPrice?.description) as NSString?
            
            let myMutableStringPriceValue = NSAttributedString(string: "\("\(getCurrencyFormat(amount: toalPricess?.doubleValue ?? 0.0)) Kz")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 17.0)!, .foregroundColor :UIColor.black])
            
            myMutableStringTotalPrice.append(myMutableStringTotal)
            
            myMutableStringTotalPrice.append(myMutableStringPriceValue)
            
           lblTotolPrice.attributedText = myMutableStringTotalPrice
            
        }
    }
    
    
    var itemPast:DataGetOrder? {
        didSet{
            
            
            let str:NSAttributedString = CommonClass.sharedInstance.setStartStatusWithUnderLineText("View more".localized())
            btnViewMore.setAttributedTitle(str, for: .normal)
            
            
            let myMutableStringPaymentMode = NSMutableAttributedString()
            
            let myMutableStringMode = NSAttributedString(string: "\("\("Payment Mode".localized()) : ")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 16.0)!, .foregroundColor : AppColor.textColor])
            
            
            let myMutableStringDeliveryMode = NSAttributedString(string: "\("Cash on Delivery".localized())", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 15.0)!, .foregroundColor :UIColor.black])
            
            myMutableStringPaymentMode.append(myMutableStringMode)
            
            myMutableStringPaymentMode.append(myMutableStringDeliveryMode)
            
            lblPaymentMode.attributedText = myMutableStringPaymentMode
            
            let myMutableStringTotalPrice = NSMutableAttributedString()
            
            let myMutableStringTotal = NSAttributedString(string: "\("\("Total Price".localized()) : ")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 17.0)!, .foregroundColor :UIColor.darkGray])
            
            let toalPrices = (itemPast?.totalPrice?.description) as NSString?
            
            let myMutableStringPriceValue = NSAttributedString(string:  "\("\(getCurrencyFormat(amount: toalPrices?.doubleValue ?? 0.0)) Kz")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 17.0)!, .foregroundColor :UIColor.black])
            
            myMutableStringTotalPrice.append(myMutableStringTotal)
            
            myMutableStringTotalPrice.append(myMutableStringPriceValue)
            
            lblTotolPrice.attributedText = myMutableStringTotalPrice
            
            lblResName.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: itemPast?.driverData?.name ?? "", subTitle: "", delemit: " ", sizeTitle: 15, sizeSubtitle: 15, titleColor: AppColor.textColor, SubtitleColor: UIColor.black)
           
            pickdataLbl.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: "Delivery Time".localized(), subTitle: "", delemit: " ", sizeTitle: 14, sizeSubtitle: 14, titleColor: AppColor.textColor, SubtitleColor: AppColor.subtitleColor)
          
            pickdateLblValue.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: "\(itemPast?.excepetdDeliveryTime ?? 0 ) min", subTitle: "", delemit: " ", sizeTitle: 13, sizeSubtitle: 13, titleColor: AppColor.placeHolderColor, SubtitleColor: AppColor.placeHolderColor)
            
            lblAddress.attributedText = CommonClass.sharedInstance.attributedStringOnGing(title: itemPast?.address ?? "" , subTitle: "", delemit: " ", sizeTitle: 15, sizeSubtitle: 14, titleColor: UIColor.black, SubtitleColor: UIColor.black)
            
            statusLbl.isHidden = true
            statusLblValue.isHidden = true
            
            pickUpTmeLbl.isHidden = true
            pickUpTmeLblValue.isHidden = true
            
            
        }
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
