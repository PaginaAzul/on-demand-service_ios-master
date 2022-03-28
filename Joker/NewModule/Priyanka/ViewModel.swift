//
//  ViewModel.swift
//  Joker
//
//  Created by User on 03/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation
import UIKit

class ViewModel: NSObject{
    
    let apiHandle = ApiHandler()
    // Closures
    var success = {(message :String) -> () in }
    var errorMessage = {(message : String) -> () in }
    var reloadList = {() -> () in }
    var reloadCollection = {() -> () in}
    var cartCount = {(count:Int , type:String) -> () in }
    
    //HomeScreen Service Data Source
    
    var homeDataArray = [HomeBaseModel]()
    
    func getRestaurantAndStoreDataService(_ strUrl:String,_ params:[String:Any]? = nil,_ header:[String:String]? = nil){
        
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: params, header: header) { (result) in
            switch result {
            
            case .success( let data):
                print(data)
                
                if self.homeDataArray.count > 0 {
                    self.homeDataArray.removeAll()
                }
                self.homeDataArray.append(HomeBaseModel(data))
                
                if self.homeDataArray.first?.responseMessage == "List found successfully"{
                    
                    self.reloadList()
                    
                }else{
                    self.errorMessage(self.homeDataArray.first?.responseMessage ?? "")
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }
                
                
                break
            }
        }
        
    }
    
    //Offer Data Source
    
    var offerDataArray = [ExclusiveOfferListModel]()
    
    func getExclusiveOfferListService(_ strUrl:String,_ params:[String:Any]? = nil,_ header:[String:String]? = nil){
        
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: params, header: header) { (result) in
            
            switch result{
            case .success(let data):
                print(data)
                
                if self.offerDataArray.count > 0 {
                    self.offerDataArray.removeAll()
                }
                self.offerDataArray.append(ExclusiveOfferListModel(data))
                
                if  self.offerDataArray.first?.status == "SUCCESS"{
                    self.reloadCollection()
                }else{
                    self.errorMessage(self.offerDataArray.first?.responseMessage ?? "")
                }
                break
            case .failure(let error):
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }
                break
            }
        }
    }
    
    // ResAndStoreDetail Data Source
    
    var ResAndStoreDetailArray = [ResAndStoreDetailBaseModel]()
    
    func fetchResAndStoreDetailService(_ strUrl:String,_ params:[String:Any]? = nil,_ header:[String:String]? = nil){
        
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: params, header: header) { (result) in
            switch result{
            case .success(let data):
                
                print(data)
                
                if self.ResAndStoreDetailArray.count > 0 {
                    self.ResAndStoreDetailArray.removeAll()
                }
                
                self.ResAndStoreDetailArray.append(ResAndStoreDetailBaseModel(data))
                
                if  self.ResAndStoreDetailArray.first?.responseMessage == "Detail found successfully"{
                    self.reloadList()
                }else{
                    self.errorMessage(self.ResAndStoreDetailArray.first?.responseMessage ?? "")
                }
                
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }
                break
            }
        }
    }
    
    // MenuList DataSource
    
    var menuListArray = [MenuListDataModel]()
    
    func returnMenuRow() -> Int{
        var count:Int = 0
        for item in menuListArray{
            if item.Data?.menuList?.count ?? 0 > 0{
                count += 1
            }
        }
        return count
    }
    var restaurantBaseModelArr = [RestaurantBaseModel]()
    func getMenuDataService(_ strUrl:String,_ passData:[String:Any],_ header:[String:String]? = nil){
        
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: passData, header: header) { (result) in
            switch result{
            case .success(let data):
                print("MenuData.................\(data)")

                self.restaurantBaseModelArr.append(RestaurantBaseModel(data))
                
                if self.restaurantBaseModelArr.first?.status == "SUCCESS"{
                    self.success("reload Restaurant List")
                }else{
                    self.errorMessage(self.restaurantBaseModelArr.first?.responseMessage ?? "")
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }
                break
            }
        }
    }
    
    
    var cuisineBaseModelArr = [CuisineBaseModel]()
    func getCuisinesListAPI(_ strUrl:String,_ passData:[String:Any],_ header:[String:String]? = nil){
        
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: passData, header: header) { (result) in
            switch result{
            case .success(let data):
                print(data)
              
                self.cuisineBaseModelArr.append(CuisineBaseModel(data))
                
                if self.cuisineBaseModelArr.first?.responseMessage == "Cuisine list found successfully"{
                    self.success("Cuisine list found successfully")
                }else{
                    self.errorMessage(self.menuListArray.first?.responseMessage ?? "")
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }
                break
            }
        }
    }
    
    
    //Search Service Data Source
    
    var searchDataArray = [SearchBaseModel]()
    
    func getRestaurantAndStoreDataForSearch(_ strUrl:String,_ params:[String:Any]? = nil,_ header:[String:String]? = nil){
        
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: params, header: header) { (result) in
            switch result {
            
            case .success( let data):
                print(data)
                
                if self.searchDataArray.count > 0 {
                    self.searchDataArray.removeAll()
                }
                self.searchDataArray.append(SearchBaseModel(data))
                
                if self.searchDataArray.first?.responseMessage == "List found successfully"{
                    
                    self.reloadList()
                    
                }else{
                    self.errorMessage(self.searchDataArray.first?.responseMessage ?? "")
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }
                break
            }
        }
        
    }
    
    //MyCart Data source
    
    var myCartDataArray = [CartItemBaseModel]()
    var deliveryChargeArray = [DeliveryChargeDataModel]()
    
    func getCartItemService(_ strUrl:String,_ params:[String:Any]? = nil,_ header:[String:String]? = nil){
        
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: params, header: header) { (result) in
            switch result {
            
            case .success( let data):
                print("Data.cartItem Service................\(data)")
                
                if self.myCartDataArray.count > 0 {
                    self.myCartDataArray.removeAll()
                }
                self.myCartDataArray.append(CartItemBaseModel(data))
                
                if self.myCartDataArray.first?.status == "SUCCESS"{
                    
                    self.reloadList()
                    
                }else{
                    self.errorMessage(self.myCartDataArray.first?.responseMessage ?? "")
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }
                break
            }
        }
    }
    
    //Favt Service Data Source
    
    var favtDataArray = [MyFavouriteListBaseModel]()
    
    func getFavouriteListService(_ strUrl:String,_ params:[String:Any]? = nil,_ header:[String:String]? = nil){
        
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: params, header: header) { (result) in
            switch result {
            
            case .success( let data):
                print(data)
                if self.favtDataArray.count > 0 {
                    self.favtDataArray.removeAll()
                }
                self.favtDataArray.append(MyFavouriteListBaseModel(data))
                if self.favtDataArray.first?.status == "SUCCESS"{
                    self.reloadList()
                }else{
                    self.errorMessage(self.favtDataArray.first?.responseMessage ?? "")
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }
                break
            }
        }
        
    }
    
    func getPlaceOrder(_ strUrl:String,_ params:[String:Any]? = nil,_ header:[String:String]? = nil){
        
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: params, header: header) { (result) in
            switch result {
            
            case .success( let data):
                
                print(data)
                if data["status"].stringValue == "SUCCESS" {
                    self.success(data["response_message"].stringValue)
                }else{
                    self.errorMessage(data["response_message"].stringValue)
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }
                break
            }
        }
        
    }
    
    
    var getOrderRootArray = [GetOrderRoot]()
    func getOrderAPI(_ strURL : String , _ param:[String:Any]? = nil , _ header:[String:String]? = nil){
        
        //IJProgressView.shared.showProgressView(view: commonController.view)
        
        apiHandle.fetchApiService(method: .post, url: strURL, passDict: param, header: header) { (result) in
            
            IJProgressView.shared.hideProgressView()
            
            switch result {
            
            case .success(let data):
                
                print(data)
                
                self.getOrderRootArray.removeAll()
                
                self.getOrderRootArray.append(GetOrderRoot(data))
                
                if data["response_message"] == "Order list found successfully" {
                    self.reloadList()
                }else{
                    self.errorMessage(data["response_message"].stringValue)
                }
                
                break
                
            case .failure(let error):
                
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }
                break
                
            }
            
        }
    }
    
    func updateCancelStatusAPI(_ strUrl:String , _ param:[String:Any]? = nil , _ header:[String:String]? = nil){
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: param, header: header) { (result) in
            
            switch result {
            
            case .success(let data):
               print(data)
                break
            
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }
            
                break
            }
            
        }
    }
    
    func cancelOrderAPI(_ strUrl:String , _ param:[String:Any]? = nil , _ header:[String:String]? = nil){
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: param, header: header) { (result) in

            print("Cancel Order - API---",result)
            
            switch result {

            case .success(let data):
                
                
                if data["status"] == "SUCCESS" {
                  //  self.reloadList()
                    self.success(data["response_message"].stringValue)
                }
                break

            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }

                break
            }

        }
    }
    
    func getCartCountAPI(_ strUrl:String , _ param:[String:Any]? = nil , _ header:[String:String]? = nil){
        
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: param, header: header) { (result) in
            
            switch result {
            
            case .success(let data):
                
                print("Cart Count -->",data)
                
                if data["status"] == "SUCCESS" {
                        self.cartCount(data["Data"].intValue, data["Type"].stringValue)
                   // }
                }else{
                    self.errorMessage(data["response_message"].stringValue)
                }
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }
                break
                
            }
            
        }
    }
    
    
    func getDeliveryChargeAPI(_ strUrl:String , _ param:[String:Any]? = nil , _ header:[String:String]? = nil){
        
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: param, header: header) { (result) in
            
            switch result {
            
            case .success(let data):
                
                print("Delivery Charge API -->",data)
                if self.deliveryChargeArray.count > 0 {
                    self.deliveryChargeArray.removeAll()
                }
                self.deliveryChargeArray.append(DeliveryChargeDataModel(data))
                
                if self.deliveryChargeArray.first?.status == "SUCCESS"{
                    
                    self.success("Delivery Charge")
                }else{
                    self.success(self.deliveryChargeArray.first?.responseMessage ?? "")
                }
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }
                break
                
            }
            
        }
    }
    
    func getClearCartAPI(_ strUrl:String , _ param:[String:Any]? = nil , _ header:[String:String]? = nil){
        
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: param, header: header) { (result) in
            
            switch result {
            
            case .success(let data):
                
                print("Clear Cart API -->",data)
                
                if data["response_message"] == "Item removed successfully" {
                    self.success("Clear cart successfull")

                }else{
                    self.errorMessage(data["response_message"].stringValue)
                }
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }
                break
                
            }
            
        }
    }
    var customerStoriesArr = [CustomerStories]()
    func getCustomerStoryAPI(_ strUrl:String , _ param:[String:Any]? = nil , _ header: [String:String]? = nil)
    {
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: param, header: header) { (result) in
            
            switch result {
                
            case .success(let data):
                self.customerStoriesArr.removeAll()

                if data["response_message"] == "Story found successfully" {
                    let item = CustomerStories(data)
                    self.customerStoriesArr.append(item)
                    
                    self.reloadList()

                }else{
                    self.errorMessage(data["response_message"].stringValue)
                }
                
                break
            
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }
                break
                
            }
        }
    }
    
    
    func resAndStoreRatingAPI(_ strUrl:String , param:[String:Any]? = nil , header:[String:String]? = nil ){
        
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: param, header: header) { (result) in

            print("resAndStoreRatingAPI -> API---",result)
            
            switch result {

            case .success(let data):
                
                print(data)
                
                if data["status"] == "SUCCESS" {
                    //self.reloadList()
                    self.success(data["response_message"].stringValue)

                }else{
                    self.errorMessage(data["response_message"].stringValue)
                }
                
                break

            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }

                break
            }

        }
        
    }
    
    
    func reOrder_API(_ strUrl:String , param:[String:Any]? = nil , header:[String:String]? = nil){
        
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: param, header: header) { (result) in

            print("reOrder_API -> API---",result)
            
            switch result {

            case .success(let data):
                
                print(data)
                
                if data["status"] == "SUCCESS" {
                    self.reloadList()
                }else{
                    self.errorMessage(data["response_message"].stringValue)

                }
                
                break

            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }

                break
            }
        }
    }

    
    var groceryBaseArr = [GroceryCategoryBase]()
    func getCategoryList_API(_ strUrl:String , _ method: Method , _ param :[String:Any]? = nil ){
        
        apiHandle.fetchApiService(method:method , url: strUrl, passDict: param, header: nil) { (result) in
            
            switch result {
            
            case .success(let data):

                self.groceryBaseArr.removeAll()
                
                if data["response_code"] == 200 {
                    
                    
                    print("data=--", data)
                    let item = GroceryCategoryBase(data)
                    self.groceryBaseArr.append(item)
                    
                    self.reloadCollection()
                }else{
                    self.errorMessage(data["response_message"].stringValue)
                }

                break
                
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }

                break
                
            }
        }
        
    }
    
    
    var productBaseModelArr = [ProductBaseModel]()
    func productList_API(_ strUrl:String, _ param:[String:Any]? = nil , _ header:[String:String]? = nil){
        
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: param, header: header) { (result) in
            
            switch result {
            case .success(let data) :
                
                print("data from the api...........\(data)")
                self.productBaseModelArr.removeAll()

                if data["status"] == "SUCCESS" {
                    self.productBaseModelArr.removeAll()

                    let item = ProductBaseModel(data)
                    self.productBaseModelArr.append(item)
                    self.reloadCollection()
                    
                }else{
                    self.errorMessage(data["response_message"].stringValue)
                }
                
                print("getProductData--API",data)
                break
                
            case .failure(let error) :
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }


            break
            
            }
        }
    }
    
    var productDetailArr = [ProductDetailBaseModel]()
    func fetchProductDetail(_ strUrl:String , _ param:[String:Any]? = nil , _ header :[String : String]?  = nil ){
        
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: param, header: header) { (result) in
            switch result {
            
            case .success(let data):
                
                print(data)
                if data["status"] == "SUCCESS" {
                    self.productDetailArr.removeAll()

                    let item = ProductDetailBaseModel(data)
                    self.productDetailArr.append(item)
                    self.reloadList()

                }else{
                    self.errorMessage(data["response_message"].stringValue)
                }
                
                break
                
            case .failure(let error):
               print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }

                break
            }
        }
        
    }
    
    var getDeliverySlotBaseModelArr = [GetDeliverySlotBaseModel]()
    
    func getDeliverySlotListAPI(_ strUrl:String , _ param:[String:Any]? = nil , _ header:[String:String]? = nil){
        
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: param, header: header) { (result) in
            
            switch result{
            
            case .success(let data):
                
                self.getDeliverySlotBaseModelArr.removeAll()

                print("Response ---",data)
                
                if data["status"].stringValue == "SUCCESS" {
                    
                    self.getDeliverySlotBaseModelArr.append(GetDeliverySlotBaseModel(data))
                    self.reloadList()

                    
                }else {
                    self.errorMessage(data["response_message"].stringValue)
                }
                
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }

                break
                
            }
        }
    }
    
    
    var offerCategoryBaseModelArr = [OfferCategoryBaseModel]()
    func getOfferCategoryAPI(_ strUrl:String , _ param:[String:Any]? = nil , _ header:[String:String]? = nil){
        
        apiHandle.fetchApiService(method: .get, url: strUrl) { (result) in
            
            switch result {
            
            case .success(let data):
                
                self.offerCategoryBaseModelArr.removeAll()
                print(data)

                if data["response_message"].stringValue == "Category found successfully" {
                    
                    self.offerCategoryBaseModelArr.append(OfferCategoryBaseModel(data))
                    self.reloadList()
                    
                }else{
                    self.errorMessage(data["response_message"].stringValue)
                }
                
                break
                
            case .failure(let error):
                
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }
                break
            
            }
            
            
        }
        
    }
    
    
    var offerListBaseModelArr = [OfferListBaseModel]()
    func getOfferProductListAPI(_ strUrl:String , _ param:[String:Any]? = nil , _ header:[String :String]? = nil){
        
        apiHandle.fetchApiService(method: .post, url: strUrl, passDict: param, header: header) { (result) in
            
            switch result {
            
            case .success(let data):
                
                print(data)
                if data["response_message"].stringValue == "Offer list found successfully" {
                    print(data["response_message"].stringValue)
                    
                    if self.offerListBaseModelArr.count > 0 {
                        self.offerListBaseModelArr.removeAll()
                    }
                    self.offerListBaseModelArr.append(OfferListBaseModel(data))
                    print(OfferListBaseModel(data))
                    print(self.offerListBaseModelArr)
                    self.reloadList()
                }
                    
            
                    
                    
                else{
                    
                    self.errorMessage(data["response_message"].stringValue)
                    print(data["response_message"].stringValue)
                    
                }
                
                break
                
            case .failure(let error):
                print(error.localizedDescription)
                if error.localizedDescription == "URLSessionTask failed with error: The network connection was lost." {
                    self.errorMessage(error.localizedDescription)
                }
                else
                {
                    self.errorMessage(error.localizedDescription)
                }

            break
            }
            
            
        }
        
    }
    
    
    var date = Date()
    //MARK:- Custom Method to Find Time Difference
    func DateDiff(dateR:String,time:String) ->String {
        
        let dateFormatter = DateFormatter()
        var timeR = String()
        
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let currentDate = Date()
        dateFormatter.dateFormat =  "yyyy-MM-dd HH:mm:ss "
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let DateInFormat = dateFormatter.string(from: currentDate)
        
        print("\(DateInFormat) ")
        
        self.date = dateFormatter.date(from: "\(dateR) \(time)")!
        
        print("\(currentDate) , \(self.date)")
        
        let diff = Int(currentDate.timeIntervalSince1970 - self.date.timeIntervalSince1970)
        let Day = diff / (3600 * 24)
        let Hour = diff / 3600
        let minutes = (diff - Hour * 3600) / 60
        
        if (Day == 1){
            
            timeR = String(Day) + " day ago".localized()
            
        }else  if (Day > 1){
            
            timeR = String(Day) + " days ago".localized()
            
        }else if (Hour == 1){
            
            timeR = String(Hour) + " hour ago".localized()
        }else if (Hour > 1){
            
            timeR = String(Hour) + " hours ago".localized()
        }else if minutes == 1{
            
            timeR = String(minutes) + " min ago".localized()
        }else if minutes > 1{
            
            timeR = String(minutes) + " mins ago".localized()
        }else{
            
            timeR = "now".localized()
        }
        
        return timeR
        
    }
}
    

//MARK:- Time Conversion
//MARK:-
extension String{
    
    func timeDateConversionForInfo(formateDate:String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date = dateFormatter.date(from: formateDate == "" ? "2020-02-28T13:30:15" : formateDate)// create   date from string

        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: date!)
        
        print(timeStamp)
        
        return timeStamp
    }
    
}
