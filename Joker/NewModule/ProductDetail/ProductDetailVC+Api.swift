//
//  ProductDetailVC+Api.swift
//  Joker
//
//  Created by User on 24/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation


///////New Code

//MARK: - WebService Implementation
//TODO:
extension ProductDetailVC {
    
    
    func productDetail(){
        
        commonController = self
        
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            let param = ["userId": UserDefaults.standard.value(forKey: "UserID") as? String ?? "" ,
                         "langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,
                         "productId": self.productId]
            print(param)
            
            viewModel.fetchProductDetail(Domain.baseUrl().appending(APIEndpoint.productDetail), param, header)

        }else {
            let param = ["langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,
                         "productId": self.productId]
            print(param)
            
            viewModel.fetchProductDetail(Domain.baseUrl().appending(APIEndpoint.productDetail), param)
        }
                closureSetup()
    }
    
    func closureSetup(){
        
        viewModel.reloadList = { () in
            self.setUIData()
        }
        
        viewModel.errorMessage = { (message) in
            print(message)
        }
        
    }
    
    func setUIData(){
        
        let info = viewModel.productDetailArr.first?.Data
        viewCosmos.settings.fillMode = .half
        
        viewCosmos.rating = Double(info?.avgRating ?? Int(0.0))
        btnFavRef.setImage(#imageLiteral(resourceName: "fav_un"), for: .normal)
        lblReviews.text = "\(info?.avgRating ?? 0) (\(info?.totalRating ?? 0) \("Reviews".localized()))"
        
        imgProduct.setImage(withImageId: info?.productImage ?? "", placeholderImage: #imageLiteral(resourceName: "food_icon"))
        CommonClass.sharedInstance.provideCornarRadius(btnRef: viewLike)
   
        let myMutableString1 = NSMutableAttributedString()
        let normalText1 = info?.productName ?? ""
        
        let myMutableString2 = NSAttributedString(string: "\(normalText1)\n", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 17.0)!, .foregroundColor :UIColor.black])
        
        let normalText2 = info?.resAndStoreId?.name ?? ""
        
        let myMutableString3 = NSAttributedString(string: "\(normalText2)\n", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 14.0)!, .foregroundColor :AppColor.placeHolderColor])
        
        let infoData = (info?.price?.description) as NSString?
        
        let normalText3 = "\(getCurrencyFormat(amount: infoData?.doubleValue ?? 0.0)) \(info?.currency ?? "")"
        
        let myMutableString4 = NSAttributedString(string: "\(normalText3) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 14.0)!, .foregroundColor :AppColor.textColor])
        
        myMutableString1.append(myMutableString2)
        myMutableString1.append(myMutableString3)
        myMutableString1.append(myMutableString4)
        
        let infoQuantity = (info?.quantity?.description) as NSString?
        
        lblDetails.attributedText = myMutableString1
        lblQuantity.text = "\("Quantity".localized()) : \(getCurrencyFormat(amount: infoQuantity?.doubleValue ?? 0.0))"
        lblDescription.text = info?.description ?? ""
        
    }
    
    //Price Change Currancy
    
    func getCurrencyFormat(amount: Double) -> String
    {
        let amountFormatter = NumberFormatter()
        amountFormatter.numberStyle = .decimal ///ERROR
        amountFormatter.locale = NSLocale.system
        let price = amountFormatter.string(from: amount       as NSNumber)! as NSString
        return String(price.description)
//        return String(price.description.prefix(price.description.count - 3))
    }
}


