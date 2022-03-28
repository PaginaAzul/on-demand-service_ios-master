//
//  RestaurentDetailsCustomMethodsExtension.swift
//  JustBite
//
//  Created by Aman on 13/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import Foundation
import UIKit

extension RestaurentDetailsVC{
    
    func configureColl(){
        self.lblNoItem.isHidden = true

        collectionview.isHidden = false
        collectionview.delegate = self as? UICollectionViewDelegate
        collectionview.dataSource = self as? UICollectionViewDataSource
        
        let collectionLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionLayout.scrollDirection = .vertical
        
        let yourWidth = collectionview.bounds.width/2.0
        let yourHeight = yourWidth
        
        collectionLayout.itemSize = CGSize(width: yourWidth , height: yourHeight)
        
        collectionview.collectionViewLayout = collectionLayout
        collectionLayout.minimumInteritemSpacing = 1
        collectionLayout.minimumLineSpacing = 5
        
    }
    
    //MARK:- getresAndStoreDetailService...
    func getresAndStoreDetailService(){
        
        commonController = self
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                         "resAndStoreId": self.id,
                         "langcode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,
                         "latitude":GloblaLat,
                         "longitude":GloblaLong] as [String:Any]
            viewModel.fetchResAndStoreDetailService(Domain.baseUrl().appending(APIEndpoint.resAndStoreDetail), param,header)
        }
        else{
            
            let param = [
                "resAndStoreId": self.id,
                "langcode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,
                "latitude":GloblaLat,
                "longitude":GloblaLong] as [String:Any]
            viewModel.fetchResAndStoreDetailService(Domain.baseUrl().appending(APIEndpoint.resAndStoreDetail), param)
        }

        self.clouserSetup()
    }
    
    //MARK:- getMenuDataService...
    
    func fetchMenuData(_ item: String){
        commonController = self
        
        
        self.viewModel.menuListArray.removeAll()
        
        let param = [
                     "resAndStoreId": self.id,
                     ] as [String:Any]
        
        viewModel.getCuisinesListAPI(Domain.baseUrl().appending(APIEndpoint.getCuisineListForUser), param)
        clouserSetup()
        
        /*
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                         "resAndStoreId": self.id,
                         "langcode":"en",
                         "cuisine":item] as [String:Any]
            
            viewModel.getMenuDataService(Domain.baseUrl().appending(APIEndpoint.getMenuData), param,header)

        }else{
            
            let param = [
                "resAndStoreId": self.id,
                "langcode":"en",
                "cuisine":item] as [String:Any]
            
         //   viewModel.getMenuDataService(Domain.baseUrl().appending(APIEndpoint.getMenuData), param)
            
        }
        
        */
        
    }
    
    func clouserSetup(){
        
        viewModel.reloadList = { () in
            self.setDataOnScreen()
            /*
            let cuisineName = self.viewModel.ResAndStoreDetailArray.first?.Data?.resAndStoreDetail?.cuisinesName ?? []
            self.categoryDataModelArray.removeAll()
            for i in 0..<cuisineName.count{
                if i == 0{
                    self.categoryDataModelArray.append(CategoryDataModel(type: "", id: "", menuCount: "", name: cuisineName[i], isSelected: true, index: 0))
                }else{
                    self.categoryDataModelArray.append(CategoryDataModel(type: "", id: "", menuCount: "", name: cuisineName[i], isSelected: false, index: 0))
                }
            }
            */
            self.fetchMenuData("")
            
        }
        
        viewModel.errorMessage = { (message) in
            print(message)
            self.lblNoItem.isHidden = true
            CommonClass.sharedInstance.callNativeAlert(title: "", message: message, controller: self)
        }
        
        viewModel.success = {(message) in
           print(message)
            
            if self.viewModel.cuisineBaseModelArr.first?.Data?.count != 0 {
                self.lblNoItem.isHidden = true
                self.configCollection((self.viewModel.cuisineBaseModelArr.first?.Data)!)
            }else{
                self.lblNoItem.isHidden = false
            }

            
        }
    }
}


extension RestaurentDetailsVC :UIScrollViewDelegate{
   
    
}
