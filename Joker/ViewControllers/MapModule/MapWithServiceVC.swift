//
//  MapWithServiceVC.swift
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


class MapWithServiceVC: UIViewController {

    
    @IBOutlet weak var mapview: GMSMapView!
    
    @IBOutlet weak var viewGoOrder: SwiftyInnerShadowView!
    
    @IBOutlet weak var txtFldPickup: UITextField!
    
    @IBOutlet weak var txtFldSelectService: UITextField!
    
    @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var viewPickupLocation: UIView!
    
    @IBOutlet weak var viewSelectService: UIView!
    
    @IBOutlet weak var btnSelectTime: UIButton!
    
    @IBOutlet weak var detailsTxtView: UITextView!
    
    @IBOutlet weak var lblKmDistance: UILabel!
    
    @IBOutlet weak var lblNoOfServiceProvider: UILabel!
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    @IBOutlet weak var btnDistance: UIButton!
    
    @IBOutlet weak var lblNav: UILabel!
    
    @IBOutlet weak var lblAddImages: UILabel!
    
    @IBOutlet weak var btnPlaceOrder: UIButton!
    
    let dropDownArr = ["20","30","40","50","60","70","80","90","100"]
    var dropdownTag = 0
    let dropDown = DropDown()
    var initailProfessionalDropDownValue = "20"
    
    var attachmentArr = NSMutableArray()
    
    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    var imageName = ""
    
    let addressWindow = Bundle.main.loadNibNamed("Address", owner: self, options: nil)!.first! as! AddressWindow
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
    var searchLat = Double()
    var searchLong = Double()
    var gmsPlace:GMSPlace?
    var arrPlaces = NSMutableArray(capacity: 100)
    var arrPlacesIDs = NSMutableArray(capacity: 100)
    
    var searchingForPickup = Bool()
    var pickupLat:Double = 0.0
    var pickupLong:Double = 0.0
    
    var selectedTimeStr = ""
    
    let connection = webservices()
    
    var categoryName = ""
    var subcategoryName = ""
    
    var langCategoryName = ""
    var langSubcategoryName = ""
    
    var categoryId = ""
    var subcategoryId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.isHidden = true
        txtFldPickup.delegate = self
        
        detailsTxtView.delegate = self
        detailsTxtView.text = "Add details of the order".localized()
        
        //self.btnSelectTime.setTitle("Within 1 hour", for: .normal)
        //self.selectedTimeStr = "Within 1 hour"
        
        addressWindow.viewContainer.layer.cornerRadius = 20
        addressWindow.viewContainer.clipsToBounds = true
        addressWindow.layer.cornerRadius = 20
        addressWindow.clipsToBounds = true
        
        viewGoOrder.shadowLayer.cornerRadius = 22.5
        viewGoOrder.clipsToBounds = true
        viewGoOrder.shadowLayer.shadowRadius = 4.0
        viewGoOrder.shadowLayer.shadowColor = UIColor.darkGray.cgColor
        viewGoOrder.shadowLayer.shadowOpacity = 0.8
        viewGoOrder.shadowLayer.shadowOffset = CGSize.zero
        viewGoOrder.generateInnerShadow()
        
        txtFldPickup.placeHolderColor = UIColor.black
        txtFldSelectService.placeHolderColor = UIColor.black
        
        let requestId = UserDefaults.standard.value(forKey: "RequestDeliveryID") as? String ?? ""
        
        if requestId == ""{
            
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
        else{
            
            
        }
      
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.collectionview.dataSource = self
        self.collectionview.delegate = self
        self.apiCallForGetProfessionalWithinRange()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MapWithServiceVC.updateAddress(_:)), name: NSNotification.Name(rawValue: "NotificationForUpdateSavedAddress"), object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            self.initailProfessionalDropDownValue = "\(item)"
            self.apiCallForGetProfessionalWithinRange()
            
        }
        
        localization()
    }
    
    func localization(){
        
        lblNav.text = "New Order".localized()
        txtFldPickup.placeholder = "Enter Your Service Location".localized()
        btnSelectTime.setTitle("Select Time".localized(), for: .normal)
        lblAddImages.text = "Add Images".localized()
        btnPlaceOrder.setTitle("Place Order".localized(), for: .normal)
        
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
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func tap_selectServiceBtn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServicesVC") as! ServicesVC
        
        vc.delegate = self
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func tap_btnPickupLocation(_ sender: Any) {
        
        let vc = ScreenManager.getAddressPickerVC()
        
        vc.controllerName = "SaveAddress"
      
        self.navigationController?.pushViewController(vc, animated: true)
        
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
        
        UserDefaults.standard.setValue("ProffesionalWorkerFlow", forKey: "UserRedirection")

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
//                    vc.nabObj = self
//                    self.present(vc, animated: true, completion: nil)
//
//                }
//                else{
//
//                    let vc = ScreenManager.getTermsAndConditionPopupVC()
//                    vc.navObj = self
//                    self.present(vc, animated: true, completion: nil)
//
//                }
                
                UserDefaults.standard.setValue("RequestingProfessional", forKey: "SepratorType")
                
                let vc = ScreenManager.getOrderInstructionPopupVC()
                
                vc.nabObj = self
                
                self.present(vc, animated: true, completion: nil)
                
            }
        }
        else{
            
            checkValidation()
        }
        
        //*****************
     
    }
    
    
    @IBAction func tap_saveAddressBtn(_ sender: Any) {
        
//        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
//
//            if self.txtFldPickup.text == ""{
//
//                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please enter pickup address to save", controller: self)
//            }
//            else if pickupLat == 0.0 && pickupLong == 0.0{
//
//                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please enter pickup address", controller: self)
//            }
//            else{
//
//                let vc = ScreenManager.getAddressPickerVC()
//
//                vc.controllerName = "SaveAddress"
//                vc.AddressLat = pickupLat
//                vc.AddressLong = pickupLong
//
//                vc.strAddress = txtFldPickup.text!
//
//                self.navigationController?.pushViewController(vc, animated: true)
//
//            }
//        }
//        else{
//
//            self.alertWithAction()
//        }
        
    }
    
    
    @IBAction func tap_addressListingBtn(_ sender: Any) {

        if UserDefaults.standard.bool(forKey: "IsUserLogin"){

            let vc = ScreenManager.getAddNewAddressessVC()

            vc.delegate = self
            vc.purpuse = "Pickup"

            self.present(vc, animated: true, completion: nil)

        }
        else{

            self.alertWithAction()
        }
    }
    
    
    @IBAction func tap_distanceBtn(_ sender: Any) {
        
        dropDown.dataSource = dropDownArr
        dropDown.anchorView = btnDistance
        dropDown.show()
    }
    
    @IBAction func tap_attachmentBtn(_ sender: Any) {
        
        if attachmentArr.count < 2{
            
            showImagePicker()
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can upload maximum two images", controller: self)
        }
    }
    
}


extension MapWithServiceVC:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func camera(){
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func photoLibrary() {
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showImagePicker(){
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            
            actionSheet.addAction(UIAlertAction(title: "Camera".localized(), style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
                
                self.camera()
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Gallery".localized(), style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
                
                self.photoLibrary()
                
            }))
            
        }else {
            
            actionSheet.addAction(UIAlertAction(title: "Gallery".localized(), style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
                
                self.photoLibrary()
                
            }))
            
        }
        
        actionSheet.addAction(UIAlertAction(title:"Cancel".localized(), style: UIAlertActionStyle.cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            
            let popup = UIPopoverController(contentViewController: actionSheet)
            
            popup.present(from: CGRect(), in: self.view!, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
            
        }else{
            
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
    
        imageData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
        imageName = "user_image.jpg"
        
        self.attachmentArr.add(imageData)
        self.collectionview.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
}


extension MapWithServiceVC:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.attachmentArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! WorkImageCollectionViewCell
        
        cell.imgWork.image = UIImage(data: self.attachmentArr.object(at: indexPath.item) as! Data)
        
        cell.btnCross.tag = indexPath.item
        cell.btnCross.addTarget(self, action: #selector(self.tap_crossBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 75, height: 75)
        
    }
    
    
    @objc func tap_crossBtn(sender:UIButton){
        
        self.attachmentArr.removeObject(at: sender.tag)
        self.collectionview.reloadData()
    }
}



extension MapWithServiceVC:SavedAddressHistoryDelegate{
    
    func returnSavedAddress(address: String, lat: Double, long: Double, purpuse: String) {
        
        txtFldPickup.text = address
        pickupLat  = lat
        pickupLong = long
       
        self.strAddress = address
        
        self.configureMap()
            
    }
}




extension MapWithServiceVC:ServicesCategoryDelegate{
    
    func selectedCategory(category: String, subCategory: String) {
        
        self.txtFldSelectService.text = "\(category),\(subCategory)"
    }
    
}



//MARK:- Mapview delegate
//MARK:-
extension MapWithServiceVC:GMSMapViewDelegate{
    
    
    @objc func updateAddress(_ notification: NSNotification){
        
        let addressStr = notification.userInfo?["address"] as? String ?? ""
        let apartment = notification.userInfo?["buildingAndApart"] as? String ?? ""
        
        let lati = notification.userInfo?["lat"] as? Double ?? 0.0
        let longi = notification.userInfo?["long"] as? Double ?? 0.0
        
        print(addressStr)
        print(apartment)
        print(lati)
        print(longi)
        
        if apartment == ""{
            
            txtFldPickup.text = "\(addressStr)"
        }
        else{
            
            txtFldPickup.text = "\(apartment),\(addressStr)"
        }
       
        pickupLat  = lati
        pickupLong = longi
            
        self.addressWindow.lblAddress.text = self.txtFldPickup.text!
            
        let camera = GMSCameraPosition.camera(withLatitude: pickupLat, longitude: pickupLong, zoom: 14.0)//:::
        
        mapview.camera = camera
        
    }
    
    
    
    func sizeForOffset(view: UIView) -> CGFloat {
        return  96.0
    }
    
    func sizeForOffsetX(view: UIView) -> CGFloat{
        return 110.0
    }
    
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
        
      //  mapview.selectedMarker = marker
        
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
                    
                   // self.txtFldPickup.text = self.strAddress
                    
                    self.configureMap()
                    
                }
            }
        }
    }
    
    
    
    func alertWithAction(){
        
        let alertController = UIAlertController(title: "", message: "You are not logged in. Please login/signup before proceeding further.".localized(), preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            self.makeRootToLoginSignup()
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertActionStyle.cancel) {
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


//MARK:- Location manager delegate
//MARK:-
extension MapWithServiceVC:CLLocationManagerDelegate{
    
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
                
                self.pickupLat = self.AddressLat
                self.pickupLong = self.AddressLong
                
                self.count = self.count + 1
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


extension MapWithServiceVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if newText == ""{
            
            tableview.isHidden = true
        }
        
        if textField == txtFldPickup{
            
            searchingForPickup = true
            
            tableTopConstraint.constant = 70
        }
        
        let filter = GMSAutocompleteFilter()
        
        filter.type = GMSPlacesAutocompleteTypeFilter.geocode
        
        //  filter.type = GMSPlacesAutocompleteTypeFilter.establishment
        
        let placesClient = GMSPlacesClient()
        
        placesClient.autocompleteQuery(newText, bounds: nil, filter: filter, callback: { (result, error) -> Void in
            
            self.arrPlaces.removeAllObjects()
            
            self.arrPlacesIDs.removeAllObjects()
            
            self.tableview.isHidden = true
            
            guard result != nil else {
                return
            }
            
            for item in result! {
                
                if let res: GMSAutocompletePrediction? = item {
                    
                    print(res)
                    
                    self.arrPlaces.add(res?.attributedFullText.string)
                    
                    self.arrPlacesIDs.add(res?.placeID)
                    
                }
            }
            
            if self.arrPlaces.count != 0{
                
                self.tableview.isHidden = false
            }
            
            self.tableview.roundCorners([.bottomRight,.bottomLeft], radius: 22.5)
            
            if self.arrPlaces.count < 1 {
                
                self.tableview.isHidden = true
            }
            
            self.tableview.reloadData()
            
        })
        
        return true
        
    }
    
}



extension MapWithServiceVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AddressPickerTableViewCell
        
        cell.lblAddress.text = arrPlaces[indexPath.row] as? String
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchingForPickup == true{
            
            self.txtFldPickup.text = arrPlaces[indexPath.row] as? String
            
            addressWindow.lblAddress.text = strAddress
        }
        
        let id = self.arrPlacesIDs[indexPath.row] as? String ?? ""
        let placeID = id
        let placesClient = GMSPlacesClient()
        placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
            
            if let error = error {
                
                self.tableview.isHidden = true
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                
                self.tableview.isHidden = true
                print("No place details for \(placeID)")
                return
            }
            
            self.AddressLat  = place.coordinate.latitude
            self.AddressLong = place.coordinate.longitude
            print("Place name \(place.name)")
            
            let camera = GMSCameraPosition.camera(withLatitude: self.AddressLat, longitude: self.AddressLong, zoom: 12.0)
            self.mapview.camera = camera
            
            self.tableview.isHidden = true
            
        })
        
        self.tableview.isHidden = true
        
    }
    
}


extension MapWithServiceVC:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if detailsTxtView.text == "Add details of the order".localized(){
            
            detailsTxtView.text = ""
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if detailsTxtView.text == ""{
            
            detailsTxtView.text = "Add details of the order".localized()
        }
    }
}


extension MapWithServiceVC:SelectedTimeDelegate{
    
    func selectionTimeOfOrder(time: String) {
        
        self.btnSelectTime.setTitle(time.localized(), for: .normal)
        self.selectedTimeStr = time
    }
}

extension MapWithServiceVC{
    
    func checkValidation(){
        
        var mess = ""
        
        if txtFldPickup.text == ""{
            
            mess = "Enter Your Service Location"
        }
//        else if txtFldSelectService.text == ""{
//
//            mess = "Please select the service"
//        }
        else if selectedTimeStr == ""{
            
            mess = "Please select the time"
        }
        else if detailsTxtView.text == "Add details of the order".localized() || detailsTxtView.text == ""{
            
            mess = "Add details of the order"
        }
        else if pickupLat == 0.0 && pickupLong == 0.0{
            
            mess = "Enter Your Service Location"
        }
        else{
            
            mess = ""
        }
        
        if mess == ""{
            
            let param:[String:String] = ["service":"RequireService","serviceType":"ProfessionalWorker","pickupLocation":txtFldPickup.text!,"pickupLat":"\(pickupLat)","pickupLong":"\(pickupLong)","selectCategoryName":"\(categoryName)","selectSubCategoryName":"\(subcategoryName)","selectSubSubCategoryName":"SubSubCategory","seletTime":selectedTimeStr,"orderDetails":detailsTxtView.text!,"serviceCategoryId":self.categoryId,"serviceSubCategoryId":self.subcategoryId,"portugueseCategoryName":langCategoryName,"portugueseSubCategoryName":langSubcategoryName,"langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]
            
            
            UserDefaults.standard.set(param, forKey: "paramOrder")
            UserDefaults.standard.set(attachmentArr, forKey: "attachmentArrOrder")
            
            self.manageRedirectionOnController()
            
           // self.apiCallForRequestOrder(param: param)

        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
    }
    
    
//    func apiCallForRequestOrder(param:[String:String]){
//
//        if CommonClass.sharedInstance.isConnectedToNetwork(){
//
//            IJProgressView.shared.showProgressView(view: self.view)
//
//            self.connection.startConnectionWithArray(getUrlString: App.URLs.apiCallForRequestOrder as NSString, fileArr: attachmentArr, ArrayParam: "orderImages[]", method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
//
//                IJProgressView.shared.hideProgressView()
//
//                print(receivedData)
//
//                if self.connection.responseCode == 1{
//
//                let status = receivedData.object(forKey: "status") as? String ?? ""
//                if status == "SUCCESS"{
//
//                    if let dataDict = receivedData.object(forKey: "Data") as? NSDictionary{
//
//                        let requestId = dataDict.object(forKey: "_id") as? String ?? ""
//
//                        UserDefaults.standard.set(requestId, forKey: "RequestDeliveryID")
//
//                        self.manageRedirectionOnController()
//
//                    }
//                }
//                else{
//
//                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
//
//                        if msg == "Invalid Token"{
//
//                            CommonClass.sharedInstance.redirectToHome()
//                        }
//                        else{
//
//                            CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
//                        }
//                }
//                }
//                else{
//
//                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
//                }
//            }
//
//        }
//        else{
//
//            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
//        }
//
//    }
    
    
    func manageRedirectionOnController(){
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            UserDefaults.standard.setValue("RequestingProfessional", forKey: "SepratorType")
            
            let vc = ScreenManager.getOrderInstructionPopupVC()
            
            vc.nabObj = self
            
            self.present(vc, animated: true, completion: nil)
            
        }
        else{
            
            UserDefaults.standard.set("ProfessionalWorker", forKey: "UserType")
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
    
    
    func apiCallForGetProfessionalWithinRange(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["lat":"\(AddressLat)","long":"\(AddressLong)","distance":initailProfessionalDropDownValue,"userType":"ProfessionalWorker"]
            
            print(param)
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.getTotalCountOfBusinessAndProfessionalWithinRange as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let totalProfessional = receivedData.object(forKey: "Data") as? Int ?? 0
                        
                        self.lblNoOfServiceProvider.text = "\(totalProfessional) "+"Service Provider within".localized()
                        
                        self.lblKmDistance.text = "\(self.initailProfessionalDropDownValue) Km"
                        
                    }
                    else{
                        
                        
                    }
                }
                else{
                    
                    // CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
        
    
    func updateElementForRequest(requestData:NSDictionary){
        
        if requestData.count != 0{
            
            self.pickupLat = requestData.object(forKey: "pickupLat") as? Double ?? 0.0
            self.pickupLong = requestData.object(forKey: "pickupLong") as? Double ?? 0.0
            let pickupAddress = requestData.object(forKey: "pickupLocation") as? String ?? ""
            let selectedTime = requestData.object(forKey: "seletTime") as? String ?? ""
            let detailTxt = requestData.object(forKey: "orderDetails") as? String ?? ""
            
            self.categoryName = requestData.object(forKey: "selectCategoryName") as? String ?? ""
            
            self.subcategoryName = requestData.object(forKey: "selectSubCategoryName") as? String ?? ""
            
            self.langCategoryName = requestData.object(forKey: "portugueseCategoryName") as? String ?? ""
            
            self.langSubcategoryName = requestData.object(forKey: "portugueseSubCategoryName") as? String ?? ""
            
            self.categoryId = requestData.object(forKey: "serviceCategoryId") as? String ?? ""
            
            self.subcategoryId = requestData.object(forKey: "serviceSubCategoryId") as? String ?? ""
            
            self.txtFldPickup.text = pickupAddress
         
            self.addressWindow.lblAddress.text = pickupAddress
            
            self.btnSelectTime.setTitle(selectedTime.localized(), for: .normal)
            self.selectedTimeStr = selectedTime
            self.detailsTxtView.text = detailTxt
            
            let position =  CLLocationCoordinate2D(latitude: Double(self.pickupLat), longitude: Double(self.pickupLong))
            
            self.mapview.animate(toLocation: position)
          
        }
    }
 
}
