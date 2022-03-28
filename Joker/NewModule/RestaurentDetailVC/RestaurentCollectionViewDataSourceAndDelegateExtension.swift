//
//  RestaurentCollectionViewDataSourceAndDelegateExtension.swift
//  JustBite
//
//  Created by Aman on 14/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import Foundation
import UIKit

/*
extension RestaurentDetailsVC:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.index = indexPath.row
        self.catIndex = indexPath.row
        
        if categoryDataModelArray.contains(where: {$0.isSelected == true}){
            if let index = categoryDataModelArray.firstIndex(where: {$0.isSelected == true}){
                categoryDataModelArray[index].isSelected = false
                categoryDataModelArray[indexPath.row].isSelected = true
                self.collectionViewHeader.reloadData()
                self.fetchMenuData(self.categoryDataModelArray[indexPath.row].name)

            }
        }
 
    }
    

}

extension RestaurentDetailsVC:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryDataModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionViewHeader.dequeueReusableCell(withReuseIdentifier: CartCollectionViewCellAndXib.className, for: indexPath) as! CartCollectionViewCellAndXib
            
        cell.configureCollection(info: categoryDataModelArray[indexPath.row])
        return cell
    }
    

    
    
}

extension RestaurentDetailsVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let value = categoryDataModelArray.count

        if value == 1 {
            return CGSize(width: (self.collectionViewHeader.frame.width), height:self.collectionViewHeader.frame.height)

        }else if value == 2{
            return CGSize(width: (self.collectionViewHeader.frame.width/2), height:self.collectionViewHeader.frame.height)

        }else{
            return CGSize(width: (self.collectionViewHeader.frame.width/3), height:self.collectionViewHeader.frame.height)

        }
        
        
    }
    
    
    
}
*/

extension RestaurentDetailsVC:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoriesCollectionViewCell
        
        cell.itemCuisines =  self.tblArr?[indexPath.row]
       
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = ScreenManager.MenuListVC()
        vc.cuisineName =  self.tblArr?[indexPath.row].name ?? ""
        vc.id = self.tblArr?[indexPath.row].resAndStoreId ?? ""
        let data = self.viewModel.ResAndStoreDetailArray.first?.Data?.resAndStoreDetail
        //print("data...........\(data)")
        if let closingTime = data?.closingTime{
            vc.closingTime = closingTime
        }
       
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //MARK:- Priyanka Code
        //TODO:- Start
        let noOfCellsInRow = 2
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size   , height: size - 5)
        //TODO:- End
        
    }
    
}



extension RestaurentDetailsVC : UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
       // return self.viewModel.groceryBaseArr.first?.Data?.count ?? 0
        
        return self.tblArr?.count ?? 0
    }
    
}
