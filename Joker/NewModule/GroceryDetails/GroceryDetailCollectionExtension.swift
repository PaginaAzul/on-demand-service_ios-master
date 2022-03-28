//
//  GroceryDetailTableExtension.swift
//  Joker
//
//  Created by User on 24/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation
import UIKit

//MARK:- UICollectionView delegate & dataSource
//TODO:-
extension GroceryDetailVC:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoriesCollectionViewCell
        
        cell.categoryData =  self.tblArr?[indexPath.row] //self.viewModel.groceryBaseArr.first?.Data?[indexPath.row]
       
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = ScreenManager.SubCategoriesVC()
        vc.categoryId =  self.tblArr?[indexPath.row].Id ?? ""  //self.viewModel.groceryBaseArr.first?.Data?[indexPath.row].Id ?? ""
        vc.resAndStoreId = self.id
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



extension GroceryDetailVC : UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
       // return self.viewModel.groceryBaseArr.first?.Data?.count ?? 0
        
        return self.tblArr?.count ?? 0
    }
    
}
