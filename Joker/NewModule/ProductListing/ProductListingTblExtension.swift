//
//  ProductListingTblExtension.swift
//  Joker
//
//  Created by User on 24/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation

///// New code


//MARK: - UITableViewDelegate
//TODO:
extension ProductListingNew_VC : UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

//MARK: - UITableViewDataSource
extension ProductListingNew_VC : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //return self.viewModel.productBaseModelArr.first?.Data?.productList?.count ?? 0
        return self.productListArr?.count ?? 0
        //return myCartModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCellAndXib", for: indexPath) as! CartTableViewCellAndXib
     
       // cell.productListModel = self.viewModel.productBaseModelArr.first?.Data?.productList?[indexPath.row]
        cell.productListModel = self.productListArr?[indexPath.row]
        cell.btnPlusRef.tag = indexPath.row
        cell.btnMinusRef.tag = indexPath.row
        cell.updateCartCountDelegate = self
        cell.closingTime = closingTime
        cell.cellType = CellType.grocery
        cell.vc = self
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ScreenManager.ProductDetailVC()
        vc.comgFromOffer  = true
        
       // vc.productId = self.viewModel.productBaseModelArr.first?.Data?.productList?[indexPath.row].Id
        
        vc.productId = self.productListArr?[indexPath.row].Id
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
    

}


extension ProductListingNew_VC:UITextFieldDelegate{
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if string.isEmpty
        {
            search = String(search.characters.dropLast())
        }
        else
        {
            search=textField.text!+string
        }
        
        print(search)
        
        var predicate = NSPredicate()
        
        if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
            
            predicate = NSPredicate(format: "SELF.portugueseSubCategoryName CONTAINS[cd] %@", search)
        }
        else{
            
            predicate = NSPredicate(format: "SELF.subCategoryName CONTAINS[cd] %@", search)
        }
               
        if search != "" {
            if search != "" {
                productListArr = (self.viewModel.productBaseModelArr.first?.Data?.productList?.filter {data in
                    
                    return (data.productName?.lowercased().contains(search.lowercased()) ?? false)
                    
                } ?? [ProductList]())
            }else{
                self.productListArr = self.viewModel.productBaseModelArr.first?.Data?.productList
            }
        }else{
            self.productListArr = self.viewModel.productBaseModelArr.first?.Data?.productList
        }
        
        tblView.reloadData()
        return true
    }
}
