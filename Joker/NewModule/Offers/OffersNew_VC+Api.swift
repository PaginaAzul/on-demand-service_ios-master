//
//  OffersNew_VC+Api.swift
//  Joker
//
//  Created by User on 29/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation

//MARK: - API Calling Methods
//TODO:
extension OffersNew_VC {
 
    func getOfferCategoryApiCall(){
        viewModel.getOfferCategoryAPI(Domain.baseUrl().appending(APIEndpoint.getOfferCategory))
        closureSetup()
    }
    
    //** Capture ViewModel Data for ProductList  **//
    func closureSetup(){
        
        viewModel.reloadList = { [self] () in
            
            let yourWidth = self.collectionView.bounds.width/2.0
            let yourHeight = yourWidth
            
            /*
            let collectionLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            collectionLayout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 10)
            collectionLayout.scrollDirection = .vertical
            
             collectionLayout.itemSize = CGSize(width: yourWidth + 5 , height: yourHeight)
             
             self.collectionView.collectionViewLayout = collectionLayout
             collectionLayout.minimumInteritemSpacing = 1
             collectionLayout.minimumLineSpacing = 5
            */
            
          
            collectionView.setGallery(withStyle: .autoFixed, minLineSpacing: 5, itemSize: CGSize(width: yourWidth + 5, height: yourHeight + 50),minScaleFactor:1.0)
            
            self.collectionView.dataSource  = self
            self.collectionView.delegate = self
            self.collectionView.reloadData()

            filterModelArr = (self.viewModel.offerCategoryBaseModelArr.first?.Data)!
            
            for i in 0..<(filterModelArr.count) {
                if i%2 == 0{
                    leftDataModelArr.append((filterModelArr[i]))
                }else{
                    rightDataModelArr.append((filterModelArr[i]))
                }
            }
            
            while leftDataModelArr.count < 10 {

                for i in 0..<leftDataModelArr.count {
                    
                    leftDataModelArr.append(leftDataModelArr[i])
                    
                }
                
                for i in 0..<rightDataModelArr.count {
                    
                    rightDataModelArr.append(rightDataModelArr[i])
                    
                }
                
            }
            
            print("Count APi Data Both Array", leftDataModelArr.count ,rightDataModelArr.count )

            self.leftColletion()
            
            deconfigAutoscrollTimer()
            configAutoscrollTimer()
        }
    }
    
    func leftColletion(){
        /*
        let collectionLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 5)
        collectionLayout.scrollDirection = .vertical
        
        self.collectionViewLeft.collectionViewLayout = collectionLayout
        collectionLayout.minimumInteritemSpacing = 1
        collectionLayout.minimumLineSpacing = 5
         
         collectionLayout.itemSize = CGSize(width: yourWidth + 5 , height: yourHeight)

        */
        
        let yourWidth = self.collectionViewLeft.bounds.width/2.0
        let yourHeight = yourWidth
        
        collectionViewLeft.setGallery(withStyle: .autoFixed, minLineSpacing: 5, itemSize: CGSize(width: yourWidth + 5, height: yourHeight - 5),minScaleFactor:1.0)
        
        self.collectionViewLeft.dataSource  = self
        self.collectionViewLeft.delegate = self
        self.collectionViewLeft.reloadData()

    }
    
}

extension Array {
    init(repeating: (() -> Element), count: Int) {
        self = []
        for _ in 0..<count {
            self.append(repeating())
        }
    }
}
