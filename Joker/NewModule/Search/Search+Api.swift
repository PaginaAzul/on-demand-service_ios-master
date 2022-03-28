//
//  Search+Api.swift
//  Joker
//
//  Created by SinhaAirBook on 08/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation

//MARK:- Api
extension SearchNew_VC{
    
    func fetchRestaurantAndStoreDataForSearch(_ type:String){
        
        self.type = type
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                         "latitude":GloblaLat,
                         "longitude":GloblaLong,
                         "langcode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,
                         "type":type] as [String:Any]
            self.viewModel.getRestaurantAndStoreDataForSearch(Domain.baseUrl().appending(APIEndpoint.getRestaurantAndStoreDataForSearch), param,header)

        }else{
            let param = [
                "langcode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,
                "latitude":GloblaLat,
                "longitude":GloblaLong,
                "type":type] as [String:Any]
            self.viewModel.getRestaurantAndStoreDataForSearch(Domain.baseUrl().appending(APIEndpoint.getRestaurantAndStoreDataForSearch), param)

        }
       
        self.closerSetup()
        
    }
    //MARK: - CLOSURE FOR EXCLUSIVE
    //TODO:
    func closerSetup(){
        
        viewModel.reloadList = {() in
            //self.registerNib()
            self.configCollection((self.viewModel.searchDataArray.first?.Data?.restaurantList)!)
            
            self.searchBar.text = ""
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

}

//MARK:- UISearchBar

extension SearchNew_VC:UISearchBarDelegate{
    
   
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        if searchBar.text?.isEmpty ?? false{
        
        self.searchBar.endEditing(true)
        
        searchBar.text = String()
        
        }
        //tblCart.reloadData()
    }
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterContentForSearchText(searchText: searchText)
        self.configCollection(filterArr ?? [RestaurantList]())
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if searchText != "" {
            
            filterArr = (self.viewModel.searchDataArray.first?.Data?.restaurantList?.filter {data in
               
                return (data.name?.lowercased().contains(searchText.lowercased()) ?? false) || (cuisinesFilter(data: data.cuisinesName ?? [], text: searchText))
                
            } ?? [RestaurantList]())
        }else{
            self.filterArr = self.viewModel.searchDataArray.first?.Data?.restaurantList
        }
    }
    
    func cuisinesFilter(data: [String],text: String) -> Bool{
        var bool = false
        var exit = false
        for item in data {
            
            if exit == false{
                bool = (item.lowercased().contains(text.lowercased()) )
            }
            exit = bool == true ? true : false
        }
        return bool
    }
    
}

