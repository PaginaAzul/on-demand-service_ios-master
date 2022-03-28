//
//  PickupCategoriesListVC.swift
//  Joker
//
//  Created by Dacall soft on 26/06/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import DropDown
import GoogleMaps
import GooglePlaces


protocol ListDataToMap{
    
    func ShowListData(status:String,dataList:NSArray)
}

class PickupCategoriesListVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var viewCollectionHolder: UIView!
    
    
    let connection = webservices()
    
    var dataArr = NSArray()
    var pickupPlacesArr = [(placeName:String,placeImg:String)]()
    
    var searchDataArr = NSMutableArray()
    
    var backupArr = NSArray()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var lat = Double()
    var long = Double()
    
    var delegate:ListDataToMap?
    
    let dropDown = DropDown()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickupPlacesArr.removeAll()
        
        pickupPlacesArr.append((placeName: "All", placeImg: "pickupAll"))
        pickupPlacesArr.append((placeName: "Restaurants", placeImg: "pickupRestaurant"))
        pickupPlacesArr.append((placeName: "Supermarket", placeImg: "pickupSuperMarket"))
        pickupPlacesArr.append((placeName: "Pharmacy", placeImg: "pickupPharmacy"))
        pickupPlacesArr.append((placeName: "Coffee", placeImg: "pickupCoffee"))
        pickupPlacesArr.append((placeName: "Sweets", placeImg: "pickupSweets"))
        pickupPlacesArr.append((placeName: "Gas", placeImg: "pickupGas"))
        pickupPlacesArr.append((placeName: "Shopping Centers", placeImg: "pickupShopingCenter"))
        
        self.collectionview.dataSource = self
        self.collectionview.delegate = self
        
        txtSearch.delegate = self
        
        if dataArr.count == 0{
            
            lblPlaceholder.isHidden = false
            
        }
        else{
            
            lblPlaceholder.isHidden = true
            
        }
        
        configureTableView()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            self.txtSearch.text = "\(item)"
            
            for i in 0..<self.backupArr.count{
                
                let dict = self.backupArr.object(at: i) as? NSDictionary ?? [:]
                
                let name = dict.object(forKey: "name") as? String ?? ""
                
                if name == "\(item)"{
                    
                    let filteredDataDict = self.backupArr.object(at: i) as? NSDictionary ?? [:]
                    
                    let arr = NSMutableArray()
                    
                    arr.add(filteredDataDict)
                    
                    self.dataArr = arr as NSArray
                    
                    self.tableview.reloadData()
                    
                    break
                }
                
            }
            
        }
        
    }
    
    
    @IBAction func tap_mapViewBtn(_ sender: Any) {
        
        self.delegate?.ShowListData(status: "", dataList: dataArr)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_notificationBtn(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            let vc = ScreenManager.getNotificationVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            
            self.alertWithAction()
        }
        
    }
    
    @IBAction func tap_menuBtn(_ sender: Any) {
        
        let vc = ScreenManager.getMoreVC()
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    func makeRootToLoginSignup(){
        
        let vc = ScreenManager.getSignInSignupVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    func configureTableView(){
        
        let cellNib = UINib(nibName: "PickupCategoriesListTableViewCell", bundle: nil)
        tableview.register(cellNib, forCellReuseIdentifier: "Cell")
        tableview.tableFooterView = UIView()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        tableview.reloadData()
    }
    
}


//MARK:- UIText Field delegate
//MARK:-
extension PickupCategoriesListVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        print(newText)
        
        searchDataArr.removeAllObjects()
        
        for i in 0..<backupArr.count{
            
            let dict = backupArr.object(at: i) as? NSDictionary ?? [:]
            
            let name = dict.object(forKey: "name") as? String ?? ""
            
            if (name.lowercased().range(of: newText.lowercased()) != nil) {
                
                self.searchDataArr.add(name)
                
            }
        }
        
        if searchDataArr.count == 0{
            
            dropDown.hide()
        }
        else{
            
            dropDown.dataSource = self.searchDataArr as! [String]
            dropDown.anchorView = self.viewCollectionHolder
            dropDown.show()
        }
        
        return true
    }
}


//MARK:- UICollectionView Datasource and Delegate
//MARK:-
extension PickupCategoriesListVC:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pickupPlacesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PickupPlacesCollectionViewCell
        
        cell.imgPickupLocation.image = UIImage(named: pickupPlacesArr[indexPath.row].placeImg)
        
        cell.lblPlaceCategory.text = pickupPlacesArr[indexPath.row].placeName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var catStr = ""
        
        switch indexPath.item {
            
        case 0:
            
            print("All")
            
            catStr = "All"
            
        case 1:
            
            print("Restaurants")
            
            catStr = "Restaurants"
            
        case 2:
            
            print("Supermarket")
            
            catStr = "Supermarket"
            
        case 3:
            
            print("Pharmacy")
            
            catStr = "Pharmacy"
            
        case 4:
            
            print("Coffee")
            
            catStr = "Coffee"
            
        case 5:
            
            print("Sweets")
            
            catStr = "Sweets"
            
        case 6:
            
            print("Gas")
            
            catStr = "Gas"
            
        case 7:
            
            print("Shopping Centers")
            
            catStr = "ShoppingCenters"
            
        default:
            
            print("")
        }
        
        self.getDataForCategory(CatName: catStr)
    }
    
}


//MARK:- UITableView Datasource and Delegate
//MARK:-
extension PickupCategoriesListVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PickupCategoriesListTableViewCell
        
        let dict = dataArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let name = dict.object(forKey: "name") as? String ?? ""
        let address = dict.object(forKey: "formatted_address") as? String ?? ""
        let userTotalRating = dict.object(forKey: "user_ratings_total") as? Int ?? 0
        
        let rating = dict.object(forKey: "rating") as? Double ?? 0.0
        
        cell.viewRating.rating = rating
            
        cell.lblPlaceRating.text = "\(rating)"
        
        let openCloseStatusDict = dict.object(forKey: "opening_hours") as? NSDictionary ?? [:]
        
        let openStatus = openCloseStatusDict.object(forKey: "open_now") as? Bool ?? false
        
        if openStatus{
            
            cell.lblOpenCloseStatus.text = "Open Now"
        }
        else{
            
            cell.lblOpenCloseStatus.text = "Closed Now"
        }
        
        cell.lblPlacename.text = name
        cell.lblCategories.text = address
        cell.lblTotalRating.text = "(\(userTotalRating) Ratings)"
        
        let geoMatryDict = dict.object(forKey: "geometry") as? NSDictionary ?? [:]
        
        let locationDict = geoMatryDict.object(forKey: "location") as? NSDictionary ?? [:]
        
        let latiDouble = locationDict.object(forKey: "lat") as? Double ?? 0.0
        let longiDouble = locationDict.object(forKey: "lng") as? Double ?? 0.0
        
        if latiDouble != 0.0 && longiDouble != 0.0{
            
            let distance = self.getDistanceFromCurrentToAllHost(destinationLat: latiDouble, destinationLong: longiDouble, currentLat: lat, currentLong: long)
            
            cell.lblDistanceKm.text = "\(distance) km"
            
        }
        
        
        let photoArr = dict.object(forKey: "photos") as? NSArray ?? []
        
        if photoArr.count != 0{
            
            let photoDict = photoArr.object(at: 0) as? NSDictionary ?? [:]
            
            let photoReference = photoDict.object(forKey: "photo_reference") as? String ?? ""
            
            let imgStr = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photoReference)&key=AIzaSyBL4ngANDBnJLusG09x2t7mkGwi_mX1SWo"
            
            let urlStr = URL(string: imgStr)
            
            if urlStr != nil{
                
               // DispatchQueue.global(qos: .background).async {
                    
                cell.imgPlace.setImageWith(urlStr!, placeholderImage: UIImage(named: "certificateImg"))
                //}
               
            }
            
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = dataArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let geoMatryDict = dict.object(forKey: "geometry") as? NSDictionary ?? [:]
        
        let locationDict = geoMatryDict.object(forKey: "location") as? NSDictionary ?? [:]
        
        let latiDouble = locationDict.object(forKey: "lat") as? Double ?? 0.0
        let longiDouble = locationDict.object(forKey: "lng") as? Double ?? 0.0
        let addressStr = dict.object(forKey: "formatted_address") as? String ?? ""
        
        let name = dict.object(forKey: "name") as? String ?? ""
        
        let completeAddress = "\(name),\(addressStr)"
        
        let addressDict:NSDictionary = ["address":completeAddress,"buildingAndApart":"","lat":latiDouble,"long":longiDouble]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdateSavedAddress"), object: nil, userInfo: addressDict as? [AnyHashable : Any])
        
        for controller in self.navigationController!.viewControllers as Array {
            
            if controller is GoOrderVC{
                
                self.navigationController!.popToViewController(controller, animated: true)
                
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    
    func getDistanceFromCurrentToAllHost(destinationLat:Double,destinationLong:Double,currentLat:Double,currentLong:Double) -> String{
                    
        let coordinate₀ = CLLocation(latitude: currentLat, longitude: currentLong)
        let coordinate₁ = CLLocation(latitude: destinationLat, longitude: destinationLong)
                    
        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
        let distanceInKm = distanceInMeters / 1000
        
        let doubleStr = String(format: "%.2f", distanceInKm)
        
        return doubleStr
        
    }
    
    
}


//MARK:- Custom Method
//MARK:-
extension PickupCategoriesListVC{
    
    func getDataForCategory(CatName:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            let urlStr = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=type=\(CatName)&location=\(self.lat),\(self.long)&radius=100&key=AIzaSyBL4ngANDBnJLusG09x2t7mkGwi_mX1SWo"
            
            self.connection.startConnectionWithStringGetTypeInsta(getUrlString: urlStr as NSString) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                let status = receivedData.object(forKey: "status") as? String ?? ""
                
                if status == "REQUEST_DENIED"{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Request has been denied from google places finder.", controller: self)
                }
                else if status == "OVER_QUERY_LIMIT"{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "You have exceeded your daily request quota for this API. If you did not set a custom daily request quota, verify your project has an active billing account", controller: self)
                }
                else if status == "OK"{
                    
                    //write here code for fetch data
                    
                    self.dataArr = receivedData.object(forKey: "results") as? NSArray ?? []
                    
                    self.backupArr = receivedData.object(forKey: "results") as? NSArray ?? []
                    
                    if self.dataArr.count == 0{
                        
                        self.lblPlaceholder.isHidden = false
                    }
                    else{
                        
                        self.lblPlaceholder.isHidden = true
                    }
                    
                    self.tableview.reloadData()
                    
                }
                else{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Request has been denied from google places finder.", controller: self)
                }
                
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
}


