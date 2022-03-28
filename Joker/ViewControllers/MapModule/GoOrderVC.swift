//
//  GoOrderVC.swift
//  Joker
//
//  Created by Callsoft on 22/01/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyShadow
import QuartzCore
import GooglePlaces
import DropDown
import SwiftyJSON


class GoOrderVC: UIViewController {

    
    @IBOutlet weak var txtFldPickup: UITextField!
    
    @IBOutlet weak var txtFldDrop: UITextField!
    
    @IBOutlet weak var btnGoOrder: UIButton!
    
    @IBOutlet weak var viewDropOff: UIView!
    
    @IBOutlet weak var btnSelectTime: UIButton!
    
    @IBOutlet weak var detailsTxtView: UITextView!
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    @IBOutlet weak var mapview: GMSMapView!
    
    
    let addressWindow = Bundle.main.loadNibNamed("Address", owner: self, options: nil)!.first! as! AddressWindow
    
    let destinationAddressWindow = Bundle.main.loadNibNamed("DestinationAddress", owner: self, options: nil)!.first! as! DestinationAddress
    
    var locationMarker : GMSMarker? = GMSMarker()
    
    var locationManager : CLLocationManager = CLLocationManager()
    var AddressLat:Double = 28.626169
    var AddressLong:Double = 77.377365
    var initialLat:Double = Double()
    var initialLong:Double = Double()
    var strAddress = ""
    var count = 0
    
    var savedLocation = CGPoint()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var comingFrom = ""
    
    //for searching
    
    var lat = ""
    var long = ""
    var locationName = ""
    var arrCityName :NSMutableArray = NSMutableArray()
    var dropDown = DropDown()
    var searchLat = Double()
    var searchLong = Double()
    var gmsPlace:GMSPlace?
    var arrPlaces = NSMutableArray(capacity: 100)
    var arrPlacesIDs = NSMutableArray(capacity: 100)
    
    var searchingForPickup = Bool()
    
    var pickupLat:Double = 0.0
    var pickupLong:Double = 0.0
    var dropLat:Double = 0.0
    var dropLong:Double = 0.0
    
    var selectedTimeStr = ""
    
    var addressSavingType = ""
    
    var path = GMSMutablePath()
    
    let connection = webservices()
    
    var pickupPlacesArr = [(placeName:String,placeImg:String)]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFldPickup.delegate = self
        txtFldDrop.delegate = self
        
        detailsTxtView.delegate = self
        detailsTxtView.text = "Add details of the order"
        
        self.btnSelectTime.setTitle("In 1 hr", for: .normal)
        self.selectedTimeStr = "In 1 hohrur"
        
        addressWindow.viewContainer.layer.cornerRadius = 20
        addressWindow.viewContainer.clipsToBounds = true
        addressWindow.layer.cornerRadius = 20
        addressWindow.clipsToBounds = true
        
        txtFldPickup.placeHolderColor = UIColor.darkGray
        txtFldDrop.placeHolderColor = UIColor.darkGray
        
        //code added after sprint 2 changes
        
        txtFldDrop.isUserInteractionEnabled = false
        txtFldPickup.isUserInteractionEnabled = false
        
        ///////////
     
        let requestId = UserDefaults.standard.value(forKey: "RequestDeliveryID") as? String ?? ""
        
        if requestId == ""{
            
            
        }
        else{
            
            
        }
        
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
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(GoOrderVC.updateAddress(_:)), name: NSNotification.Name(rawValue: "NotificationForUpdateSavedAddress"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
       
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let requestId = UserDefaults.standard.value(forKey: "RequestDeliveryID") as? String ?? ""
        
        if requestId == ""{
            
            
        }
        else{
            
            //call api for pre created order
            
            self.getOrderBasedOnrequestId(requestId: requestId)
        }
    }
    
    
    @IBAction func tap_selectTimeBtn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderTimeVC") as! OrderTimeVC
        
        vc.controllerPurpuse = "Delivery"
        
        vc.delegate = self
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tap_sideMenuBtn(_ sender: Any) {
        
        let vc = ScreenManager.getMoreVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        if self.comingFrom == "ServiceProviderMap"{
            
            self.navigationController?.popViewController(animated: true)
        }
        else{
            
            let vc = ScreenManager.getServiceProviderMapVC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navController
            appDelegate.window?.makeKeyAndVisible()
        }
       
    }
    
    @IBAction func tap_goOrderBtn(_ sender: Any) {
        
        UserDefaults.standard.setValue("DeliveryFlow", forKey: "UserRedirection")
  
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            let requestId = UserDefaults.standard.value(forKey: "RequestDeliveryID") as? String ?? ""
            
            if requestId == ""{
                
                checkValidation()
            }
            else{
                
//                if UserDefaults.standard.value(forKey: "AuthenticationPurpuse") as? String ?? "" == "Signup"{
//
//                    UserDefaults.standard.set("Signin", forKey: "AuthenticationPurpuse")
//                    let vc = ScreenManager.getAgreeDisagreeAlertVC()
//                    vc.controllerPurpuse = "GoOrder"
//                    vc.userType = "Delivery"
//                    vc.nabObj = self
//                    self.present(vc, animated: true, completion: nil)
//
//                }
//                else{
//
//                    let vc = ScreenManager.getTermsAndConditionPopupVC()
//                    vc.navObj = self
//                    vc.userType = "Delivery"
//                    self.present(vc, animated: true, completion: nil)
//
//                }
                
                UserDefaults.standard.setValue("RequestingDelivery", forKey: "SepratorType")
                
                let vc = ScreenManager.getOrderInstructionPopupVC()
                
                vc.nabObj = self
                
                self.present(vc, animated: true, completion: nil)
                
            }
        }
        else{
            
            checkValidation()
        }
        
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
    
    
    @IBAction func tap_dropAddressListing(_ sender: Any) {

        if UserDefaults.standard.bool(forKey: "IsUserLogin"){

            let vc = ScreenManager.getAddNewAddressessVC()

            vc.purpuse = "Drop"

            vc.delegate = self

            self.present(vc, animated: true, completion: nil)
        }
        else{

            self.alertWithAction()
        }
    }
//
//    @IBAction func tap_saveDropAddress(_ sender: Any) {
//
//
//    }
//
//    @IBAction func tap_savePickupAddress(_ sender: Any) {
//
//
//    }
//
    @IBAction func tap_pickupAddressListing(_ sender: Any) {

        if UserDefaults.standard.bool(forKey: "IsUserLogin"){

            let vc = ScreenManager.getAddNewAddressessVC()

            vc.purpuse = "Pickup"

            vc.delegate = self

            self.present(vc, animated: true, completion: nil)

        }
        else{

            self.alertWithAction()
        }
    }
 
    
    @IBAction func tap_pickupLocationBtn(_ sender: Any) {
        
        self.addressSavingType = "Pickup"
        
        let vc = ScreenManager.getAddressPickerVC()
        
        vc.controllerName = "SaveAddress"
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tap_dropLocationBtn(_ sender: Any) {
        
        
        self.addressSavingType = "Drop"
        
        let vc = ScreenManager.getAddressPickerVC()
        
        vc.controllerName = "SaveAddress"
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


//MARK:- Configuring Map
//MARK:-
extension GoOrderVC{
    
    func configureMap(){
        
        self.mapview.clear()
        
        mapview.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: AddressLat, longitude: AddressLong, zoom: 14.0)//:::
        
        mapview.camera = camera
        
        let marker = GMSMarker()
        
        let position = CLLocationCoordinate2D(latitude: Double(AddressLat), longitude: Double(AddressLong))
        marker.position = position
        
        addressWindow.lblAddress.text = strAddress
        
        marker.iconView = addressWindow
        
        marker.map = mapview
        
    }
    
}




extension GoOrderVC:SavedAddressHistoryDelegate{
    
    func returnSavedAddress(address: String, lat: Double, long: Double, purpuse: String) {
        
        if purpuse == "Drop"{
            
            txtFldDrop.text = address
            dropLat = lat
            dropLong = long
            
        }
        else{
            
            txtFldPickup.text = address
            pickupLat  = lat
            pickupLong = long
            
        }
        
    }
}



//MARK:- Mapview delegate
//MARK:-
extension GoOrderVC:GMSMapViewDelegate{
    
    
    @objc func updateAddress(_ notification: NSNotification){
        
        let addressStr = notification.userInfo?["address"] as? String ?? ""
        let apartment = notification.userInfo?["buildingAndApart"] as? String ?? ""
        
        let lati = notification.userInfo?["lat"] as? Double ?? 0.0
        let longi = notification.userInfo?["long"] as? Double ?? 0.0
        
        print(addressStr)
        print(apartment)
        print(lati)
        print(longi)
        
        if self.addressSavingType == "Drop"{
            
            if apartment == ""{
                
                txtFldDrop.text = "\(addressStr)"
            }
            else{
                
                txtFldDrop.text = "\(apartment),\(addressStr)"
            }
            
          
            dropLat = lati
            dropLong = longi
            
        }
        else{
            
            if apartment == ""{
                
                txtFldPickup.text = "\(addressStr)"
            }
            else{
                
                txtFldPickup.text = "\(apartment),\(addressStr)"
            }
          
            pickupLat  = lati
            pickupLong = longi
            
        }
        
    }
    
    
    func sizeForOffset(view: UIView) -> CGFloat {
        
        return  96.0
    }
    
    func sizeForOffsetX(view: UIView) -> CGFloat{
        
        return 110.0
    }
    
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
    
}


extension GoOrderVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        return true
        
    }
    
}


extension GoOrderVC:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if detailsTxtView.text == "Add details of the order"{
            
            detailsTxtView.text = ""
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if detailsTxtView.text == ""{
            
            detailsTxtView.text = "Add details of the order"
        }
    }
}


extension GoOrderVC{
    
    func checkValidation(){
        
        var mess = ""
        
        if pickupLat == 0.0 && pickupLong == 0.0{
            
            mess = "Please select the pickup location"
        }
        else if txtFldPickup.text == ""{
            
            mess = "Please select the pickup location"
        }
        else if dropLat == 0.0 && dropLong == 0.0{
            
            mess = "Please select the drop location"
        }
        else if txtFldDrop.text == ""{
            
            mess = "Please select the drop location"
        }
        else if selectedTimeStr == ""{
            
            mess = "Please select the time"
        }
        else if detailsTxtView.text == "Add details of the order" || detailsTxtView.text == ""{
            
            mess = "Please add some detail"
        }
        else if txtFldPickup.text == ""{
            
            mess = "Please fill the pickup location"
        }
        else if txtFldDrop.text == ""{
            
            mess = "Please fill the dropoff location"
        }
        else{
            
            mess = ""
        }
        
        if mess == ""{
            
            let param:[String:String] = ["service":"RequireService","serviceType":"DeliveryPersion","pickupLocation":txtFldPickup.text!,"pickupLat":"\(pickupLat)","pickupLong":"\(pickupLong)","dropOffLocation":txtFldDrop.text!,"dropOffLat":"\(dropLat)","dropOffLong":"\(dropLong)","seletTime":selectedTimeStr,"orderDetails":detailsTxtView.text!]
            
            self.apiCallForRequestOrder(param: param)
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
    }
    
    
    func apiCallForRequestOrder(param:[String:String]){
        
        print(param)
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForRequestOrder as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        if let dataDict = receivedData.object(forKey: "Data") as? NSDictionary{
                            
                            let requestId = dataDict.object(forKey: "_id") as? String ?? ""
                            
                            UserDefaults.standard.set(requestId, forKey: "RequestDeliveryID")
                            
                            self.manageRedirectionOnController()
                            
                        }
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToHome()
                        }
                        else{
                            
                            CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                        }
                    }
                }
                else{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
                
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
    
    
    
    func manageRedirectionOnController(){
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
//            if UserDefaults.standard.value(forKey: "AuthenticationPurpuse") as? String ?? "" == "Signup"{
//
//                UserDefaults.standard.set("Signin", forKey: "AuthenticationPurpuse")
//                let vc = ScreenManager.getAgreeDisagreeAlertVC()
//                vc.controllerPurpuse = "GoOrder"
//                vc.nabObj = self
//                self.present(vc, animated: true, completion: nil)
//
//            }
//            else{
//
//                let vc = ScreenManager.getTermsAndConditionPopupVC()
//                vc.navObj = self
//                vc.userType = "Delivery"
//                self.present(vc, animated: true, completion: nil)
//
//            }
            
            UserDefaults.standard.setValue("RequestingDelivery", forKey: "SepratorType")
            
            let vc = ScreenManager.getOrderInstructionPopupVC()
            
            vc.nabObj = self
            
            self.present(vc, animated: true, completion: nil)
            
            
        }
        else{
            
                UserDefaults.standard.set("DeliveryWorker", forKey: "UserType")
                let vc = ScreenManager.getSignInSignupVC()
                self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    //get order based on request id
    
    func getOrderBasedOnrequestId(requestId:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param:[String:String] = ["orderId":requestId]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForgetOrderBasedOnRequestId as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        if let dict = receivedData.object(forKey: "response") as? NSDictionary{
                            
                            self.updateElementForRequest(requestData: dict)
                        }
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToHome()
                        }
                        else{
                            
                            CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                        }
                    }
                }
                else{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
    
    
    func updateElementForRequest(requestData:NSDictionary){
        
        if requestData.count != 0{
            
            let pickupAddress = requestData.object(forKey: "pickupLocation") as? String ?? ""
            let dropAddress = requestData.object(forKey: "dropOffLocation") as? String ?? ""
            let selectedTime = requestData.object(forKey: "seletTime") as? String ?? ""
            let detailTxt = requestData.object(forKey: "orderDetails") as? String ?? ""
            
            self.txtFldPickup.text = pickupAddress
            self.txtFldDrop.text = dropAddress
            
            self.btnSelectTime.setTitle(selectedTime, for: .normal)
            self.selectedTimeStr = selectedTime
            self.detailsTxtView.text = detailTxt
            
            self.pickupLat = requestData.object(forKey: "pickupLat") as? Double ?? 0.0
            self.pickupLong = requestData.object(forKey: "pickupLong") as? Double ?? 0.0
            self.dropLat = requestData.object(forKey: "dropOffLat") as? Double ?? 0.0
            self.dropLong = requestData.object(forKey: "dropOffLong") as? Double ?? 0.0
            
            
            print(self.pickupLat)
            print(self.pickupLong)
            print(self.dropLat)
            print(self.dropLong)
            
        }
    }
    
}


extension GoOrderVC:SelectedTimeDelegate{
    
    func selectionTimeOfOrder(time: String) {
        
        self.btnSelectTime.setTitle(time, for: .normal)
        self.selectedTimeStr = time
    }

}


//MARK:- CollectionView datasource and delegate
//MARK:-
extension GoOrderVC:UICollectionViewDataSource,UICollectionViewDelegate{
    
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
        
        self.addressSavingType = "Pickup"
        
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
        
        let vc = ScreenManager.getPickupCategoryMapVC()
        
        vc.backControllerSelectedCategory = catStr
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


//MARK:- Location manager delegate
//MARK:-
extension GoOrderVC:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            
            let currentLocation:CLLocation = locations.first!
            manager.stopUpdatingLocation()
            
            self.AddressLat = currentLocation.coordinate.latitude
            self.AddressLong = currentLocation.coordinate.longitude
            
            self.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude))
            
            if count == 0{
                
                self.initialLat = self.AddressLat
                self.initialLong = self.AddressLong
                
                self.pickupLat = self.AddressLat
                self.pickupLong = self.AddressLong
                
                self.count = self.count + 1
                
               // configureMap()
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
