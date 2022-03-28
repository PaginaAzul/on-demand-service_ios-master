//
//  ProductListing+Api.swift
//  Joker
//
//  Created by User on 24/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation


////New code


extension ProductListingNew_VC{
    
    
    //MARK:- Fetch Product Api...
    //TODO:

    
    func fetchProductList(){
        
        getCountV()
        commonController = self
        
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            let param = ["userId": UserDefaults.standard.value(forKey: "UserID") as? String ?? "" ,
                         "langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,
                         "resAndStoreId": self.resAndStoreId ,
                         "subCategoryName": self.subCategoryName]
            viewModel.productList_API(Domain.baseUrl().appending(APIEndpoint.getProductData), param, header)
        }else {
            let param = ["langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,
                         "resAndStoreId": self.resAndStoreId ,
                         "subCategoryName": self.subCategoryName]
            viewModel.productList_API(Domain.baseUrl().appending(APIEndpoint.getProductData), param)
        }
        
        
        closureSetup()
    }
    
    
    func closureSetup(){
        
        viewModel.reloadCollection = { () in
            self.registerNib()
        }
        
        viewModel.errorMessage = { (message) in
            print(message)
            CommonClass.sharedInstance.callNativeAlert(title: "", message: message, controller: self)
        }
        
        viewModel.cartCount = {(count , type) in
             setBage(self.btnCart, "\(count)")
        }
        
    }
    
    func getCountV(){
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            let param = ["userId" : UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
           viewModel.getCartCountAPI(Domain.baseUrl().appending(APIEndpoint.getCartCount), param)
        }else{
            viewModel.getCartCountAPI(Domain.baseUrl().appending(APIEndpoint.getCartCount))
        }
        
        self.closureSetup()
    }
    
}
