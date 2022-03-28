//
//  Grocery+Api.swift
//  Joker
//
//  Created by SinhaAirBook on 07/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation

extension GroceryDetailVC{
    
    //MARK:- getresAndStoreDetailService...
    func getresAndStoreDetailService(){
        
        commonController = self
        
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        var param = [String:Any]()
        
        
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                        "resAndStoreId": self.id ?? 0,
                        "langcode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""] as [String:Any]
           
        }else{
            param = [
                        "resAndStoreId": self.id,
                        "langcode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""] as [String:Any]
           
        }
        
        
        print("param -->" , param)

        viewModel.fetchResAndStoreDetailService(Domain.baseUrl().appending(APIEndpoint.resAndStoreDetail), param, header)
        
        self.clouserSetup()
    }
    
    //MARK:- getMenuDataService...
    //TODO:
    func fetchCategoryData(){
        commonController = self
        let param = ["resAndStoreId": self.id,"langcode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""] as [String:Any]
        
        print("param -->" , param)

        
       // viewModel.getCategoryList_API(Domain.baseUrl().appending(APIEndpoint.getCategoryList), .post)
        viewModel.getCategoryList_API(Domain.baseUrl().appending(APIEndpoint.getCategoryList), .post, param)
        clouserSetup()
        
    }
    
    func clouserSetup(){
        
        
        viewModel.reloadList = { () in
            self.setDataOnScreen()
            self.fetchCategoryData()
        }
        
        viewModel.errorMessage = { (message) in
            print(message)

            if message.contains("URLSessionTask failed with error"){
                self.getresAndStoreDetailService()
            }else{
                self.lblNoItem.isHidden = true
                CommonClass.sharedInstance.callNativeAlert(title: "", message: message, controller: self)
            }
            
        }
        
        viewModel.success = {(message) in
           print(message)
            
            self.configureCollection((self.viewModel.groceryBaseArr.first?.Data)!)

        }
        
        viewModel.reloadCollection = { () in
            self.configureColl()
            
            if self.viewModel.groceryBaseArr.first?.Data?.count == 0 {
                self.lblNoItem.isHidden = false

            }else{
                self.lblNoItem.isHidden = true

            }
            

            
            self.configureCollection((self.viewModel.groceryBaseArr.first?.Data)!)

        }
       
    }
    
   
    
}
