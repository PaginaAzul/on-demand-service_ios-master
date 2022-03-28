//
//  SubCategoriesColl.swift
//  Joker
//
//  Created by User on 24/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation

//MARK:- UICollectionViewDataSource
//TODO:-
extension SubCategoriesVC:UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoriesCollectionViewCell
        
        cell.categoryData =  self.groceryDataArr?[indexPath.row] //self.viewModel.groceryBaseArr.first?.Data?[indexPath.row]

        return cell
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ScreenManager.ProductListingNew_VC()
        vc.comgFromOffer = true
        vc.resAndStoreId =  self.resAndStoreId
        vc.subCategoryName =  self.groceryDataArr?[indexPath.row].name //self.viewModel.groceryBaseArr.first?.Data?[indexPath.row].name
        vc.closingTime = closingTime
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}

//MARK: - CollectionView Delegates
//TODO:
extension SubCategoriesVC : UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
       // return self.viewModel.groceryBaseArr.first?.Data?.count ?? 0
        
        
        return self.groceryDataArr?.count ?? 0
    }
    
    
    //TODO: - Configure CollectionView
   internal func configureColl(){
        
        let collectionLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionLayout.scrollDirection = .vertical
        
        let yourWidth = collectionview.bounds.width/2.0
        let yourHeight = yourWidth
        
        collectionLayout.itemSize = CGSize(width: yourWidth , height: yourHeight)
        
        collectionview.collectionViewLayout = collectionLayout
        collectionLayout.minimumInteritemSpacing = 1
        collectionLayout.minimumLineSpacing = 5
        
        collectionview.delegate = self
        collectionview.dataSource = self
        self.groceryDataArr = self.viewModel.groceryBaseArr.first?.Data
        collectionview.reloadData()
       
    }
    
}
