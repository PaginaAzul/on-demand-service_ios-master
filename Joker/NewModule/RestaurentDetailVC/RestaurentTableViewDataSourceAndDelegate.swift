//
//  RestaurentTableViewDataSourceAndDelegate.swift
//  JustBite
//
//  Created by Aman on 13/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import Foundation
import UIKit

extension RestaurentDetailsVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension

    }
    
}

extension RestaurentDetailsVC:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.tblArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblCart.dequeueReusableCell(withIdentifier: CartTableViewCellAndXib.className) as! CartTableViewCellAndXib
           
        
        cell.btnPlusRef.tag = indexPath.row
        
        cell.btnMinusRef.tag = indexPath.row
      
       // cell.itemMenuList = self.tblArr?[indexPath.row]
        cell.cellType = CellType.restaurant
        cell.btnCustomizeRef.isHidden = true
        cell.vc = self

        return cell
    }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
}



// MARK: - Search extensions

extension RestaurentDetailsVC:UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if searchBar.text == ""{
            searchActive = false
        }else{
            searchActive = true
        }
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        if searchBar.text?.isEmpty ?? false{
        searchActive = false
        
        self.searchBar.endEditing(true)
        isSearchBarHidden = false
        searchBar.isHidden = true
        btnCancelSearchRef.isHidden = false
        
        searchBar.text = String()
        lblMEnu.isHidden = false
        btnSearch.isHidden = false
        }
        //tblCart.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterContentForSearchText(searchText: searchText)
        
        self.configCollection(self.filterArr ?? [DataCuisines]())
        
        //self.configTable(self.filterArr ?? [MenuList]())
    }
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if searchText != "" {
            
            filterArr = (self.viewModel.cuisineBaseModelArr.first?.Data?.filter {data in
                
                return (data.name?.lowercased().contains(searchText.lowercased()) ?? false)
                
            } ?? [DataCuisines]())
        }else{
            self.filterArr = self.viewModel.cuisineBaseModelArr.first?.Data
        }
        //else { self.filterArr = self.providerArr!}
    }

}
