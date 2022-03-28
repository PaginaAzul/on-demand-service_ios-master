//
//  MyCart+Api.swift
//  Joker
//
//  Created by SinhaAirBook on 08/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation

extension MyCartNew_VC{
    
    func apiPlaceOrder(){
        
        guard self.address != "" else {
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please fill your address", controller: self)
            return
        }
        
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        
        var price = Int()
        
        for i in 0..<(self.viewModel.myCartDataArray.first?.Data?.count ?? 0){
            if self.viewModel.myCartDataArray.first?.Data?[i].productData?.oStatus == "Active"{
                if MyHelper.isValidNewOfferPeriod(endDate: (self.viewModel.myCartDataArray.first?.Data?[i].productData?.endDate ?? "")){
                    price += self.viewModel.myCartDataArray.first?.Data?[i].productData?.offerPrice ?? 0 * (self.viewModel.myCartDataArray.first?.Data?[i].quantity ?? 0)
                    
                }else{
                    price += self.viewModel.myCartDataArray.first?.Data?[i].productData?.price ?? 0 * (self.viewModel.myCartDataArray.first?.Data?[i].quantity ?? 0)
                }
                
            }else{
                price += self.viewModel.myCartDataArray.first?.Data?[i].productData?.price ?? 0 * (self.viewModel.myCartDataArray.first?.Data?[i].quantity ?? 0)
            }
            
            
            // price += (((self.viewModel.myCartDataArray.first?.Data?[i].productData?.offerPrice ?? 0) == 0 ? (self.viewModel.myCartDataArray.first?.Data?[i].productData?.price ?? 0):(self.viewModel.myCartDataArray.first?.Data?[i].productData?.offerPrice ?? 0)) * (self.viewModel.myCartDataArray.first?.Data?[i].quantity ?? 0))
        }
        
//        if price < 100{
//            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please ", controller: commonController)
//            return
//        }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var currentDate = formatter.string(from: date)
        
        var deliveryTime = self.viewModel.myCartDataArray.first?.Data?.first?.sellerData?.deliveryTime ?? 0
        
        print(currentDate ,deliveryDate )
        
        
        let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                     "langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "en",
                     "deliveryDate": (deliveryDate == nil) ? currentDate : deliveryDate ?? "",
                     "excepetdDeliveryTime":deliveryTime,
                     "deliveryCharge":(self.viewModel.deliveryChargeArray.first?.Data?.deliveryCharge ?? 0),
                     "totalPrice":"\(price + (self.viewModel.deliveryChargeArray.first?.Data?.deliveryCharge ?? 0))",
                     "price":price.description,
                     "orderType": (deliveryDate == "") ? "Menu" : "Product" ,
                     "offerApplicable":"false",
                     "offerAmount":"0",
                     "address":self.address,
                     "latitude":self.lat,
                     "longitude":self.long,
                     "landmark":self.landMark,
                     "buildingAndApart":self.buildingAndAppNo,
                     "deliverySlot":deliverySlot ?? "" , /* */
                     "deliveryTimeSlot":deliveryTimeSlot  ?? ""  /* */
        ] as [String:Any]
        
        
        print(param)
        
        viewModel.getPlaceOrder(Domain.baseUrl().appending(APIEndpoint.getplaceOrder), param, header)
        
        clouserSetup()
        
    }
    func getDeliveryCharge(){
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        
        let param = ["userId" : UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                     "resAndStoreId" : self.viewModel.myCartDataArray.first?.Data?.first?.resAndStoreId ?? ""]
        print(header)
        print(param)
        viewModel.getDeliveryChargeAPI(Domain.baseUrl().appending(APIEndpoint.getDeliveryCharge), param as [String : Any], header)
        self.clouserSetup()
        
    }
    
    func getCountV(){
        
        let param = ["userId" : UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
        viewModel.getCartCountAPI(Domain.baseUrl().appending(APIEndpoint.getCartCount), param)
        self.clouserSetup()
        
    }
    
    func fetchCartItem(){
        
        getCountV()
        
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        
        let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                     "langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ] as [String:Any]
        
        viewModel.getCartItemService(Domain.baseUrl().appending(APIEndpoint.getCartItem), param, header)
        
        clouserSetup()
    }
    
    func clouserSetup(){
        
        viewModel.reloadList = {() in
            
            if ((self.viewModel.myCartDataArray.first?.Data?.count ?? 0) > 0) {
                
                self.tblView.isHidden = false
                self.btnPay.isHidden = false
                self.lblNoItemInCart.text = "No item".localized()
                self.lblNoItemInCart.isHidden = true
                
                if self.viewModel.myCartDataArray.first?.Data?.first?.productData?.type == "Menu" {
                    
                    self.valueCheckFoodORGrocery = "Food"
                    
                }else{
                    
                    self.valueCheckFoodORGrocery = "Restaurent"
                    
                }
                
                self.registerNib()
                
            }else{
                
                self.lblNoItemInCart.isHidden = false
                self.tblView.isHidden = true
                self.btnPay.isHidden = true
                
                
            }
            
            self.tblView.reloadData()
            self.getDeliveryCharge()
        }
        
        self.viewModel.cartCount = {(count , type) in
            
            if type == "Product" {
                
                self.valueCheckFoodORGrocery = "Restaurent"
                
            }else{
                
                self.valueCheckFoodORGrocery = "Food"
                
            }
            // self.tblView.reloadData()
            
        }
        
        
        viewModel.success = { (message) in
            print(message)
            if message == "Order placed successfully".localized(){
                let vc = ScreenManager.OrderPlacedPopUp_VC()
                vc.icComingFromOffer = self.icComingFromOffer
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
            else if message == "Delivery Charge"{
                self.btnPay.isHidden = false
                print("Delivery Charge = ",self.viewModel.deliveryChargeArray.first?.Data?.deliveryCharge ?? 0)
                self.registerNib()
                self.tblView.reloadData()
            }
            else if message == "Sorry, it is currently not possible to place orders at this establishment. Choose another available in the app"
            {
                self.btnPay.isHidden = true
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Sorry, it is currently not possible to place orders at this establishment. Choose another available in the app".localized(), controller:commonController)

            }
            else if message == "Clear cart successfull" {
                self.tblView.isHidden = true
                self.btnPay.isHidden = true
                self.lblNoItemInCart.isHidden = false
                self.addCardItem()
            }
            
        }
        
        viewModel.errorMessage = { (message) in
            print(message)
            
           
            
        }
        
        
    }
    func getClearCartAPI(){
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        
        let param = ["userId" : UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
        print(header)
        print(param)
        viewModel.getClearCartAPI(Domain.baseUrl().appending(APIEndpoint.getClearCart), param as [String : Any], header)
        self.clouserSetup()
        
    }
    
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
                    
                    self.fetchCartItem()
                    
                }
                
                else{
                    
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

func dateTimeConversion(createdAt:String) -> String{
    
    
    var newTimeZone = String()
    newTimeZone = newTimeZone.timeDateConversion(formateDate:String(createdAt.prefix(19)))
    let start = String.Index(utf16Offset: 11, in: newTimeZone)
    let end = String.Index(utf16Offset: 18, in: newTimeZone)
    let substring = String(newTimeZone[start...end])
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale.init(identifier: "en_GB")
    
    let dateObj = dateFormatter.date(from: "\(newTimeZone.prefix(10))")
    dateFormatter.dateFormat = "dd/MM/yyyy"
    var timeT = String()
    timeT = timeT.timeConversion12(time24: "\(substring.prefix(5))")
    // ("\(dateFormatter.string(from: dateObj!))",timeT)
    return "\(dateFormatter.string(from: dateObj!))"
}

extension String{
    
    func timeDateConversion(formateDate:String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date = dateFormatter.date(from: formateDate == "" ? "2020-02-28T13:30:15" : formateDate)// create   date from string
        
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: date!)
        
        return timeStamp
    }
    
    func timeConversion12(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "HH:mm "
        
        let date = df.date(from: dateAsString)
        df.dateFormat = "hh:mm a"
        
        let time12 = df.string(from: date!)
        return time12
    }
}
