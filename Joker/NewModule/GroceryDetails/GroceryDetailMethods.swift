//
//  GroceryDetailMethods.swift
//  Joker
//
//  Created by User on 24/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift

//MARK: - Custom Methods
//TODO:
extension GroceryDetailVC {
    
    
    func initialSetup(){
        
        btnFavRef.addTarget(self, action: #selector(btnFavTapped), for: .touchUpInside)
        reviewsRef.text = "\(0) (\(0) \("Reviews".localized()))"
        lblCategories.text = "Categories".localized()
        
        lblNoItem.font = UIFont.systemFont(ofSize: 17.0)
        lblNoItem.text = "No Item".localized()
        
        searchBar.delegate = self
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.isHidden = true
        
        viewCosmos.settings.fillMode = .half
        disLbl.isHidden = false
        disLbl.text = "0 km"
        viewCosmos.rating = Double(0.0)
        btnFavRef.setImage(#imageLiteral(resourceName: "fav_un"), for: .normal)
        
        CommonClass.sharedInstance.provideCornarRadius(btnRef: viewLike)
        
        let myMutableString1 = NSMutableAttributedString()
        
        let normalText1 = " "
        
        let myMutableString2 = NSAttributedString(string: "\(normalText1) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!, .foregroundColor :AppColor.textColor])
        
        myMutableString1.append(myMutableString2)
        
        lblDetails.attributedText = myMutableString1
        
        lblAddress.attributedText = CommonClass.sharedInstance.updateHomeTableViewCellLabel(title: "" , cusineArray: locationTExt , address: "", delemit: "\n")
        
        collectionview.isHidden = true

    }
    
    func configureColl(){
        collectionview.isHidden = false
        collectionview.delegate = self as? UICollectionViewDelegate
        collectionview.dataSource = self as? UICollectionViewDataSource
        
        let collectionLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionLayout.scrollDirection = .vertical
        
        let yourWidth = collectionview.bounds.width/2.0
        let yourHeight = yourWidth
        
        collectionLayout.itemSize = CGSize(width: yourWidth , height: yourHeight)
        
        collectionview.collectionViewLayout = collectionLayout
        collectionLayout.minimumInteritemSpacing = 1
        collectionLayout.minimumLineSpacing = 5
    }
    
    
    
    func setDataOnScreen(){
        
        let data = self.viewModel.ResAndStoreDetailArray.first?.Data?.resAndStoreDetail
        //print("data........\(data?.closingTime)")
        if let closingTime = data?.closingTime{
            UserDefaults.standard.setValue(closingTime, forKey: "closingTime")

            UserDefaults.standard.synchronize()
            

        }
        IQKeyboardManager.shared.enable = true
        let invocation = IQInvocation(self, #selector(didPressOnDoneButton))
        searchBar.keyboardToolbar.doneBarButton.invocation = invocation
        searchBar.delegate = self
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.isHidden = true
        
      //  self.btnCancelSearchRef.isHidden = false
        
        viewCosmos.settings.fillMode = .half
        disLbl.isHidden = false
        
        let lat = self.lat as NSString
        let long = self.long as NSString
        disLbl.text = CommonClass.sharedInstance.getDistanceFromCurrentToAll(currentLocationLat: lat.doubleValue, currentLocationLong: long.doubleValue, latitude: data?.latitude ?? "", longitude: data?.longitude ?? "")
        viewCosmos.rating = Double(round(data?.avgRating ?? 0.0))
        btnFavRef.setImage(data?.isFav ?? false ? #imageLiteral(resourceName: "fav"):UIImage(named: "Unfav") , for: .normal)
        
        CommonClass.sharedInstance.provideCornarRadius(btnRef: viewLike)
        
        let myMutableString1 = NSMutableAttributedString()
        let normalText1 = "\(data?.name ?? "")"
        let myMutableString2 = NSAttributedString(string: "\(normalText1) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 17.0)!, .foregroundColor :AppColor.textColor])
        
        myMutableString1.append(myMutableString2)
        
        lblDetails.attributedText = myMutableString1
                
        lblAddress.attributedText = CommonClass.sharedInstance.updateHomeTableViewCellLabel(title: "" , cusineArray: data?.cuisinesName ?? [] , address: data?.address ?? "", delemit: "\n")
        self.imgRestaurent.setImage(withImageId: data?.image ?? "", placeholderImage: #imageLiteral(resourceName: "food_icon"))
        
        self.lblDeliveryTime.text = "\(data?.deliveryTime ?? "Unavailable") \("mins".localized())."
        self.lblMinOrder.textColor = AppColor.subtitleColor
        self.lblMinOrder.text = "\("Min. Order".localized()) : \(data?.minimumValue?.description ?? "") \(data?.currency ?? "")"
        print("Dateils On Rating",data?.avgRating ?? 0.0 )
        
        let avgRat = round(data?.avgRating ?? 0.0)
        
        reviewsRef.text = "\(avgRat) (\(data?.totalRating ?? 0) \("Reviews".localized()))"
        
    }
    
}

//MARK: - Search extensions
//TODO:
extension GroceryDetailVC:UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if searchBar.text == ""{
            searchActive = false
        }else{
            searchActive = true
        }
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        
        self.searchBar.endEditing(true)
        isSearchBarHidden = false
        searchBar.isHidden = true
        
        searchBar.text = String()
        lblCategories.isHidden = false
        btnSearch.isHidden = false
        self.filterArr = self.viewModel.groceryBaseArr.first?.Data
        self.collectionview.reloadData()

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
        configureCollection(self.filterArr ?? [GroceryData]())
        
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
            if searchText != "" {
                filterArr = (self.viewModel.groceryBaseArr.first?.Data?.filter {data in
                    
                    return (data.name?.lowercased().contains(searchText.lowercased()) ?? false)
                    
                } ?? [GroceryData]())
            }else{
                self.filterArr = self.viewModel.groceryBaseArr.first?.Data
            }
            //else { self.filterArr = self.providerArr!}
        
    }
    
    
    func configureCollection(_ data:[GroceryData]){
        
        collectionview.dataSource = self
        collectionview.delegate = self
        print("Count On Grocery Search-", data.count)
        self.tblArr = data
        self.collectionview.reloadData()
    }
    
    

    
    
    
    @objc func didPressOnDoneButton() {
        
        searchActive = false
        self.searchBar.endEditing(true)
        isSearchBarHidden = false
        searchBar.isHidden = true
        searchBar.text = String()
        btnSearch.isHidden = false
        
    }
}
