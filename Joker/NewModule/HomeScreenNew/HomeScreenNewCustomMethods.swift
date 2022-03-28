//
//  HomeScreenNewCustomMethods.swift
//  Joker
//
//  Created by cst on 23/10/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation


extension HomeScreenNew_VC{
    
    //TODO: Register Nib method
     func registerNib(){
        
        self.tblViewHome.register(UINib(nibName:  "HomeTableCell", bundle: nil), forCellReuseIdentifier:  "HomeTableCell")
        
        tblViewHome.delegate = self
        tblViewHome.dataSource = self
        tblViewHome.separatorStyle = .none
        self.tblViewHome.tableFooterView = UIView()
        self.txtFieldHeader.textColor = AppColor.whiteColor
        self.viewHeader.backgroundColor = AppColor.themeColor
        self.tblViewHome.reloadData()
    }
    
    
    //MARK: - Exclusive APi
    //TODO: GET EXCLSUIVE OFFERS DATA
    func getapiService(){
        //Loader
        
        IJProgressView.shared.showProgressView(view: commonController.view)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            //30.748770396066835
            //76.75619602203369
//            GloblaLat = "30.748770396066835"
//            GloblaLong = "76.75619602203369"
            let param = [
                         "latitude":GloblaLat,
                         "longitude":GloblaLong,
                "langcode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,
            ] as [String:Any]
            
            self.viewModel.getExclusiveOfferListService(Domain.baseUrl().appending(APIEndpoint.ExclusiveOfferList), param)
           // viewModel.getExclusiveOfferListService(Domain.baseUrl().appending(APIEndpoint.ExclusiveOfferList))
            self.closerSetup()
        }
       
        
    }
    
    //MARK: - CLOSURE FOR EXCLUSIVE
    //TODO:
    func closerSetup(){
        
        viewModel.reloadList = {() in
            self.registerNib()
        }
        viewModel.reloadCollection = {() in
            self.getRestaurantAndStoreData()
        }
       
        viewModel.errorMessage = { (message) in
            print(message)
        }
        
        viewModel.cartCount = {(count , type) in
             setBage(self.btnCart, "\(count)")
        }
    }
    
    
    func getCountV(){
        
        let param = ["userId" : UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
        viewModel.getCartCountAPI(Domain.baseUrl().appending(APIEndpoint.getCartCount), param)
        self.closerSetup()
        
    }
    
    //MARK: - getRestaurantAndStoreData API
    //TODO: - GET RESTAURENTS DETAILS AND LIST
    func getRestaurantAndStoreData(){
    
    let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        
     //  GloblaLat = "30.748770396066835"
     //   GloblaLong = "76.75619602203369"
    
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                         "latitude":GloblaLat,
                         "longitude":GloblaLong,
                         "langcode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,] as [String:Any]
            viewModel.getRestaurantAndStoreDataService(Domain.baseUrl().appending(APIEndpoint.getRestaurantAndStoreData), param,header)

        }else{
            let param = [
                         "latitude":GloblaLat,
                         "longitude":GloblaLong,
                "langcode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,] as [String:Any]
            viewModel.getRestaurantAndStoreDataService(Domain.baseUrl().appending(APIEndpoint.getRestaurantAndStoreData), param)

        }
    closerSetup()
    }
    
}



