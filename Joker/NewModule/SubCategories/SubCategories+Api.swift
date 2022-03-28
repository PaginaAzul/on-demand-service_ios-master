//
//  SubCategoriesWebService.swift
//  Joker
//
//  Created by User on 24/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation

//MARK: - WebService SubCategories
//TODO:
extension SubCategoriesVC {
    
    //MARK:- SubCategory Api...
    //TODO:
    internal func fetchSubCategoryData(){
        
        
        commonController = self
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            let passDict = ["userId": UserDefaults.standard.value(forKey: "UserID") as? String ?? "" ,"categoryId":self.categoryId  , "langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""] as? [String:String]
            viewModel.getCategoryList_API(Domain.baseUrl().appending(APIEndpoint.getSubCategoryList), .post , passDict)
        }else{
            let passDict = ["categoryId":self.categoryId  ,"langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""] as? [String:String]
            viewModel.getCategoryList_API(Domain.baseUrl().appending(APIEndpoint.getSubCategoryList), .post , passDict)
        }
        
        closureSetup()
        
    }
    
    internal func closureSetup(){
        
        viewModel.errorMessage = { (message) in
            print(message)
            if message.contains("URLSessionTask failed with error: The network connection was lost."){
                self.fetchSubCategoryData()
            }else{
                CommonClass.sharedInstance.callNativeAlert(title: "", message: message, controller: self)
            }
            
        }
        
        viewModel.success = {(message) in
            print(message)
            
        }
        
        viewModel.reloadCollection = { () in
            self.configureColl()
            self.getCountV()
        }
        
        viewModel.cartCount = {(count , type) in
             setBage(self.btnCart, "\(count)")
        }
    }
    
    
    func getCountV(){
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            let param = ["userId" : UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
            viewModel.getCartCountAPI(Domain.baseUrl().appending(APIEndpoint.getCartCount), param)
            
        }else {
            viewModel.getCartCountAPI(Domain.baseUrl().appending(APIEndpoint.getCartCount))
        }
        
        self.closureSetup()
        
    }
}
