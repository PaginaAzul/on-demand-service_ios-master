//
//  MyFavNew_VC.swift
//  Joker
//
//  Created by cst on 20/10/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit

class MyFavNew_VC: UIViewController {
    
    //MARK: - OUTLETS
    //TODO:
    @IBOutlet weak var collectionFav: UICollectionView!
    @IBOutlet weak var lblRestauret:UILabel!
    @IBOutlet weak var navBautton: UIButton!
    @IBOutlet weak var lblNoItem: UILabel!
    
    var collectionModelArr = [homeScreenModel]()
    var isComing = String()
    var viewModel = ViewModel()
    
    var resturantListArray = [RestaurantList]()
    var storeListArray = [StoreList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonController = self
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if isComing == "View All"{
            lblRestauret.text! = "Restaurants".localized()
            navBautton.setImage(#imageLiteral(resourceName: "back_button"), for: .normal)
            self.configCollectionView()

        }else if isComing ==  "View All Grocery"{
            lblRestauret.text! = "Shops".localized()
            navBautton.setImage(#imageLiteral(resourceName: "back_button"), for: .normal)
            self.configCollectionView()

        }else{
            navBautton.setImage(#imageLiteral(resourceName: "headerBtn"), for: .normal)
            lblRestauret.text! = "My Favorites".localized()
            self.getFavouriteList()
        }
    }
    
    
    @IBAction func tap_sideMenuBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}

extension MyFavNew_VC : favProtocol{
    func unlike(_ status: Bool, index: Int) {
        
        self.getFavouriteList()

    }
}

//MARK: - Extension UITableView DataSource and Delegates
//TODO:
extension MyFavNew_VC: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func configCollectionView(){
        
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
        collectionFav.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isComing == "View All"{
            return self.resturantListArray.count
        }else if isComing == "View All Grocery"{
            return self.storeListArray.count
        }else{
            return self.viewModel.favtDataArray.first?.Data?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        self.collectionFav.register(UINib(nibName: "HomeCollectionCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionCell")
        
        let cell = collectionFav.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as! HomeCollectionCell
        
        if isComing == "View All"{
            
            cell.item = self.resturantListArray[indexPath.row]
            
        }else if isComing ==  "View All Grocery"{
            
            cell.Storeitem = self.storeListArray[indexPath.row]
            
        }else{
            
            //cell.btnFavClick()
            cell.favDelegate = self
            cell.id = self.viewModel.favtDataArray.first?.Data?[indexPath.row].resAndStoreId ?? ""
            cell.itemFavt = self.viewModel.favtDataArray.first?.Data?[indexPath.row]
            
        }
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width-20, height:251)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isComing == "View All Grocery" {
            
            let vc = ScreenManager.GroceryDetailVC()
            vc.id = self.storeListArray[indexPath.row].Id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if isComing == "View All"{
            
            let vc = ScreenManager.RestaurentDetailsVC()
            vc.id = self.resturantListArray[indexPath.row].Id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            
            let vc = ScreenManager.RestaurentDetailsVC()
            vc.id = self.viewModel.favtDataArray.first?.Data?[indexPath.row].resAndStoreId ?? ""
            vc.isFav = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}

extension MyFavNew_VC{
    //MARK: - getRestaurantAndStoreData API
    //TODO: - GET RESTAURENTS DETAILS AND LIST
    func getFavouriteList(){
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                         "latitude":GloblaLat,
                         "longitude":GloblaLong,
                         "langcode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,] as [String:Any]
            
            viewModel.getFavouriteListService(Domain.baseUrl().appending(APIEndpoint.getFavouriteList), param, header)
        }else{
            
            let param = [
                         "latitude":GloblaLat,
                         "longitude":GloblaLong,
                         "langcode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,] as [String:Any]
            
            viewModel.getFavouriteListService(Domain.baseUrl().appending(APIEndpoint.getFavouriteList), param)
        }
        
       
        closerSetup()
    }
    //MARK: - CLOSURE FOR EXCLUSIVE
    //TODO:
    func closerSetup(){
        
        viewModel.reloadList = {() in
            // self.registerNib()
            
            if self.viewModel.favtDataArray.first?.Data?.count ?? 0 > 0{
                self.configCollectionView()
                self.lblNoItem.isHidden = true
                self.collectionFav.isHidden = false
            }else{
                
                self.lblNoItem.isHidden = false
                self.collectionFav.isHidden = true
                self.lblNoItem.text = "No favorites".localized()
            }
        }
        
        viewModel.errorMessage = { (message) in
            print(message)
        }
    }
}
