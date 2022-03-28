//
//  CartTableViewCellAndXib.swift
//  JustBite
//
//  Created by Aman on 13/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import UIKit
import Foundation


////////New Code
enum CellType:String{
    case grocery
    case restaurant
}
protocol UpdateCartCountProtocol {
    func getCountCart(_ flag:Bool)
}


extension String {
    func removingLeadingSpaces() -> String {
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: .whitespaces) }) else {
            return self
        }
        return String(self[index...])
    }
}

class CartTableViewCellAndXib: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var btnMinusRef: UIButton!
    @IBOutlet weak var btnQtyRef: UIButton!
    @IBOutlet weak var btnPlusRef: UIButton!
    @IBOutlet weak var btnCustomizeRef: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var strikePrice: UILabel!
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
    
    @IBOutlet weak var lblWasLeading: NSLayoutConstraint!
    @IBOutlet weak var imgVerWidth: NSLayoutConstraint!
    @IBOutlet weak var imgVerHeight: NSLayoutConstraint!
    @IBOutlet weak var lblVAlidTop: NSLayoutConstraint!
    @IBOutlet weak var imgTypeTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblOfferValid: UILabel!
    @IBOutlet weak var priceCutView: UIView!
    
    
    //MARK:- Variable
    var vc = UIViewController()
    var showQunatity = Bool()
    var comgFromOffer = Bool()
    let apiHandle = ApiHandler()
    var currentCartQuantity = Int()
    var productID = String()
    var quantity = Int()
    var price = Int()
    var delegatePrice: RefreshPriceDelegate?
    var updateCartCountDelegate:UpdateCartCountProtocol?
    var closingTime:String?
    var cellType:CellType?
    var productListModel:ProductList? {
        
        didSet {
            cellType = productListModel?.type == "Product" ? CellType.grocery:CellType.restaurant
            print("productListModel?.type.............\(productListModel?.type)")
            self.quantity = productListModel?.quantity ?? 0
            self.productID = "\(productListModel?.Id ?? "")"
            
            if MyHelper.isValidNewOfferPeriod(endDate: self.productListModel?.endDate ?? "") {
                price = self.productListModel?.offerPrice ?? 0
            }
            else
            {
                price = self.productListModel?.price ?? 0
            }
            
            self.currentCartQuantity = productListModel?.cartData?.quantity ?? 0
            
            btnQtyRef.setTitle(self.currentCartQuantity.description, for: .normal)


            let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
            let myMutableString = NSMutableAttributedString()
            let myMutableString1 = NSAttributedString(string: "\(productListModel?.productName ?? "")\("\n")\("")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 15)!, .foregroundColor :UIColor.black])

            let quantityyy = (productListModel?.quantity?.description) as NSString?
            var strDescription = ""

            if productListModel?.description?.count ?? 0 > 30 {
                strDescription = productListModel?.description?.prefix(30).description ?? "" + ".."
            }else{
                strDescription = productListModel?.description ?? ""
            }
//
//            let myMutableString2 = NSAttributedString(string: "\(strDescription)\n\("Quantity".localized()) : \(getCurrencyFormat(amount: quantityyy?.doubleValue ?? 0.0))", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13)!, .foregroundColor :UIColor.darkGray])
//
//            myMutableString.append(myMutableString1)
//            myMutableString.append(myMutableString2)
//
//            // *** Create instance of `NSMutableParagraphStyle`
//            let paragraphStyle = NSMutableParagraphStyle()
//
//            paragraphStyle.alignment = .left
//
//            // *** set LineSpacing property in points ***
//            paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
//
//            lblDetails.numberOfLines = 0
//            // *** Apply attribute to string ***
//            myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
//
//            lblDetails.attributedText = myMutableString
//
            print("Particular status = ",productListModel?.oStatus ?? "")
            if productListModel?.oStatus == "Inactive"{
                let localPrice = productListModel?.price?.description as NSString?

                lblWas.text = "\(productListModel?.currency == "Kz" ? " \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))")"
                lblWas.font = UIFont(name: App.Fonts.SegoeUI.Bold, size: 22)!
                lblWas.textColor = AppColor.textColor
                lblPrice.isHidden = true
                strikePrice.isHidden = true
                lblNow.isHidden = true
                lblOfferValid.isHidden = true
                lblVAlidTop.constant = 0
                lblOfferValid.text = ""
                lblWas.text = ""
                debugPrint(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))
                
                    let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
                    let myMutableString = NSMutableAttributedString()
                let myMutableString1 = NSAttributedString(string: "\(productListModel?.productName ?? "")\("\n")\("")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 15)!, .foregroundColor :UIColor.black])
                    
                    let quantityyy = (productListModel?.quantity?.description) as NSString?
                    var strDescription = ""
                    
                    if productListModel?.description?.count ?? 0 > 30 {
                        strDescription = productListModel?.description?.prefix(30).description ?? "" + ".."
                    }else{
                        strDescription = productListModel?.description ?? ""
                    }
                    
            let myMutableString2 = NSAttributedString(string: "\(strDescription)\n\("Quantity".localized()) : \(getCurrencyFormat(amount: quantityyy?.doubleValue ?? 0.0))\n\(productListModel?.currency == "Kz" ? "\(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13)!, .foregroundColor :UIColor.darkGray])
                    
                    myMutableString.append(myMutableString1)
                    myMutableString.append(myMutableString2)
                    
                    // *** Create instance of `NSMutableParagraphStyle`
                    let paragraphStyle = NSMutableParagraphStyle()
                    
                    paragraphStyle.alignment = .left
                    
                    // *** set LineSpacing property in points ***
                    paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
                    
                    lblDetails.numberOfLines = 0
                    // *** Apply attribute to string ***
                    myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
                    
                    lblDetails.attributedText = myMutableString

            }else{
                print("else block executed ..............")
                if productListModel?.sellerData?.offerStatus == "Active"{
                    if MyHelper.isValidNewOfferPeriod(endDate: productListModel?.endDate ?? ""){
                        let offerPriceLocal = productListModel?.offerPrice?.description as NSString?
                        let lblPriceText = "\(productListModel?.currency == "Kz" ? "\(getCurrencyFormat(amount: offerPriceLocal?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: offerPriceLocal?.doubleValue ?? 0.0))")"
                        
                        lblPrice.text = lblPriceText.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        let pris = productListModel?.price?.description as NSString?
                        
                        strikePrice.text = "\(productListModel?.currency == "Kz" ? " \(getCurrencyFormat(amount: pris?.doubleValue ?? 0.0)) Kz" : "$\(getCurrencyFormat(amount: pris?.doubleValue ?? 0.0))")"
                        
                        lblOfferValid.text = "\("This offer is valid from".localized()) \(dateTimeConversion(createdAt: productListModel?.startDate ?? "")) \("till".localized()) \(dateTimeConversion(createdAt: productListModel?.endDate ?? ""))"
                        
                        
                        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
                        let myMutableString = NSMutableAttributedString()
                        let myMutableString1 = NSAttributedString(string: "\(productListModel?.productName ?? "")\("\n")\("")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 15)!, .foregroundColor :UIColor.black])
                        
                        let quantityyy = (productListModel?.quantity?.description) as NSString?
                        var strDescription = ""
                        
                        if productListModel?.description?.count ?? 0 > 30 {
                            strDescription = productListModel?.description?.prefix(30).description ?? "" + ".."
                        }else{
                            strDescription = productListModel?.description ?? ""
                        }
                        
                        let myMutableString2 = NSAttributedString(string: "\(strDescription)\n\("Quantity".localized()) : \(getCurrencyFormat(amount: quantityyy?.doubleValue ?? 0.0))", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13)!, .foregroundColor :UIColor.darkGray])
                        
                        myMutableString.append(myMutableString1)
                        myMutableString.append(myMutableString2)
                        
                        // *** Create instance of `NSMutableParagraphStyle`
                        let paragraphStyle = NSMutableParagraphStyle()
                        
                        paragraphStyle.alignment = .left
                        
                        // *** set LineSpacing property in points ***
                        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
                        
                        lblDetails.numberOfLines = 0
                        // *** Apply attribute to string ***
                        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
                        
                        lblDetails.attributedText = myMutableString
                        priceCutView.isHidden = false
                        
                    }else{
                        let localPrice = productListModel?.price?.description as NSString?
                        
                        lblWas.text = "\(productListModel?.currency == "Kz" ? " \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))")"
                        lblWas.font = UIFont(name: App.Fonts.SegoeUI.Bold, size: 22)!
                        lblWas.textColor = AppColor.textColor
                        lblPrice.isHidden = true
                        strikePrice.isHidden = true
                        lblNow.isHidden = true
                        lblOfferValid.isHidden = true
                        lblVAlidTop.constant = 0
                        lblOfferValid.text = ""
                        lblWas.text = ""
                        debugPrint(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))
                        
                        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
                        let myMutableString = NSMutableAttributedString()
                        let myMutableString1 = NSAttributedString(string: "\(productListModel?.productName ?? "")\("\n")\("")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 15)!, .foregroundColor :UIColor.black])
                        
                        let quantityyy = (productListModel?.quantity?.description) as NSString?
                        var strDescription = ""
                        
                        if productListModel?.description?.count ?? 0 > 30 {
                            strDescription = productListModel?.description?.prefix(30).description ?? "" + ".."
                        }else{
                            strDescription = productListModel?.description ?? ""
                        }
                        
                        let myMutableString2 = NSAttributedString(string: "\(strDescription)\n\("Quantity".localized()) : \(getCurrencyFormat(amount: quantityyy?.doubleValue ?? 0.0))\n\(productListModel?.currency == "Kz" ? "\(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13)!, .foregroundColor :UIColor.darkGray])
                        
                        myMutableString.append(myMutableString1)
                        myMutableString.append(myMutableString2)
                        
                        // *** Create instance of `NSMutableParagraphStyle`
                        let paragraphStyle = NSMutableParagraphStyle()
                        
                        paragraphStyle.alignment = .left
                        
                        // *** set LineSpacing property in points ***
                        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
                        
                        lblDetails.numberOfLines = 0
                        // *** Apply attribute to string ***
                        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
                        
                        lblDetails.attributedText = myMutableString

                    }
                }
                    else
                {
                        let localPrice = productListModel?.price?.description as NSString?

                        lblWas.text = "\(productListModel?.currency == "Kz" ? " \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))")"
                        lblWas.font = UIFont(name: App.Fonts.SegoeUI.Bold, size: 22)!
                        lblWas.textColor = AppColor.textColor
                        lblPrice.isHidden = true
                        strikePrice.isHidden = true
                        lblNow.isHidden = true
                        lblOfferValid.isHidden = true
                        lblVAlidTop.constant = 0
                        lblOfferValid.text = ""
                        lblWas.text = ""
                        debugPrint(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))
                        
                            let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
                            let myMutableString = NSMutableAttributedString()
                            let myMutableString1 = NSAttributedString(string: "\(productListModel?.productName ?? "")\("\n")\("")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 15)!, .foregroundColor :UIColor.black])
                            
                            let quantityyy = (productListModel?.quantity?.description) as NSString?
                            var strDescription = ""
                            
                            if productListModel?.description?.count ?? 0 > 30 {
                                strDescription = productListModel?.description?.prefix(30).description ?? "" + ".."
                            }else{
                                strDescription = productListModel?.description ?? ""
                            }
                            
                            let myMutableString2 = NSAttributedString(string: "\(strDescription)\n\("Quantity".localized()) : \(getCurrencyFormat(amount: quantityyy?.doubleValue ?? 0.0))\n\(productListModel?.currency == "Kz" ? "\(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13)!, .foregroundColor :UIColor.darkGray])
                            
                            myMutableString.append(myMutableString1)
                            myMutableString.append(myMutableString2)
                            
                            // *** Create instance of `NSMutableParagraphStyle`
                            let paragraphStyle = NSMutableParagraphStyle()
                            
                            paragraphStyle.alignment = .left
                            
                            // *** set LineSpacing property in points ***
                            paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
                            
                            lblDetails.numberOfLines = 0
                            // *** Apply attribute to string ***
                            myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
                            
                            lblDetails.attributedText = myMutableString


                    }

//                let pricc = (productListModel?.price?.description ?? "") as NSString
//                let setText = "\(productListModel?.currency == "Kz" ? " \(getCurrencyFormat(amount: pricc.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: pricc.doubleValue ?? 0.0))")"
//                strikePrice.text =  setText.trimmingCharacters(in: .whitespacesAndNewlines)
//                lblOfferValid.text = "\("This offer is valid from".localized()) \(dateTimeConversion(createdAt: productListModel?.createdAt ?? "")) \("till".localized()) \(dateTimeConversion(createdAt: productListModel?.endDate ?? ""))"
//
                
            }
            
            imgView.setImage(withImageId: productListModel?.productImage ?? "", placeholderImage: #imageLiteral(resourceName: "food_icon"))
            
            
        }
        
    }
    
    var restListModel:NewRestaurantList? {
        
        didSet {
            cellType = restListModel?.type == "Product" ? CellType.grocery:CellType.restaurant
            print("restListModel?.type.............\(restListModel?.type)")
            self.quantity = restListModel?.quantity ?? 0
            self.productID = "\(restListModel?.Id ?? "")"
            
            if MyHelper.isValidNewOfferPeriod(endDate: self.restListModel?.endDate ?? "") {
                price = self.restListModel?.offerPrice ?? 0
            }
            else
            {
                price = self.restListModel?.price ?? 0
            }
            
            self.currentCartQuantity = restListModel?.cartData?.quantity ?? 0
            imgVerHeight.constant = 14
            btnQtyRef.setTitle(self.currentCartQuantity.description, for: .normal)
            
            if restListModel?.oStatus == "Inactive"{
                let localPrice = restListModel?.price?.description as NSString?
                
                lblWas.text = "\(restListModel?.currency == "Kz" ? " \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))")"
                lblWas.font = UIFont(name: App.Fonts.SegoeUI.Bold, size: 22)!
                lblWas.textColor = AppColor.textColor
                lblPrice.isHidden = true
                strikePrice.isHidden = false
                lblNow.isHidden = true
                lblOfferValid.isHidden = true
                lblVAlidTop.constant = 0
                lblOfferValid.text = ""
                lblWas.text = ""
                debugPrint(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))
                let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
                let myMutableString = NSMutableAttributedString()
                let myMutableString1 = NSAttributedString(string: "\(restListModel?.productName ?? "")\("\n")\("")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 15)!, .foregroundColor :UIColor.black])
                
                let quantityyy = (restListModel?.quantity?.description) as NSString?
                //let quantityyy_price = (restListModel?.price?.description)
                var strDescription = ""
                
                if restListModel?.description?.count ?? 0 > 30 {
                    strDescription = restListModel?.description?.prefix(30).description ?? "" + ".."
                }else{
                    strDescription = restListModel?.description ?? ""
                }
                
                let myMutableString2 = NSAttributedString(string: "\(strDescription)\n\("Quantity".localized()) : \(getCurrencyFormat(amount: quantityyy?.doubleValue ?? 0.0))", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13)!, .foregroundColor :UIColor.darkGray])
                
                myMutableString.append(myMutableString1)
                myMutableString.append(myMutableString2)
                
                // *** Create instance of `NSMutableParagraphStyle`
                let paragraphStyle = NSMutableParagraphStyle()
                
                paragraphStyle.alignment = .left
                
                // *** set LineSpacing property in points ***
                paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
                
                lblDetails.numberOfLines = 0
                // *** Apply attribute to string ***
                myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
                
                lblDetails.attributedText = myMutableString
                
                let myMutableString3 = NSAttributedString(string: "\(restListModel?.currency == "Kz" ? "\(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13)!, .foregroundColor :UIColor.darkGray])
                
                strikePrice.attributedText = myMutableString3
                
            }else{
                print("else block executed ..............")
                if restListModel?.sellerData?.offerStatus == "Active"{
                    print(restListModel?.endDate)
                    if MyHelper.isValidNewOfferPeriod(endDate: restListModel?.endDate ?? ""){
                       
                        let offerPriceLocal = restListModel?.offerPrice?.description as NSString?
                        let lblPriceText = "\(restListModel?.currency == "Kz" ? "\(getCurrencyFormat(amount: offerPriceLocal?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: offerPriceLocal?.doubleValue ?? 0.0))")"
                        
                        lblPrice.text = lblPriceText.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        let pris = self.restListModel?.price?.description as NSString?
                        
                        strikePrice.text = "\(self.restListModel?.currency == "Kz" ? " \(getCurrencyFormat(amount: pris?.doubleValue ?? 0.0)) Kz" : "$\(getCurrencyFormat(amount: pris?.doubleValue ?? 0.0))")"
                        
                        lblOfferValid.text = "\("This offer is valid from".localized()) \(dateTimeConversion(createdAt: self.restListModel?.startDate ?? "")) \("till".localized()) \(dateTimeConversion(createdAt: self.restListModel?.endDate ?? ""))"
                        
                        priceCutView.isHidden = false
                        
                        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
                        let myMutableString = NSMutableAttributedString()
                        let myMutableString1 = NSAttributedString(string: "\(restListModel?.productName ?? "")\("\n")\("")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 15)!, .foregroundColor :UIColor.black])
                        
                        let quantityyy = (restListModel?.quantity?.description) as NSString?
                        var strDescription = ""
                        
                        if restListModel?.description?.count ?? 0 > 30 {
                            strDescription = restListModel?.description?.prefix(30).description ?? "" + ".."
                        }else{
                            strDescription = restListModel?.description ?? ""
                        }
                        
                        let myMutableString2 = NSAttributedString(string: "\(strDescription)\n\("Quantity".localized()) : \(getCurrencyFormat(amount: quantityyy?.doubleValue ?? 0.0))", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13)!, .foregroundColor :UIColor.darkGray])
                        
                        myMutableString.append(myMutableString1)
                        myMutableString.append(myMutableString2)
                        
                        // *** Create instance of `NSMutableParagraphStyle`
                        let paragraphStyle = NSMutableParagraphStyle()
                        
                        paragraphStyle.alignment = .left
                        
                        // *** set LineSpacing property in points ***
                        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
                        
                        lblDetails.numberOfLines = 0
                        // *** Apply attribute to string ***
                        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
                        
                        lblDetails.attributedText = myMutableString
                        
                        
                        
                    }else{
                        let localPrice = restListModel?.price?.description as NSString?
                        
                        lblWas.text = "\(restListModel?.currency == "Kz" ? " \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))")"
                        lblWas.font = UIFont(name: App.Fonts.SegoeUI.Bold, size: 22)!
                        lblWas.textColor = AppColor.textColor
                        lblPrice.isHidden = true
                        strikePrice.isHidden = false
                        lblNow.isHidden = true
                        lblOfferValid.isHidden = true
                        lblVAlidTop.constant = 0
                        lblOfferValid.text = ""
                        lblWas.text = ""
                        debugPrint(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))
                        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
                        let myMutableString = NSMutableAttributedString()
                        let myMutableString1 = NSAttributedString(string: "\(restListModel?.productName ?? "")\("\n")\("")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 15)!, .foregroundColor :UIColor.black])
                        
                        let quantityyy = (restListModel?.quantity?.description) as NSString?
                        //let quantityyy_price = (restListModel?.price?.description)
                        var strDescription = ""
                        
                        if restListModel?.description?.count ?? 0 > 30 {
                            strDescription = restListModel?.description?.prefix(30).description ?? "" + ".."
                        }else{
                            strDescription = restListModel?.description ?? ""
                        }
                        
                        let myMutableString2 = NSAttributedString(string: "\(strDescription)\n\("Quantity".localized()) : \(getCurrencyFormat(amount: quantityyy?.doubleValue ?? 0.0))", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13)!, .foregroundColor :UIColor.darkGray])
                        
                        myMutableString.append(myMutableString1)
                        myMutableString.append(myMutableString2)
                        
                        // *** Create instance of `NSMutableParagraphStyle`
                        let paragraphStyle = NSMutableParagraphStyle()
                        
                        paragraphStyle.alignment = .left
                        
                        // *** set LineSpacing property in points ***
                        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
                        
                        lblDetails.numberOfLines = 0
                        // *** Apply attribute to string ***
                        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
                        
                        lblDetails.attributedText = myMutableString
                        
                        let myMutableString3 = NSAttributedString(string: "\(restListModel?.currency == "Kz" ? "\(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13)!, .foregroundColor :UIColor.darkGray])
                        
                        strikePrice.attributedText = myMutableString3
                        
                    }
                }
                    else{
                        let localPrice = restListModel?.price?.description as NSString?
                        
                        lblWas.text = "\(restListModel?.currency == "Kz" ? " \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))")"
                        lblWas.font = UIFont(name: App.Fonts.SegoeUI.Bold, size: 22)!
                        lblWas.textColor = AppColor.textColor
                        lblPrice.isHidden = true
                        strikePrice.isHidden = false
                        lblNow.isHidden = true
                        lblOfferValid.isHidden = true
                        lblVAlidTop.constant = 0
                        lblOfferValid.text = ""
                        lblWas.text = ""
                        debugPrint(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))
                        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
                        let myMutableString = NSMutableAttributedString()
                        let myMutableString1 = NSAttributedString(string: "\(restListModel?.productName ?? "")\("\n")\("")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 15)!, .foregroundColor :UIColor.black])
                        
                        let quantityyy = (restListModel?.quantity?.description) as NSString?
                        //let quantityyy_price = (restListModel?.price?.description)
                        var strDescription = ""
                        
                        if restListModel?.description?.count ?? 0 > 30 {
                            strDescription = restListModel?.description?.prefix(30).description ?? "" + ".."
                        }else{
                            strDescription = restListModel?.description ?? ""
                        }
                        
                        let myMutableString2 = NSAttributedString(string: "\(strDescription)\n\("Quantity".localized()) : \(getCurrencyFormat(amount: quantityyy?.doubleValue ?? 0.0))", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13)!, .foregroundColor :UIColor.darkGray])
                        
                        myMutableString.append(myMutableString1)
                        myMutableString.append(myMutableString2)
                        
                        // *** Create instance of `NSMutableParagraphStyle`
                        let paragraphStyle = NSMutableParagraphStyle()
                        
                        paragraphStyle.alignment = .left
                        
                        // *** set LineSpacing property in points ***
                        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
                        
                        lblDetails.numberOfLines = 0
                        // *** Apply attribute to string ***
                        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
                        
                        lblDetails.attributedText = myMutableString
                        
                        let myMutableString3 = NSAttributedString(string: "\(restListModel?.currency == "Kz" ? "\(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13)!, .foregroundColor :UIColor.darkGray])
                        
                        strikePrice.attributedText = myMutableString3
                        
                    }

                
            }
            
            imgView.setImage(withImageId: restListModel?.productImage ?? "", placeholderImage: #imageLiteral(resourceName: "food_icon"))
            if restListModel?.productType == "Veg"{
                imgType.image = #imageLiteral(resourceName: "veg_symbol")
            }else{
                imgType.image = #imageLiteral(resourceName: "nonveg_symbol")
            }
            
        }
        
    }
//    var itemMenuList: ReataurantList?{
//        didSet{
//            quantity = itemMenuList?.quantity ?? 0
//            price = self.itemMenuList?.price ?? 0
//            currentCartQuantity = itemMenuList?.cartData?.quantity ?? 0
//
//            minimumPrice = minimumPrice + ((itemMenuList?.cartData?.quantity ?? 0) * (itemMenuList?.price ?? 0))
//            configureWith(info: itemMenuList!)
//            self.productID = itemMenuList?.Id ?? ""
//        }
//    }
    
    var itemFromCart: CartItemData?{
        didSet{
            print("type..........\(self.itemFromCart?.productData?.type)")
            print("Cart Seller Data Status",itemFromCart?.sellerData?.offerStatus)
            cellType = self.itemFromCart?.productData?.type == "Product" ? CellType.grocery:CellType.restaurant
            quantity = self.itemFromCart?.productData?.quantity ?? 0
           // price = self.itemFromCart?.productData?.offerPrice ?? 0
            if MyHelper.isValidNewOfferPeriod(endDate: self.itemFromCart?.productData?.endDate ?? ""){
                price = self.itemFromCart?.productData?.offerPrice ?? 0
            }else{
                price = self.itemFromCart?.productData?.price ?? 0
            }
            currentCartQuantity = itemFromCart?.quantity ?? 0
            btnQtyRef.setTitle(self.currentCartQuantity.description, for: .normal)
            
            let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
            
            let dataa = itemFromCart?.productData
            let myMutableString = NSMutableAttributedString()
            
            let myMutableString1 = NSAttributedString(string: "\(dataa?.productName ?? "")\("\n")\("")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 15)!, .foregroundColor :UIColor.black])
            
            
            let prisssss = itemFromCart?.productData?.price?.description as NSString?
            let quantityy = itemFromCart?.productData?.quantity?.description as NSString?
            
            var strrDescription = ""
            
            if dataa?.description?.count ?? 0 > 30{
                strrDescription = dataa?.description?.prefix(30).description ?? "" + ".."
            }else{
                strrDescription = dataa?.description ?? ""
            }
            if itemFromCart?.productData?.oStatus == "Inactive"{
                let localPrice = itemFromCart?.productData?.price?.description as NSString?

                lblWas.text = "\(itemFromCart?.productData?.currency == "Kz" ? " \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))")"
                lblWas.font = UIFont(name: App.Fonts.SegoeUI.Bold, size: 22)!
                lblWas.textColor = AppColor.textColor
                lblPrice.isHidden = true
                strikePrice.isHidden = false
                lblNow.isHidden = true
                lblOfferValid.isHidden = true
                lblVAlidTop.constant = 0
                lblOfferValid.text = ""
                lblWas.text = ""
                debugPrint(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))
                
                    let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
                    let myMutableString = NSMutableAttributedString()
                let myMutableString1 = NSAttributedString(string: "\(itemFromCart?.productData?.productName ?? "")\("\n")\("")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 15)!, .foregroundColor :UIColor.black])
                    
                    let quantityyy = (itemFromCart?.productData?.quantity?.description) as NSString?
                    var strDescription = ""
                    
                    if itemFromCart?.productData?.description?.count ?? 0 > 30 {
                        strDescription = itemFromCart?.productData?.description?.prefix(30).description ?? "" + ".."
                    }else{
                        strDescription = itemFromCart?.productData?.description ?? ""
                    }
                    
            let myMutableString2 = NSAttributedString(string: "\(strDescription)\n\("Quantity".localized()) : \(getCurrencyFormat(amount: quantityyy?.doubleValue ?? 0.0))", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13)!, .foregroundColor :UIColor.darkGray])
                    
                    myMutableString.append(myMutableString1)
                    myMutableString.append(myMutableString2)
                    
                    // *** Create instance of `NSMutableParagraphStyle`
                    let paragraphStyle = NSMutableParagraphStyle()
                    
                    paragraphStyle.alignment = .left
                    
                    // *** set LineSpacing property in points ***
                    paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
                    
                    lblDetails.numberOfLines = 0
                    // *** Apply attribute to string ***
                    myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
                    
                    lblDetails.attributedText = myMutableString
                let myMutableString3 = NSAttributedString(string: "\(itemFromCart?.productData?.currency == "Kz" ? "\(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13)!, .foregroundColor :UIColor.darkGray])
                
                strikePrice.attributedText = myMutableString3

            }
            else
            {
                print("else block executed ..............")
                
                if itemFromCart?.sellerData?.offerStatus == "Active"{
                    if MyHelper.isValidNewOfferPeriod(endDate: itemFromCart?.productData?.endDate ?? ""){
                       
//                        lblWasLeading.constant = 0
//                        imgVerWidth.constant = 0
                        let offerPriceLocal = itemFromCart?.productData?.offerPrice?.description as NSString?
                        let lblPriceText = "\(itemFromCart?.productData?.currency == "Kz" ? "\(getCurrencyFormat(amount: offerPriceLocal?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: offerPriceLocal?.doubleValue ?? 0.0))")"
                        
                        lblPrice.text = lblPriceText.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        let pris = itemFromCart?.productData?.price?.description as NSString?
                        
                        strikePrice.text = "\(itemFromCart?.productData?.currency == "Kz" ? " \(getCurrencyFormat(amount: pris?.doubleValue ?? 0.0)) Kz" : "$\(getCurrencyFormat(amount: pris?.doubleValue ?? 0.0))")"
                        
                        lblOfferValid.text = "\("This offer is valid from".localized()) \(dateTimeConversion(createdAt: itemFromCart?.productData?.startDate ?? "")) \("till".localized()) \(dateTimeConversion(createdAt: itemFromCart?.productData?.endDate ?? ""))"
                        
                        priceCutView.isHidden = false
                        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
                        let myMutableString = NSMutableAttributedString()
                        let myMutableString1 = NSAttributedString(string: "\(itemFromCart?.productData?.productName ?? "")\("\n")\("")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 15)!, .foregroundColor :UIColor.black])
                        
                        let quantityyy = (itemFromCart?.productData?.quantity?.description) as NSString?
                        var strDescription = ""
                        
                        if itemFromCart?.productData?.description?.count ?? 0 > 30 {
                            strDescription = itemFromCart?.productData?.description?.prefix(30).description ?? "" + ".."
                        }else{
                            strDescription = itemFromCart?.productData?.description ?? ""
                        }
                        
                        let myMutableString2 = NSAttributedString(string: "\(strDescription)\n\("Quantity".localized()) : \(getCurrencyFormat(amount: quantityyy?.doubleValue ?? 0.0))", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13)!, .foregroundColor :UIColor.darkGray])
                        
                        myMutableString.append(myMutableString1)
                        myMutableString.append(myMutableString2)
                        
                        // *** Create instance of `NSMutableParagraphStyle`
                        let paragraphStyle = NSMutableParagraphStyle()
                        
                        paragraphStyle.alignment = .left
                        
                        // *** set LineSpacing property in points ***
                        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
                        
                        lblDetails.numberOfLines = 0
                        // *** Apply attribute to string ***
                        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
                        
                        lblDetails.attributedText = myMutableString

                        
                    }else{
                        let localPrice = itemFromCart?.productData?.price?.description as NSString?
                        
                        lblWas.text = "\(itemFromCart?.productData?.currency == "Kz" ? " \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))")"
                        lblWas.font = UIFont(name: App.Fonts.SegoeUI.Bold, size: 22)!
                        lblWas.textColor = AppColor.textColor
                        lblPrice.isHidden = true
                        strikePrice.isHidden = false
                        lblNow.isHidden = true
                        lblOfferValid.isHidden = true
                        lblVAlidTop.constant = 0
                        lblOfferValid.text = ""
                        lblWas.text = ""
                        debugPrint(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))
                        
                        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
                        let myMutableString = NSMutableAttributedString()
                        let myMutableString1 = NSAttributedString(string: "\(itemFromCart?.productData?.productName ?? "")\("\n")\("")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 15)!, .foregroundColor :UIColor.black])
                        
                        let quantityyy = (itemFromCart?.productData?.quantity?.description) as NSString?
                        var strDescription = ""
                        
                        if itemFromCart?.productData?.description?.count ?? 0 > 30 {
                            strDescription = itemFromCart?.productData?.description?.prefix(30).description ?? "" + ".."
                        }else{
                            strDescription = itemFromCart?.productData?.description ?? ""
                        }
                        
                        let myMutableString2 = NSAttributedString(string: "\(strDescription)\n\("Quantity".localized()) : \(getCurrencyFormat(amount: quantityyy?.doubleValue ?? 0.0))", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13)!, .foregroundColor :UIColor.darkGray])
                        
                        myMutableString.append(myMutableString1)
                        myMutableString.append(myMutableString2)
                        
                        // *** Create instance of `NSMutableParagraphStyle`
                        let paragraphStyle = NSMutableParagraphStyle()
                        
                        paragraphStyle.alignment = .left
                        
                        // *** set LineSpacing property in points ***
                        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
                        
                        lblDetails.numberOfLines = 0
                        // *** Apply attribute to string ***
                        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
                        
                        lblDetails.attributedText = myMutableString
                        let myMutableString3 = NSAttributedString(string: "\(itemFromCart?.productData?.currency == "Kz" ? "\(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13)!, .foregroundColor :UIColor.darkGray])
                        
                        strikePrice.attributedText = myMutableString3

                    }
                }
                    else{
                    let localPrice = itemFromCart?.productData?.price?.description as NSString?

                    lblWas.text = "\(itemFromCart?.productData?.currency == "Kz" ? " \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))")"
                    lblWas.font = UIFont(name: App.Fonts.SegoeUI.Bold, size: 22)!
                    lblWas.textColor = AppColor.textColor
                    lblPrice.isHidden = true
                    strikePrice.isHidden = false
                    lblNow.isHidden = true
                    lblOfferValid.isHidden = true
                    lblVAlidTop.constant = 0
                    lblOfferValid.text = ""
                    lblWas.text = ""
                    debugPrint(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))
                    
                        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.blue ]
                        let myMutableString = NSMutableAttributedString()
                        let myMutableString1 = NSAttributedString(string: "\(itemFromCart?.productData?.productName ?? "")\("\n")\("")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 15)!, .foregroundColor :UIColor.black])
                        
                        let quantityyy = (itemFromCart?.productData?.quantity?.description) as NSString?
                        var strDescription = ""
                        
                        if itemFromCart?.productData?.description?.count ?? 0 > 30 {
                            strDescription = itemFromCart?.productData?.description?.prefix(30).description ?? "" + ".."
                        }else{
                            strDescription = itemFromCart?.productData?.description ?? ""
                        }
                        
                        let myMutableString2 = NSAttributedString(string: "\(strDescription)\n\("Quantity".localized()) : \(getCurrencyFormat(amount: quantityyy?.doubleValue ?? 0.0))", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13)!, .foregroundColor :UIColor.darkGray])
                        
                        myMutableString.append(myMutableString1)
                        myMutableString.append(myMutableString2)
                        
                        // *** Create instance of `NSMutableParagraphStyle`
                        let paragraphStyle = NSMutableParagraphStyle()
                        
                        paragraphStyle.alignment = .left
                        
                        // *** set LineSpacing property in points ***
                        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
                        
                        lblDetails.numberOfLines = 0
                        // *** Apply attribute to string ***
                        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
                        
                        lblDetails.attributedText = myMutableString
                        let myMutableString3 = NSAttributedString(string: "\(itemFromCart?.productData?.currency == "Kz" ? "\(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0)) Kz" : "$ \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0))")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13)!, .foregroundColor :UIColor.darkGray])
                        
                        strikePrice.attributedText = myMutableString3


                }

                
            }
            if itemFromCart?.productData?.productType == "Veg"{
                imgType.image = #imageLiteral(resourceName: "veg_symbol")
            }else{
                imgType.image = #imageLiteral(resourceName: "nonveg_symbol")
            }
            
            imgView.setImage(withImageId: itemFromCart?.productData?.productImage ?? "", placeholderImage: #imageLiteral(resourceName: "food_icon"))
            
            self.productID = itemFromCart?.productId ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnMinusRef.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 30)!
        btnMinusRef.setTitleColor(AppColor.themeColor, for: .normal)
        btnMinusRef.addTarget(self, action: #selector(minusQuantity(_:)), for: .touchUpInside)
        
        btnPlusRef.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 30)!
        btnPlusRef.setTitleColor(AppColor.themeColor, for: .normal)
        btnPlusRef.addTarget(self, action: #selector(addQuantity(_:)), for: .touchUpInside)
        
        CommonClass.sharedInstance.provideCustomCornarRadius(btnRef: btnQtyRef, radius: 5)
        CommonClass.sharedInstance.provideCustomBorder(btnRef: btnQtyRef)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
  
    //Price Change Currancy
    func getCurrencyFormat(amount: Double) -> String {
        let amountFormatter = NumberFormatter()
        amountFormatter.numberStyle = .decimal ///ERROR
        amountFormatter.locale = NSLocale.system
        let price = amountFormatter.string(from: amount as NSNumber)! as NSString
        return String(price.description)
        //        return String(price.description.prefix(price.description.count - 3))
    }
    //MARK:- Add Quantity
    @objc func addQuantity(_ sender:UIButton) {
        
        guard UserDefaults.standard.bool(forKey: "IsUserLogin") else {
            CommonClass.sharedInstance.alertWithAction()
            return
        }
        
        print(currentCartQuantity , quantity)
       // let closingTime = UserDefaults.standard.object(forKey: "closingTime") as! String
       // print("cellType............\(cellType)")
        if cellType == CellType.grocery{
                
            self.closingTime = UserDefaults.standard.object(forKey: "closingTime") as? String
            let newTiming = self.closingTime ?? ""
            print("Store Closing Time = ",closingTime)
            print("New Store Closing Time = ",newTiming)
            if MyHelper.isValidTime(closingTime: newTiming){
                    if self.currentCartQuantity > 0{
                        self.currentCartQuantity += 1
                        minimumPrice = minimumPrice + (price)
                        self.updateCartItem()
                    }else{
                        self.addCardItem()

                    }
                }else{
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Store has been closed".localized(), controller:commonController)
                }
//                guard let closingTime = closingTime else { return}
//                guard !closingTime.isEmpty else{return}
//            if newTiming.contains("AM") || newTiming.contains("PM") || newTiming.contains("am") || newTiming.contains("pm") {
//                if MyHelper.isValidTime(closingTime: newTiming){
//                        if self.currentCartQuantity > 0{
//                            self.currentCartQuantity += 1
//                            minimumPrice = minimumPrice + (price)
//                            self.updateCartItem()
//                        }else{
//                            self.addCardItem()
//
//                        }
//                    }else{
//                        CommonClass.sharedInstance.callNativeAlert(title: "", message: "Store has been closed".localized(), controller:commonController)
//                    }
//            }
//            else {
//                if MyHelper.isValidTime24HRS(closingTime: newTiming){
//
//                        if self.currentCartQuantity > 0{
//                            self.currentCartQuantity += 1
//                            minimumPrice = minimumPrice + (price)
//                            self.updateCartItem()
//                        }else{
//                            self.addCardItem()
//
//                        }
//                    }else{
//                        CommonClass.sharedInstance.callNativeAlert(title: "", message: "Store has been closed".localized(), controller:commonController)
//                    }
//            }

        
           
            
          
           
        }else{
           // print("else block executed........")
            self.closingTime = UserDefaults.standard.object(forKey: "closingTime") as? String
            let newTiming = self.closingTime ?? ""
            print("Restaurant Closing Time = ",closingTime)
            print("New Restaurant Closing Time = ",newTiming)
            if MyHelper.isValidTime(closingTime: closingTime ?? ""){
                if self.currentCartQuantity > 0{
                    self.currentCartQuantity += 1
                    minimumPrice = minimumPrice + (price)
                    self.updateCartItem()
                }else{
                    self.addCardItem()

                }
            }else{
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Restaurant has been closed".localized(), controller:commonController)
            }
//            if newTiming.contains("AM") || newTiming.contains("PM") || newTiming.contains("am") || newTiming.contains("pm") {
//
//            if MyHelper.isValidTime(closingTime: closingTime ?? ""){
//                if self.currentCartQuantity > 0{
//                    self.currentCartQuantity += 1
//                    minimumPrice = minimumPrice + (price)
//                    self.updateCartItem()
//                }else{
//                    self.addCardItem()
//
//                }
//            }else{
//                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Restaurant has been closed".localized(), controller:commonController)
//            }
//            }
//            else
//            {
//                if MyHelper.isValidTime24HRS(closingTime: newTiming){
//
//                        if self.currentCartQuantity > 0{
//                            self.currentCartQuantity += 1
//                            minimumPrice = minimumPrice + (price)
//                            self.updateCartItem()
//                        }else{
//                            self.addCardItem()
//
//                        }
//                    }else{
//                        CommonClass.sharedInstance.callNativeAlert(title: "", message: "Restaurant has been closed".localized(), controller:commonController)
//                    }
//            }
        }

        
        //        if currentCartQuantity < quantity {
        //            if self.currentCartQuantity > 0{
        //                self.currentCartQuantity += 1
        //                minimumPrice = minimumPrice + (price)
        //                self.updateCartItem()
        //            }else{
        //                self.addCardItem()
        //
        //            }
        //        }else{
        //            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Can't add more items than Quantity".localized(), controller: commonController)
        //        }
        
        
    }
    
    @objc func minusQuantity(_ sender:UIButton){
        
        guard UserDefaults.standard.bool(forKey: "IsUserLogin") else {
            CommonClass.sharedInstance.alertWithAction()
            return
        }
            if currentCartQuantity > 0 {
                currentCartQuantity -= 1
                minimumPrice = minimumPrice - (price)
                
                self.updateCartItem()
            }else{
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "No quantity added in cart".localized(), controller: commonController)
            }
    }
    
    func configureWith(info: MenuList){
        
        if comgFromOffer == true {
            lblWas.isHidden = false
            lblNow.isHidden = false
            lblPrice.isHidden = false
            strikePrice.isHidden = false
            lblOfferValid.isHidden = false
            lblVAlidTop.constant = 25
            
            let myMutableString = NSMutableAttributedString()
            
            let myMutableString1 = NSAttributedString(string: "\(info.productName ?? "")\n", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 14)!, .foregroundColor :UIColor.darkGray
            ])
            
            let quantityDes = (info.quantity?.description) as NSString?
            
            let myMutableString2 = NSAttributedString(string: "\(info.description ?? "")\n\("Quantity".localized()) : \(info.quantity?.description ?? "")", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 12)!, .foregroundColor :UIColor.lightGray])
            
            myMutableString.append(myMutableString1)
            myMutableString.append(myMutableString2)
            
            lblDetails.attributedText = myMutableString
            imgVerHeight.constant = 0
            
            lblPrice.attributedText = makeSlashText(price: "\(info.price?.description ?? "") Kz", strikeText: info.offerPrice?.description ?? "")
            
            let example = NSAttributedString(string: "\("20") Kz").withStrikeThrough(1)
            strikePrice.attributedText = example
            
            imgView.setImage(withImageId: info.productImage ?? "", placeholderImage: #imageLiteral(resourceName: "food_icon"))
            btnQtyRef.setTitle(self.currentCartQuantity.description, for: .normal)
            
        }else{
            
            lblWas.isHidden = true
            lblNow.isHidden = true
            lblPrice.isHidden = true
            strikePrice.isHidden = true
            lblOfferValid.isHidden = true
            lblVAlidTop.constant = 0
            lblOfferValid.text  = ""
            
            if showQunatity == true{
                
                let priceesss = (info.price?.description ?? "") as NSString
                
                lblDetails.attributedText = CommonClass.sharedInstance.attributedString(title: info.productName ?? "", title1: "\(info.description ?? "")\n\("Quantity".localized()) : \(info.quantity?.description ?? "")", subTitle: "\(getCurrencyFormat(amount: priceesss.doubleValue )) \(info.currency == "Kz" ? "Kz" : "$")", delemit: "\n", sizeTitle: 15, sizeSubtitle: 16, titleColor: AppColor.textColor, SubtitleColor: AppColor.textColor, newText: "")
                
            }else{
                
                let pr = (info.price?.description ?? "") as NSString
                
                lblDetails.attributedText = CommonClass.sharedInstance.attributedString(title: info.productName ?? "", title1: "\(info.description ?? "")", subTitle: "\(getCurrencyFormat(amount: pr.doubleValue )) \(info.currency == "Kz" ? "Kz" : "$")", delemit: "\n", sizeTitle: 15, sizeSubtitle: 16, titleColor: AppColor.textColor, SubtitleColor: AppColor.textColor, newText: "")
                
            }
            
            imgVerHeight.constant = 14
            if info.productType == "Veg"{
                imgType.image = #imageLiteral(resourceName: "veg_symbol")
            }else{
                imgType.image = #imageLiteral(resourceName: "nonveg_symbol")
            }
            imgType.isHidden = false
            
            imgView.setImage(withImageId: info.productImage ?? "", placeholderImage: #imageLiteral(resourceName: "food_icon"))
            btnQtyRef.setTitle(self.currentCartQuantity.description, for: .normal)
            
        }
    }
    
    
    func configureWithPro(info:OfferListModel) {
        
        lblWas.isHidden = false
        lblNow.isHidden = false
        lblPrice.isHidden = false
        strikePrice.isHidden = false
        lblOfferValid.isHidden = false
        lblVAlidTop.constant = 25
        let myMutableString = NSMutableAttributedString()
        let myMutableString1 = NSAttributedString(string: "\(info.title ?? "")\n", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 14)!, .foregroundColor :UIColor.darkGray
        ])
        let myMutableString2 = NSAttributedString(string: "\(info.productDetail ?? "")\n\("Quantity".localized()) : 1", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 12)!, .foregroundColor :UIColor.lightGray])
        
        myMutableString.append(myMutableString1)
        myMutableString.append(myMutableString2)
        
        lblDetails.attributedText = myMutableString
//        lblDetails.numberOfLines = 3
        imgVerHeight.constant = 0
        
        let lastPricess = (info.lastPrice?.description ?? "") as NSString
        let infoPrcee = (info.price?.description ?? "") as NSString
        
        lblPrice.attributedText = makeSlashText(price:"\(infoPrcee)", strikeText: "\(lastPricess)")
        
        let example = NSAttributedString(string: "\(lastPricess)").withStrikeThrough(1)
        strikePrice.attributedText = example
        
        imgView.image = UIImage(named: "\(info.imageProduct)")
    }
    
}


//MARK:- AddToCart Api
extension CartTableViewCellAndXib {
    
    // Add Item
    func addCardItem(){
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                     "productId": self.productID,
                     "langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ] as [String:Any]
        
        apiHandle.fetchApiService(method: .post, url: Domain.baseUrl().appending(APIEndpoint.addToCart), passDict: param, header: header) { (result) in
            switch result{
            case .success(let data):
                print("data from add cart item.......\(data)")
                if data["status"].stringValue == "SUCCESS"{
                    
                    self.updateCartCountDelegate?.getCountCart(true)
                    self.currentCartQuantity += 1
                    minimumPrice = minimumPrice + self.price
                    self.delegatePrice?.refreshPrice()
                    // minimumPrice = (self.currentCartQuantity) * (self.itemMenuList?.price ?? 0)
                    self.btnQtyRef.setTitle(self.currentCartQuantity.description, for: .normal)
                }
                //                else if data["response_message"].stringValue == "Please clear your cart to add this item."{
                //                    self.currentCartQuantity += 1
                //                    minimumPrice = minimumPrice + (self.price)
                //                    self.updateCartItem()
                //                }
                else{
                    //CommonClass.sharedInstance.callNativeAlert(title: "", message: data["response_message"].stringValue, controller: commonController)
                    //CommonClass.sharedInstance.show_Alert_PushToAnotherVC_Action(message:data["response_message"].stringValue, title:"")
                    let vc = ScreenManager.ClearCartPOPUP()
                    vc.message = data["response_message"].stringValue
                    vc.navObj = self.vc
                    vc.productID = self.productID
                    self.vc.present(vc, animated: true, completion: nil)
                    
                    
                }
                break
            case .failure(let error):
                CommonClass.sharedInstance.callNativeAlert(title: "", message: error.localizedDescription, controller: commonController)
                break
            }
        }
    }
    
    // Remove Item
    func updateCartItem(){
        
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        
        let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                     "productId": self.productID,
                     "langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,
                     "quantity":currentCartQuantity.description] as [String:Any]
        
        
        print(header,param)
        
        apiHandle.fetchApiService(method: .post, url: Domain.baseUrl().appending(APIEndpoint.updateCart), passDict: param, header: header) { (result) in
            switch result{
            case .success(let data):                             
                print(data)
                if data["status"].stringValue == "SUCCESS"{
                    self.btnQtyRef.setTitle(self.currentCartQuantity.description, for: .normal)
                    self.delegatePrice?.refreshPrice()
                    
                    self.updateCartCountDelegate?.getCountCart(true)
                    
                    // minimumPrice = (self.currentCartQuantity) * (self.itemMenuList?.price ?? 0)
                    
                }else if data["response_message"].stringValue == "Item removed from your cart successfully"{
                    self.currentCartQuantity = 0
                    self.delegatePrice?.refreshPrice()
                    
                    self.updateCartCountDelegate?.getCountCart(true)
                    
                    //  minimumPrice = (self.currentCartQuantity) * (self.itemMenuList?.price ?? 0)
                    self.btnQtyRef.setTitle(self.currentCartQuantity.description, for: .normal)
                } else{
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: data["response_message"].stringValue, controller: commonController)
                }
                break
            case .failure(let error):
                CommonClass.sharedInstance.callNativeAlert(title: "", message: error.localizedDescription, controller: commonController)
                break
            }
        }
    }
}

var minimumPrice = 0

protocol RefreshPriceDelegate {
    func refreshPrice()
}
