//
//  PickupCategoriesMapVC.swift
//  Joker
//
//  Created by Dacall soft on 26/06/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import GoogleMaps
import DropDown

class PickupCategoriesMapVC: UIViewController {

    
    @IBOutlet weak var mapview: GMSMapView!
    @IBOutlet weak var collectionview: UICollectionView!
    
    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var viewCollectionHolder: UIView!
    
    
    var backControllerSelectedCategory = ""
    
    var pickupPlacesArr = [(placeName:String,placeImg:String)]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var locationMarker : GMSMarker? = GMSMarker()
    
    var locationManager : CLLocationManager = CLLocationManager()
    var AddressLat:Double = 0.0
    var AddressLong:Double = 0.0
    var initialLat:Double = Double()
    var initialLong:Double = Double()
    var strAddress = ""
    var count = 0
    
    let connection = webservices()
    
    var searchDataArr = NSMutableArray()
    
    var backupArr = NSArray()
    
    var dataArr = NSArray()
    
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
        
        collectionview.dataSource = self
        collectionview.delegate = self
        
        collectionview.reloadData()
        
        txtSearch.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        if #available(iOS 9.0, *) {
            
            locationManager.requestLocation()
            locationManager.requestWhenInUseAuthorization()
            self.locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
            
        } else {
            
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        configureMap()
        
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
                    
                    let geoMatryDict = dict.object(forKey: "geometry") as? NSDictionary ?? [:]
                    
                    let locationDict = geoMatryDict.object(forKey: "location") as? NSDictionary ?? [:]
                    
                    let latiDouble = locationDict.object(forKey: "lat") as? Double ?? 0.0
                    let longiDouble = locationDict.object(forKey: "lng") as? Double ?? 0.0
                    
                    let camera = GMSCameraPosition.camera(withLatitude: latiDouble, longitude: longiDouble, zoom: 10.0)
                    
                    self.mapview.camera = camera
                    
                    let filteredDataDict = self.backupArr.object(at: i) as? NSDictionary ?? [:]
                    
                    let arr = NSMutableArray()
                    
                    arr.add(filteredDataDict)
                    
                    self.dataArr = arr as NSArray
                    
                    self.showMarker()
                    
                    break
                }
                
            }
            
        }
        
    }
    
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_listViewBtn(_ sender: Any) {
        
        let vc = ScreenManager.getPickupCategoryListVC()
        
        vc.dataArr = self.dataArr
        
        vc.lat = self.AddressLat
        vc.long = self.AddressLong
        
        vc.backupArr = self.backupArr
        
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_menuBtn(_ sender: Any) {
        
        let vc = ScreenManager.getMoreVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_NotificationBtn(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            let vc = ScreenManager.getNotificationVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            
            self.alertWithAction()
        }
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
    
    func configureMap(){
        
        self.mapview.clear()
        
        mapview.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: AddressLat, longitude: AddressLong, zoom: 14.0)//:::
        
        mapview.camera = camera
        
    }
    
}


//MARK:- ListView Delegate
//MARK:-
extension PickupCategoriesMapVC:ListDataToMap{
    
    func ShowListData(status: String, dataList: NSArray) {
        
        self.dataArr = dataList
        self.showMarker()
    }
    
}


//MARK:- Custom Method
//MARK:-
extension PickupCategoriesMapVC{
    
    func showMarker(){
        
        self.mapview.clear()
        
        for i in 0..<dataArr.count{
            
            let dict = dataArr.object(at: i) as? NSDictionary ?? [:]
            
            let geoMatryDict = dict.object(forKey: "geometry") as? NSDictionary ?? [:]
            
            let locationDict = geoMatryDict.object(forKey: "location") as? NSDictionary ?? [:]
            
            let latiDouble = locationDict.object(forKey: "lat") as? Double ?? 0.0
            let longiDouble = locationDict.object(forKey: "lng") as? Double ?? 0.0
            
            if latiDouble != 0.0 && longiDouble != 0.0{
                
                let position = CLLocationCoordinate2DMake(latiDouble,longiDouble)
                
                let marker = GMSMarker(position: position)
                
                marker.userData = i
                
                marker.icon = UIImage(named: "PointerMarker")
                
                let titleStr = dict.object(forKey: "name") as? String ?? ""
                let snippetStr = dict.object(forKey: "formatted_address") as? String ?? ""
                
                marker.title = titleStr
                marker.snippet = snippetStr
                
                marker.map = self.mapview
                
            }
            
         }
    }
    
}


//MARK:- MapView delegate
//MARK:-
extension PickupCategoriesMapVC:GMSMapViewDelegate{
    
    func makeAddressString(inArr:[String]) -> String {
        
        var fVal:String = ""
        for val in inArr {
            
            fVal =  fVal + val + " "
            
        }
        return fVal
        
    }
    
    func reverseGeocodeCoordinate(inLat:Double, inLong:Double) {
        
        let cordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: inLat, longitude: inLong)
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(cordinate) { response, error in
            
            if let address = response?.results() {
                
                let lines = address.first
                
                if let addressNew = lines?.lines {
                    
                    self.strAddress = self.makeAddressString(inArr: addressNew)
                    
                    self.configureMap()
                    
                }
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        let index = marker.userData as! Int
        
        let dict = dataArr.object(at: index) as? NSDictionary ?? [:]
        
        let geoMatryDict = dict.object(forKey: "geometry") as? NSDictionary ?? [:]
        
        let locationDict = geoMatryDict.object(forKey: "location") as? NSDictionary ?? [:]
        
        let latiDouble = locationDict.object(forKey: "lat") as? Double ?? 0.0
        let longiDouble = locationDict.object(forKey: "lng") as? Double ?? 0.0
        let addressStr = dict.object(forKey: "formatted_address") as? String ?? ""
        let name = dict.object(forKey: "name") as? String ?? ""
        
        let completeAddress = "\(name),\(addressStr)"
        
        let addressDict:NSDictionary = ["address":completeAddress,"buildingAndApart":"","lat":latiDouble,"long":longiDouble]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdateSavedAddress"), object: nil, userInfo: addressDict as? [AnyHashable : Any])
        
        self.navigationController?.popViewController(animated: true)
        
    }
}


//MARK:- Location manager delegate
//MARK:-
extension PickupCategoriesMapVC:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            
            let currentLocation:CLLocation = locations.first!
            manager.stopUpdatingLocation()
            
            self.AddressLat = currentLocation.coordinate.latitude
            self.AddressLong = currentLocation.coordinate.longitude
            
            self.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude))
            
            configureMap()
            
            if count == 0{
                
                self.initialLat = self.AddressLat
                self.initialLong = self.AddressLong
                
                CommonClass.sharedInstance.locationLatCordinate = AddressLat
                CommonClass.sharedInstance.locationLongCordinate = AddressLong
                
                self.count = self.count + 1
                
                self.getDataForCategory(CatName: self.backControllerSelectedCategory)
            }
            
            self.reverseGeocodeCoordinate(inLat: AddressLat, inLong: AddressLong)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        NSLog("error = %@", error.localizedDescription)
        
    }
    
    func locationAuthorizationStatus(status:CLAuthorizationStatus)
    {
        switch status
        {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location AuthorizedWhenInUse/AuthorizedAlways")
            self.mapview.isMyLocationEnabled = true
            
            self.locationManager.startUpdatingLocation()
            if CLLocationManager.headingAvailable() {
                self.locationManager.headingFilter = 100
            }
            
        case .denied, .notDetermined, .restricted:
            print("Location Denied/NotDetermined/Restricted")
            self.mapview.isMyLocationEnabled = false
            self.locationManager.stopUpdatingLocation()
            
        }
        
        func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
        {
        }
        
        func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion)
        {
        }
        
        func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion)
        {
            print("Now monitoring :  \(manager.location?.coordinate) for \(region.identifier) radius: \(region.identifier)")
        }
        
        func locationManager(_ manager: CLLocationManager,
                             monitoringDidFailFor region: CLRegion?, withError error: Error)
        {
            print("monitoringDidFailForRegion \(region!.identifier) \(error.localizedDescription) \(error.localizedDescription)")
        }
        
        func locationManager(_ manager: CLLocationManager,
                             didDetermineState state: CLRegionState, for region: CLRegion)
        {
            var stateName = ""
            switch state {
            case .inside:
                stateName = "Inside"
            case .outside:
                stateName = "Outside"
            case .unknown:
                stateName = "Unknown"
            }
            print("didDetermineState \(stateName) \(region.identifier)")
            
        }
    }
}


//MARK:- UICollectionView Datasource and Delegate
//MARK:-
extension PickupCategoriesMapVC:UICollectionViewDataSource,UICollectionViewDelegate{
    
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


//MARK:- UIText Field delegate
//MARK:-
extension PickupCategoriesMapVC:UITextFieldDelegate{
    
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


//MARK:- Webservices
//MARK:-
extension PickupCategoriesMapVC{
    
    func getDataForCategory(CatName:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            let urlStr = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=type=\(CatName)&location=\(self.AddressLat),\(self.AddressLong)&radius=100&key=AIzaSyBL4ngANDBnJLusG09x2t7mkGwi_mX1SWo"
            
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
                    
                    self.showMarker()
                    
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
