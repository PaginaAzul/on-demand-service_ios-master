//
//  OffersNew_VC+CollectionView.swift
//  Joker
//
//  Created by User on 29/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//
import Foundation
import CHTCollectionViewWaterfallLayout


//MARK: - Extension UICollectionView Delegates
//TODO:
extension OffersNew_VC : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        deconfigAutoscrollTimer()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.configAutoscrollTimer()

        }
        
        var textHeader:String?
        var storeId: String?
        
        let vc = ScreenManager.OfferListNew_VC()
       
        if collectionView.tag == 0{
            /*

            textHeader = self.rightDataModelArr[indexPath.row % rightDataModelArr.count].name ?? ""
            storeId = self.rightDataModelArr[indexPath.row % rightDataModelArr.count].Id ?? ""
 */
            print("storeId" , storeId)
            
            
            textHeader = self.rightDataModelArr[indexPath.row].name ?? ""
            storeId = self.rightDataModelArr[indexPath.row].Id ?? ""
        }else{
 /*
            textHeader = self.leftDataModelArr[indexPath.row % self.leftDataModelArr.count].name ?? ""
            storeId = self.leftDataModelArr[indexPath.row % self.leftDataModelArr.count].Id ?? ""
            print("storeId" , storeId)
 */
            
            textHeader = self.leftDataModelArr[indexPath.row].name ?? ""
            storeId = self.leftDataModelArr[indexPath.row].Id ?? ""
             
            
        }
        
        
        vc.storeCategoryId = storeId
        vc.headerText = textHeader ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
     
        
        
    }
    
    //SetUp WaterFall CollectionView
    func setupCollectionView(){
        
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumColumnSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        // Collection view attributes
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.alwaysBounceVertical = true
        collectionView.collectionViewLayout = layout
        
        // collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
        // Add the waterfall layout to your collection view
        
        
    }
    
}

//MARK - Imp
//** INFINITE COLLECTION VIEW **//
// TODO: RESOURCE - /* https://medium.com/@satindersingh71/infinite-uicollectionview-b706c939ed3c */

//MARK: - Extension UICollectionView DataSource
//TODO:
extension OffersNew_VC: UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout{
    
    //** Number of Cells in the CollectionView */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView.tag == 1 {
            
            return self.leftDataModelArr.count  //infiniteSizeLeft

        }else{
            
            return  self.rightDataModelArr.count //infiniteSizeRight  //model.images.count

        }
        
        
    }
    
    //** Create a basic CollectionView Cell */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if collectionView.tag == 1{
            
            // Create the cell and return the cell
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageUICollectionViewCell
            
             //cell1.productOfferItem = self.leftDataModelArr[indexPath.row  % leftDataModelArr.count]
            
              cell1.productOfferItem = self.leftDataModelArr[indexPath.row]
            
            return cell1
            
        }else{
           
            // Create the cell and return the cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageUICollectionViewCell
            
            //cell.productOfferItem = self.rightDataModelArr[indexPath.row % rightDataModelArr.count]
            
            cell.productOfferItem = self.rightDataModelArr[indexPath.row]
            
            return cell
            
        }
        
       
        /*
        // Add image to cell
        cell.image.image = model.images[indexPath.row]
        cell.lblCategory.text = newArr[indexPath.row]
        
        cell.image.cornerRadius = 6
        cell.image.layer.masksToBounds = true
        
        cell.blackView.cornerRadius = 6
        cell.blackView.layer.masksToBounds = true
        cell.layer.cornerRadius = 6
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.clear.cgColor
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.layer.shadowColor = UIColor.clear.cgColor
        
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        */
        
    }
    
    
    
    //MARK: - CollectionView Waterfall Layout Delegate Methods (Required)
    //** Size for the cells in the Waterfall Layout */
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // create a cell size from the image size, and return the size
        let  imageSize = model.images[0].size
        var returnSize = CGSize(width: imageSize.width, height: imageSize.height/2)
      /*
        let cell = collectionView.cellForItem(at: indexPath) as? ImageUICollectionViewCell
        cell?.image.frame.size.height
        let heightOFImage = cell?.image.frame.size.height
*/
        
        print("--- Height---",self.collectionView.frame.height )
        return returnSize
    }
     
   */
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 0{
            
            //MARK:- Priyanka Code
            //TODO:- Start
            let noOfCellsInRow = 1

            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

            return CGSize(width: size   , height: size - 5)
             //TODO:- End
            
        }else
        {
            //MARK:- Priyanka Code
            //TODO:- Start
            let noOfCellsInRow = 1

            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

            return CGSize(width: size   , height: size + 50)
             //TODO:- End
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        collectionView.recenterIfNeeded()
        collectionViewLeft.recenterIfNeeded()

    }
     
}
