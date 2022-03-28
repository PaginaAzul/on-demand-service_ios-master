//
//  SearchNew_VC.swift
//  Joker
//
//  Created by cst on 24/10/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit

class SearchNew_VC: UIViewController {
    
    //MARK: - OUTLETS
    //TODO:
    @IBOutlet weak var collectionFav: UICollectionView!
    @IBOutlet weak var btnGrocery: UIButton!
    @IBOutlet weak var btnRestaurent: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var lblHeader: UILabel!
    
    @IBOutlet weak var lblTabHome: UILabel!
    @IBOutlet weak var lblTabMyOrder: UILabel!
    @IBOutlet weak var lblTabSearch: UILabel!
    @IBOutlet weak var lblTabProfile: UILabel!
    @IBOutlet weak var lblTabHelp: UILabel!
    
    var isComing = String()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let viewModel = ViewModel()
    var type = String()
    var collectionArray : [RestaurantList]?
    var filterArr : [RestaurantList]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "Search by Restaurants,Store, Groceries Cuisines.".localized()
        lblHeader.text = "Search".localized()
        btnRestaurent.setTitle("   Restaurants".localized(), for: .normal)
        btnGrocery.setTitle("   Shops".localized(), for: .normal)
        
        lblTabHome.text = "Home".localized()
        lblTabMyOrder.text = "My Order".localized()
        lblTabSearch.text = "Search".localized()
        lblTabProfile.text = "My Profile".localized()
        lblTabHelp.text = "Help".localized()
        
        commonController = self
        UserDefaults.standard.set("Food", forKey: "Food")
        self.fetchRestaurantAndStoreDataForSearch("Restaurant")
        self.searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        commonController = self
        self.getCountV()
    }
    
    @IBAction func tap_Help(_ sender: Any) {
           let vc = ScreenManager.getContactUsVC()
           self.navigationController?.pushViewController(vc, animated: true)
       }
    
    @IBAction func tapRes_Grocery(_ sender: UIButton) {
        
        
        if sender.tag == 1 {
            
            btnGrocery.setImage(#imageLiteral(resourceName: "radio_un"), for: .normal)
            btnRestaurent.setImage(#imageLiteral(resourceName: "radio_s"), for: .normal)
            btnGrocery.setTitle("   Grocery".localized(), for: .normal)
            btnRestaurent.setTitle("   Restaurant".localized(), for: .normal)
            
            self.fetchRestaurantAndStoreDataForSearch("Restaurant")
            
        }else{
            
            btnGrocery.setImage(#imageLiteral(resourceName: "radio_s"), for: .normal)
            btnRestaurent.setImage(#imageLiteral(resourceName: "radio_un"), for: .normal)
            btnGrocery.setTitle("   Grocery".localized(), for: .normal)
            btnRestaurent.setTitle("   Restaurant".localized(), for: .normal)
            
            self.fetchRestaurantAndStoreDataForSearch("Grocery Store")
        }
    }
    
    
    @IBAction func tap_sideMenuBtn(_ sender: Any) {
        
        let vc = ScreenManager.getMoreVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tap_FilterBtn(_ sender: Any) {
        
        let vc = ScreenManager.TubeFilterVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tap_MyCartBtn(_ sender: Any) {
       
        
         if UserDefaults.standard.bool(forKey: "IsUserLogin"){
             
            UserDefaults.standard.removeObject(forKey: "Shop")
            let vc = ScreenManager.MyCartNew_VC()
            vc.comgFromOffer = false
            self.navigationController?.pushViewController(vc, animated: true)
         }
         else{
 
             self.alertWithAction()
         }
         
        
    }
    
    //MARK: - TabBar
    //
    @IBAction func tap_HometBtn(_ sender: Any) {
       // if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            let vc = ScreenManager.HomeScreenNew_VC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navController
            appDelegate.window?.makeKeyAndVisible()
//        }
//        else{
//            self.alertWithAction()
//        }
    }
    
    @IBAction func tap_SearchBtn(_ sender: Any) {
        
    }
    
    @IBAction func tap_MyOrdersBtn(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            let vc = ScreenManager.MyOrderOngoingVC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navController
            appDelegate.window?.makeKeyAndVisible()
        }else{
            self.alertWithAction()
        }
    }
    
    @IBAction func tap_MyProfileBtn(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            UserDefaults.standard.set(true, forKey: "NewModul")
            let vc = ScreenManager.getMapWithServicesSepratedVC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navController
            appDelegate.window?.makeKeyAndVisible()
        }else{
            self.alertWithAction()
        }
       
    }
    func makeRootToLoginSignup(){
        let vc = ScreenManager.getSignInSignupVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func alertWithAction(){
        
        let alertController = UIAlertController(title: "", message: "You are not logged in. Please login/signup before proceeding further.".localized(), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            self.makeRootToLoginSignup()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
}


//MARK: - Extension UITableView DataSource and Delegates
//TODO:
extension SearchNew_VC: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    
    func configCollection(_ data:[RestaurantList]){
        
        collectionFav.register(UINib(nibName: "HomeCollectionCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionCell")
        
        collectionFav.delegate = self
        collectionFav.dataSource = self
        
        let collectionLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionLayout.scrollDirection = .vertical
        
        collectionLayout.itemSize = CGSize(width: UIScreen.main.bounds.width-20, height: 251)
        
        collectionFav.collectionViewLayout = collectionLayout
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.minimumLineSpacing = 5
        collectionFav.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.collectionArray = data
        collectionFav.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       // return self.viewModel.searchDataArray.first?.Data?.restaurantList?.count ?? 0
        return self.collectionArray?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        self.collectionFav.register(UINib(nibName: "HomeCollectionCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionCell")
        
        let cell = collectionFav.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as! HomeCollectionCell
        
        // cell.configureCell(info: collectionModelArr[indexPath.row])
        cell.item = self.collectionArray?[indexPath.row]
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width-20, height:251)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.type == "Restaurant"   {
            
            UserDefaults.standard.set("Food", forKey: "Food")
            let vc = ScreenManager.RestaurentDetailsVC()
            vc.id = self.viewModel.searchDataArray.first?.Data?.restaurantList?[indexPath.row].Id ?? ""
            vc.isFav = isFavt
            self.navigationController?.pushViewController(vc, animated: true)
          
        }else{
            
            UserDefaults.standard.set("Restaurent", forKey: "Food")
            let vc = ScreenManager.GroceryDetailVC()
            vc.id = self.viewModel.searchDataArray.first?.Data?.restaurantList?[indexPath.row].Id ?? ""
            vc.isFavt = isFavt
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
}
