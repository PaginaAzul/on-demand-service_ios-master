//
//  OffersNew_VC+Methods.swift
//  Joker
//
//  Created by User on 29/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation


//MARK: - Custom Methods
//TODO:
extension OffersNew_VC {
 

    
}

//MARK: - AutoScroll Delegates
//TODO:
extension OffersNew_VC{
    
    func configAutoscrollTimer()
    
    {
        timr = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(autoScrollView), userInfo: nil, repeats: true)
        
        timerLeft = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(autoScrollViewLeft), userInfo: nil, repeats: true)
    }
    
    func deconfigAutoscrollTimer(){
        w = 0.0 ; wLeft = 0.0
        timr.invalidate()
        timerLeft.invalidate()
    }
    
    @objc func autoScrollView(){
        
        let initailPoint = CGPoint(x: 0,y :w)
        
        if __CGPointEqualToPoint(initailPoint, self.collectionView.contentOffset){
            if w<collectionView.contentSize.height{
                w += 0.5
            }else{
                w = 0.0
            }
            
            let offsetPoint = CGPoint(x: 0,y :w)
            
            collectionView.contentOffset=offsetPoint
        }else{
            w = collectionView.contentOffset.y
        }
    }
    
    
    @objc func autoScrollViewLeft(){
        
        let initailPoint = CGPoint(x: 0,y :wLeft)
        
        if __CGPointEqualToPoint(initailPoint, self.collectionViewLeft.contentOffset){
            if wLeft<collectionViewLeft.contentSize.height
            {
                wLeft += 0.5
            }else{
                wLeft = 0.0
                //  self.collectionView.reloadData()
                //wLeft = -self.view.frame.size.height/3
            }
            
            
            let offsetPoint = CGPoint(x: 0,y :wLeft)
            
            collectionViewLeft.contentOffset=offsetPoint
            
        }else{
            
            wLeft = collectionViewLeft.contentOffset.y
        }
    }
}

extension OffersNew_VC:UITextFieldDelegate{
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        deconfigAutoscrollTimer()
        
        if string.isEmpty{
            search = String(search.characters.dropLast())
        }else{
            search=textField.text!+string
        }
        
        print(search)
        
        
        if search != "" {
            
            self.filterModelArr = (self.viewModel.offerCategoryBaseModelArr.first?.Data?.filter {data in
                
                return (data.name?.lowercased().contains(search.lowercased()) ?? false)
                
            } ?? [OfferCategoryData]())
            
        }else{
            self.filterModelArr = (self.viewModel.offerCategoryBaseModelArr.first?.Data)!
        }
        
        leftDataModelArr.removeAll()
        rightDataModelArr.removeAll()
        
        
        for i in 0..<(filterModelArr.count) {
            if i%2 == 0{
                leftDataModelArr.append((filterModelArr[i]))
            }else{
                rightDataModelArr.append((filterModelArr[i]))
            }
        }
 
        
        if leftDataModelArr.count != 0 {
            
//            while leftDataModelArr.count < 10 {
//
//                for i in 0..<leftDataModelArr.count {
//
//                    leftDataModelArr.append(leftDataModelArr[i])
//
//                }
//
//                for i in 0..<rightDataModelArr.count {
//
//                    rightDataModelArr.append(rightDataModelArr[i])
//
//                }
//
//            }
            
        }
       
        if rightDataModelArr.count != 0
{
//            while rightDataModelArr.count < 10
//            {
//                for i in 0..<rightDataModelArr.count
//                {
//                    rightDataModelArr.append(rightDataModelArr[i])
//                }
//            }
        }
       
        print("Count On Searching on left Array", leftDataModelArr.count ,rightDataModelArr.count )
        
        /*
        infiniteSizeLeft = leftDataModelArr.count * 100000
        infiniteSizeRight = rightDataModelArr.count * 1000000
      
        let midIndexPathLeft = IndexPath(row: infiniteSizeLeft, section: 0)
        let midIndexPathRight = IndexPath(row: infiniteSizeRight, section: 0)

        collectionView.scrollToItem(at: midIndexPathRight,
                                         at: .centeredVertically,
                                         animated: false)
        
        collectionViewLeft.scrollToItem(at: midIndexPathLeft,
                                        at: .centeredVertically,
                                        animated: false)
        */
        

       
        self.collectionViewLeft.reloadData()
        self.collectionView.reloadData()
        
       //
        
        if self.filterModelArr.count == self.viewModel.offerCategoryBaseModelArr.first?.Data?.count {
            self.configAutoscrollTimer()
        }
        
        return true
    }
    
}
