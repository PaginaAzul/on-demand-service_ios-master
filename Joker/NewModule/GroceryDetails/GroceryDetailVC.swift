//
//  GroceryDetailVC.swift
//  Joker
//
//  Created by cst on 24/10/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit
import Cosmos
import CoreLocation
import IQKeyboardManagerSwift


struct GroceryDetailModel {
    
    var name:String
    var image:String
    
}

class GroceryDetailVC: UIViewController {
    
    
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var viewCosmos: CosmosView!
    @IBOutlet weak var btnFavRef: UIButton!
    @IBOutlet weak var disLbl: UILabel!
    @IBOutlet weak var lblNoItem: UILabel!

    @IBOutlet weak var viewLike: UIView!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imgRestaurent: UIImageView!
    @IBOutlet weak var lblMinOrder: UILabel!
    @IBOutlet weak var lblDeliveryTime: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lblCategories: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var reviewsRef: UILabel!


    var locationTExt = ["Snacks" , "Staples" ,"Packet Food"]
    var groceryDetailModelArr = [GroceryDetailModel]()
    var isSearchBarHidden = Bool()
    var searchActive = Bool()
    var id = String()
    var isFavt = Bool()
    let viewModel = ViewModel()
    var locationManager = CLLocationManager()
    var lat = String()
    var long = String()
    
    var filterArr : [GroceryData]?
    var tblArr : [GroceryData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getresAndStoreDetailService()
        initialSetup()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getresAndStoreDetailService()
       

    }
     
}

//MARK:- IBActions
//TODO:
extension GroceryDetailVC {
    
    @IBAction func backBtn(_ sender: Any) {
//        let vc = ScreenManager.HomeScreenNew_VC()
//        let navController = UINavigationController(rootViewController: vc)
//        navController.navigationBar.isHidden = true
//        appDel.window?.rootViewController = navController
//        appDel.window?.makeKeyAndVisible()
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func tapTOOpenMAp(){
       
//        let lat = 28.7041
//        let lon = 77.1025
       
        let lat = self.viewModel.ResAndStoreDetailArray.first?.Data?.resAndStoreDetail?.latitude ?? "0.0"
        let lon = self.viewModel.ResAndStoreDetailArray.first?.Data?.resAndStoreDetail?.longitude ?? "0.0"
        
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(lat),\(lon)&zoom=14&views=traffic&q=\(lat),\(lon)")!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=loc:\(lat),\(lon)&zoom=14&views=traffic&q=\(lat),\(lon)")!, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func tapSearchB(_ sender: Any) {
        /*
        isSearchBarHidden = true
        searchBar.isHidden = false
        lblCategories.isHidden = true
        btnSearch.isHidden = true
        
        searchActive = false
        
        self.searchBar.endEditing(true)
        isSearchBarHidden = false
        searchBar.isHidden = true
        
        searchBar.text = String()
        lblCategories.isHidden = false
        btnSearch.isHidden = false
        */
        
        
        isSearchBarHidden = true
        searchBar.isHidden = false
        lblCategories.isHidden = true
        btnSearch.isHidden = true
        
//        self.filterArr = self.viewModel.groceryBaseArr.first?.Data
//        self.collectionview.reloadData()
        
    }
    
    @IBAction func btnInfoTapped(_ sender: Any) {
        
        let vc = ScreenManager.ResturantInfoViewC()
        vc.viewC = self
        vc.ResAndStoreDetailArray = self.viewModel.ResAndStoreDetailArray
        self.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func btnRating(_ sender: Any) {
        
        
        let vc = ScreenManager.ratingReviewsNew_VC()
        
        if self.viewModel.ResAndStoreDetailArray.first?.Data?.rating?.count != 0 {
            vc.ratingModelArr = (
                self.viewModel.ResAndStoreDetailArray.first?.Data?.rating)!

        }

        
        vc.avgRating = self.viewModel.ResAndStoreDetailArray.first?.Data?.resAndStoreDetail?.avgRating ?? 0.0
        vc.totalRating = self.viewModel.ResAndStoreDetailArray.first?.Data?.resAndStoreDetail?.totalRating ?? 0
         
        //ratingModelArr
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func btnFavTapped(_ sender: UIButton) {
        
        let apiHandle = ApiHandler()

        
        guard UserDefaults.standard.bool(forKey: "IsUserLogin") else {
            // alertWithAction()
            CommonClass.sharedInstance.alertWithAction()
            return
        }
        
        guard CommonClass.sharedInstance.isConnectedToNetwork() else {
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: commonController)
            return
        }
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                     "resAndStoreId":self.id,
                     "langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ]
        apiHandle.fetchApiService(method: .post, url: Domain.baseUrl().appending(APIEndpoint.addToFavourite), passDict: param, header: header) { (result) in
            switch result{
            
            case .success(let data):
                print(data)
                let response_message = data["response_message"].stringValue
                
                if response_message == "Added to favourite successfully".localized(){
                    self.btnFavRef.setImage(#imageLiteral(resourceName: "fav") , for: .normal)
                    self.btnFavRef.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    
                    UIView.animate(withDuration: 2.0,
                                   delay: 0,
                                   usingSpringWithDamping: 0.2,
                                   initialSpringVelocity: 6.0,
                                   options: .allowUserInteraction,
                                   animations: { [weak self] in
                                    self?.btnFavRef.transform = .identity
                                   },
                                   completion: nil)
                }else if response_message == "Remove from favourite successfully".localized(){
                    self.btnFavRef.setImage(UIImage(named: "Unfav") , for: .normal)
                    
                } else{
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: response_message, controller: commonController)
                }
                
                break
            case .failure(let error):
                CommonClass.sharedInstance.callNativeAlert(title: "", message: error.localizedDescription, controller: commonController)
                break
            }
        }
    }
}

