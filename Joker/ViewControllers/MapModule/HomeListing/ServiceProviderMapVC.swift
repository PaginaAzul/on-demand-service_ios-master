//
//  ServiceProviderMapVC.swift
//  Joker
//
//  Created by Callsoft on 18/01/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import SwiftyShadow
import QuartzCore
import GoogleMaps
import GooglePlaces
import DropDown
import Crashlytics

class ServiceProviderMapVC: UIViewController {

    
    @IBOutlet weak var bottomNotificationVw: UIView!
    @IBOutlet weak var viewContentHolder: SwiftyInnerShadowView!
    
    @IBOutlet weak var viewProvideService: SwiftyInnerShadowView!
    
    @IBOutlet weak var viewRequireService: SwiftyInnerShadowView!
    
    @IBOutlet weak var mapview: GMSMapView!
    
    @IBOutlet weak var btnRequireService: UIButton!
    
    @IBOutlet weak var btnProvideService: UIButton!
    
    @IBOutlet weak var lblHeader: UILabel!
    
    
    ////new refrencing outlets enhancement
    
    @IBOutlet weak var btnDeliveryPerson: UIButton!
    
    @IBOutlet weak var btnProfessionalWorker: UIButton!
    
    @IBOutlet weak var viewProfessionalWorker: SwiftyInnerShadowView!
    
    @IBOutlet weak var viewDeliveryPerson: SwiftyInnerShadowView!
    
    @IBOutlet weak var lblCaptainDeliveryWithinRange: UILabel!
    
    @IBOutlet weak var lblProfessionalWithinRange: UILabel!
    
    @IBOutlet weak var btnRangeCaptainDelivery: UIButton!
    
    @IBOutlet weak var btnRangeProfessional: UIButton!
    
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    @IBOutlet weak var lblNav: UILabel!
    
    @IBOutlet weak var btnHome: UIButton!
    
    @IBOutlet weak var btnMyOrder: UIButton!
    
    @IBOutlet weak var btnNotification: UIButton!
    
    @IBOutlet weak var btnProfile: UIButton!
    
    @IBOutlet weak var lblTabHome: UILabel!
    @IBOutlet weak var lblTabMyOrder: UILabel!
    @IBOutlet weak var lblTabNoti: UILabel!
    @IBOutlet weak var lblTabProfile: UILabel!
    @IBOutlet weak var lblTabHelp: UILabel!
    
    var arrCategory = NSArray()
    
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
    
    let connection = webservices()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let dropDownArr = ["20","30","40","50","60","70","80","90","100"]
    var dropdownTag = 0
    let dropDown = DropDown()
    var initailDeliveryDropDownValue = "20"
    var initailProfessionalDropDownValue = "20"
    
    var globalCategoryName = ""
    var globalCategoryID = ""
    var globalLangCatName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        btnHome.setImage(UIImage(named: "home_sO"), for: .normal)
        btnMyOrder.setImage(UIImage(named: "my_order_unO"), for: .normal)
        btnNotification.setImage(UIImage(named: "notification_unO"), for: .normal)
        btnProfile.setImage(UIImage(named: "profile_unO"), for: .normal)
*/
//        count = 0
//
//        viewProvideService.shadowLayer.cornerRadius = 20.0
//        viewProvideService.clipsToBounds = true
//        viewProvideService.shadowLayer.shadowRadius = 4.0
//        viewProvideService.shadowLayer.shadowColor = UIColor.darkGray.cgColor
//        viewProvideService.shadowLayer.shadowOpacity = 0.8
//        viewProvideService.shadowLayer.shadowOffset = CGSize.zero
//        viewProvideService.generateInnerShadow()
//        viewRequireService.shadowLayer.cornerRadius = 20.0
//        viewRequireService.shadowLayer.shadowRadius = 4.0
//        viewRequireService.shadowLayer.shadowColor = UIColor.darkGray.cgColor
//        viewRequireService.shadowLayer.shadowOpacity = 0.8
//        viewRequireService.shadowLayer.shadowOffset = CGSize.zero
//        viewRequireService.generateInnerShadow()
//
//        addressWindow.viewContainer.layer.cornerRadius = 20
//        addressWindow.viewContainer.clipsToBounds = true
//        addressWindow.layer.cornerRadius = 20
//        addressWindow.clipsToBounds = true
//
//        btnRequireService.titleLabel?.textAlignment = .center
//        btnProvideService.titleLabel?.textAlignment = .center
//
//        ////new enhancement code
//
//        viewDeliveryPerson.shadowLayer.cornerRadius = 20.0
//        viewDeliveryPerson.clipsToBounds = true
//        viewDeliveryPerson.shadowLayer.shadowRadius = 4.0
//        viewDeliveryPerson.shadowLayer.shadowColor = UIColor.darkGray.cgColor
//        viewDeliveryPerson.shadowLayer.shadowOpacity = 0.8
//        viewDeliveryPerson.shadowLayer.shadowOffset = CGSize.zero
//        viewDeliveryPerson.generateInnerShadow()
//        viewProfessionalWorker.shadowLayer.cornerRadius = 20.0
//        viewProfessionalWorker.shadowLayer.shadowRadius = 4.0
//        viewProfessionalWorker.shadowLayer.shadowColor = UIColor.darkGray.cgColor
//        viewProfessionalWorker.shadowLayer.shadowOpacity = 0.8
//        viewProfessionalWorker.shadowLayer.shadowOffset = CGSize.zero
//        viewProfessionalWorker.generateInnerShadow()
//
//        ////*****
//
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

        collectionview.dataSource = self
        collectionview.delegate = self
        
        UserDefaults.standard.set(true, forKey: "FirstTimeInstallation")
        
        self.apiCallForGetServices()
        
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
        
        UserDefaults.standard.set(true, forKey: "SpecificRootToService")
        
        let vc = ScreenManager.getSignInSignupVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
//
//            self.apiCallForGetUserType()
//        }
        //bottomNotificationVw.isHidden = true
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
        
            if self.dropdownTag == 0{
        
                self.initailDeliveryDropDownValue = "\(item)"
                self.apiCallForGetDeliveryWithinRange()
            }
            else{
        
                self.initailProfessionalDropDownValue = "\(item)"
                self.apiCallForGetProfessionalWithinRange()
            }
        
        }
       
        localization()
        
        self.collectionview.reloadData()
        
    }
    
    
    func localization(){
        
        lblNav.text = "Home".localized()
        
        if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
            /*
            btnHome.setImage(UIImage(named: "HomeSelectedLang"), for: .normal)
            btnMyOrder.setImage(UIImage(named: "OrderUnselectedLang"), for: .normal)
            btnNotification.setImage(UIImage(named: "NotificationUnselectedLang"), for: .normal)
            btnProfile.setImage(UIImage(named: "ProfileUnselectedLang"), for: .normal)
            */
            /*
            lblTabHome.text =
            lblTabMyOrder.text =
            lblTabNoti.text =
            lblTabProfile.text =
            lblTabNav.text =
            */
            
            lblTabHome.text = "Home".localized()
            lblTabMyOrder.text = "My Order".localized()
//            lblTabNoti.text = "Notifications".localized()
            lblTabProfile.text = "Profile".localized()
            lblTabHelp.text = "Help".localized()
            
        }
        else{
            /*
            btnHome.setImage(UIImage(named: "home_sO"), for: .normal)
            btnMyOrder.setImage(UIImage(named: "my_order_unO"), for: .normal)
            btnNotification.setImage(UIImage(named: "notification_unO"), for: .normal)
            btnProfile.setImage(UIImage(named: "profile_unO"), for: .normal)
          */
            
            lblTabHome.text = "Home".localized()
            lblTabMyOrder.text = "My Order".localized()
            //lblTabNoti.text = "Notifications".localized()
            lblTabProfile.text = "Profile".localized()
            lblTabHelp.text = "Help".localized()
        }
        
    }
    
    
    @IBAction func tap_shopsBtn(_ sender: Any) {
        
        
    }
    
    
    @IBAction func tap_Help(_ sender: Any) {
            let vc = ScreenManager.getContactUsVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    
    @IBAction func tap_myOrdersBtn(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
         
            let vc = ScreenManager.getNormalUserWithProfessionalWorkerScrollerVC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navController
            appDelegate.window?.makeKeyAndVisible()
        }
        else{
            
            alertWithAction()
        }
      
    }
    
    @IBAction func tap_bottomNotificationBtn(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){

            let vc = ScreenManager.getNotificationVC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navController
            appDelegate.window?.makeKeyAndVisible()

        }
        else{

            self.alertWithAction()
        }
        
    }
    
    @IBAction func tap_captainBtn(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            let vc = ScreenManager.getMapWithServicesSepratedVC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navController
            appDelegate.window?.makeKeyAndVisible()
        }
        else{
            
            self.alertWithAction()
        }
      
    }
    
    
    @IBAction func tap_provideServiceBtn(_ sender: UIButton) {
        
        let vc = ScreenManager.getMapWithServicesSepratedVC()
        vc.controllerPurpuse = "Provide Service"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tap_requireServiceBtn(_ sender: UIButton) {
        
        let vc = ScreenManager.getMapWithServicesSepratedVC()
        vc.controllerPurpuse = ""
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tap_deliveryPersonBtn(_ sender: Any) {
        
        UserDefaults.standard.set("", forKey: "RequestDeliveryID")
        
        let vc = ScreenManager.getDeliveryPersonGoOrderVC()
        
        vc.comingFrom = "ServiceProviderMap"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_professionalWorkerBtn(_ sender: Any) {
        
        //testing purpuse
//        let vc = ScreenManager.getDeliveryPersonWaitingForBuyerVC()
//
//       self.navigationController?.pushViewController(vc, animated: true)
        
        UserDefaults.standard.set("", forKey: "RequestDeliveryID")

        let vc = ScreenManager.getPrfessionalWorkerGoOrderVC()

        vc.comingFrom = "ServiceProviderMap"

        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func tap_rangeProfessionalBtn(_ sender: Any) {
        
        dropdownTag = 1
        dropDown.dataSource = dropDownArr
        dropDown.anchorView = btnRangeProfessional
        dropDown.show()
    }
    
    
    @IBAction func tap_rangeCaptainDeliveryBtn(_ sender: Any) {
        
        dropdownTag = 0
        dropDown.dataSource = dropDownArr
        dropDown.anchorView = btnRangeCaptainDelivery
        dropDown.show()
    }
    
    
    @IBAction func tap_sideMenuBtn(_ sender: Any) {
        
        let vc = ScreenManager.getMoreVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func tap_notificationBtn(_ sender: Any) {
        print("call in notification btn........");
//
//        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
//
//            let vc = ScreenManager.getNotificationVC()
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }
//        else{
//
//            self.alertWithAction()
//        }
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            let vc = ScreenManager.getNotificationVC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navController
            appDelegate.window?.makeKeyAndVisible()
            
        }
        else{
            
            self.alertWithAction()
        }

    }
    
}


//MARK:- Location manager delegate
//MARK:-
extension ServiceProviderMapVC:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoriesCollectionViewCell
        
        let dict = arrCategory.object(at: indexPath.item) as? NSDictionary ?? [:]
        
        let categoryName = dict.object(forKey: "categoryName") as? String ?? ""
        
        let languageCategoryName = dict.object(forKey: "portugueseCategoryName") as? String ?? ""
        
        if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
            
            cell.lblCategoriesName.text = languageCategoryName

        }
        else{
            
            cell.lblCategoriesName.text = categoryName

        }
        
        let imgStr = dict.object(forKey: "categoryImage") as? String ?? ""
        if imgStr != ""{
            
            let urlStr = URL(string: imgStr)
            cell.imgView.setImageWith(urlStr!, placeholderImage: UIImage(named: "catImageNew"))
        }
        
       //cell.imgView.contentMode = .scaleAspectFit
        
        cell.imgView.cornerRadius = 8
        cell.imgView.layer.masksToBounds = true
        
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.white.cgColor

        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        
        //cell.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dict = arrCategory.object(at: indexPath.item) as? NSDictionary ?? [:]
        globalCategoryName = dict.object(forKey: "categoryName") as? String ?? ""
        globalCategoryID = dict.object(forKey: "_id") as? String ?? ""
        
        globalLangCatName = dict.object(forKey: "portugueseCategoryName") as? String ?? ""
        
        self.apiCallForGetSubCategoryList(categoryID: globalCategoryID)
        
//        let vc = ScreenManager.getNewSubcategoryViewController()
//        vc.categoryName = globalCategoryName
//        vc.categoryID = globalCategoryID
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        
      //return CGSize(width: collectionview.frame.size.width, height: collectionview.frame.size.width - 110)
  
        //MARK:- Priyanka Code
        //TODO:- Start
        let noOfCellsInRow = 2

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size + 40)
         //TODO:- End
        
    }
    
}


extension ServiceProviderMapVC{
    
    func apiCallForGetServices(){
        
        IJProgressView.shared.showProgressView(view: self.view)
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            self.connection.startConnectionWithStringGetType(getUrlString: App.URLs.apiCallForGetCategory as NSString) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        if let arr = receivedData.object(forKey: "response") as? NSArray{
                            
                            self.arrCategory = arr
                            
                            self.collectionview.reloadData()
                        }
                    }
                    else{
                        
                        
                        
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
    
    
    
    func apiCallForGetSubCategoryList(categoryID:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["categoryId":categoryID]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForGetSubCategory as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                print(receivedData)
                
                IJProgressView.shared.hideProgressView()
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        if let arr = receivedData.object(forKey: "response") as? NSArray{
                            
                            if arr.count == 0{
                                
                                UserDefaults.standard.set("", forKey: "RequestDeliveryID")
                                
                                let vc = ScreenManager.getPrfessionalWorkerGoOrderVC()
                                
                                vc.comingFrom = "ServiceProviderMap"
                                
                                vc.categoryName = self.globalCategoryName
                                
                                vc.categoryId = self.globalCategoryID
                                vc.subcategoryId = ""
                                
                                vc.subcategoryName = ""
                                
                                vc.langCategoryName = self.globalLangCatName
                                vc.langSubcategoryName = ""
                                
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else{
                                
                                let vc = ScreenManager.getNewSubcategoryViewController()
                                vc.categoryName = self.globalCategoryName
                                vc.categoryID = self.globalCategoryID
                                
                                vc.globalLangCatName = self.globalLangCatName
                                
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            
                        }
                        
                    }
                    else{
                        
                        let code = receivedData.object(forKey: "code") as? Int ?? 0
                        
                        if code == 404{
                            
                            UserDefaults.standard.set("", forKey: "RequestDeliveryID")
                            
                            let vc = ScreenManager.getPrfessionalWorkerGoOrderVC()
                            
                            vc.comingFrom = "ServiceProviderMap"
                            
                            vc.categoryName = self.globalCategoryName
                            
                            vc.subcategoryName = ""
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                        else{
                            
                            let vc = ScreenManager.getNewSubcategoryViewController()
                            vc.categoryName = self.globalCategoryName
                            vc.categoryID = self.globalCategoryID
                            self.navigationController?.pushViewController(vc, animated: true)
                            
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
    
    
}



//MARK:- Mapview delegate
//MARK:-
extension ServiceProviderMapVC:GMSMapViewDelegate{
    
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
        
       // marker.icon = UIImage(named:"jokerMarkerImg")
        
      //  mapview.selectedMarker = marker
        
        addressWindow.lblAddress.text = strAddress
        
        marker.iconView = addressWindow
        
        marker.map = mapview
        
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
    
}



//MARK:- Location manager delegate
//MARK:-
extension ServiceProviderMapVC:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            
            let currentLocation:CLLocation = locations.first!
            manager.stopUpdatingLocation()
            
            self.AddressLat = currentLocation.coordinate.latitude
            self.AddressLong = currentLocation.coordinate.longitude
            
            self.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude))
            
            configureMap()
            
            if count == 0{
                
                self.apiCallForGetBothDelAndProf()
                
                self.initialLat = self.AddressLat
                self.initialLong = self.AddressLong
                
                self.count = self.count + 1
                
                CommonClass.sharedInstance.locationLatCordinate = AddressLat
                CommonClass.sharedInstance.locationLongCordinate = AddressLong
                
                if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                    
                     self.saveLocationOnServerOfUser(lati: "\(self.initialLat)", longi: "\(self.initialLong)")
                }
                
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


extension ServiceProviderMapVC{
    
    func apiCallForGetUserType(){
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            if CommonClass.sharedInstance.isConnectedToNetwork(){
                
                let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
                
                IJProgressView.shared.showProgressView(view: self.view)
                
                self.connection.startConnectionWithSting(App.URLs.apiCallForGetUserType as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                    
                    IJProgressView.shared.hideProgressView()
                    
                    print(receivedData)
                    
                    if self.connection.responseCode == 1{
                        
                        let status = receivedData.object(forKey: "status") as? String ?? ""
                        if status == "SUCCESS"{
                            
                            //  self.userType = receivedData.object(forKey: "Data") as? String ?? ""
                            
                            CommonClass.sharedInstance.isUserDeliveryWorker = receivedData.object(forKey: "adminVerifyDeliveryPerson") as? String ?? ""
                            
                            CommonClass.sharedInstance.isUserProfessionalWorker = receivedData.object(forKey: "adminVerifyProfessionalWorker") as? String ?? ""
                        }
                        else{
                            
                            let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                            
                            if msg == "Invalid Token"{
                                
                                CommonClass.sharedInstance.redirectToHome()
                            }
                            else{
                                
                                //self.navigationController?.popViewController(animated: true)
                                
                                CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                            }
                        }
                    }
                    else{
                        
                       // self.navigationController?.popViewController(animated: true)
                        
                       // CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                    }
                }
            }
            else{
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
            }
        }
        
    }
    
    
    func saveLocationOnServerOfUser(lati:String,longi:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","latitude":lati,"longitude":longi]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForSaveLocationOfUser as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()

                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        print("Location Has been saved on server")
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToHome()
                        }
                        else{
                            
                        }
                    }
                }
                else{
                    
                    
                }
                
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    func apiCallForGetDeliveryWithinRange(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["lat":"\(AddressLat)","long":"\(AddressLong)","distance":initailDeliveryDropDownValue,"userType":"DeliveryPerson"]
            
            print(param)
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.getTotalCountOfBusinessAndProfessionalWithinRange as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let totalDeliveryPerson = receivedData.object(forKey: "Data") as? Int ?? 0
                        
                        self.lblCaptainDeliveryWithinRange.text = "\(totalDeliveryPerson) Captain Delivery within"
                        
                        self.btnRangeCaptainDelivery.setTitle("\(self.initailDeliveryDropDownValue) Km", for: .normal)
                        
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
                        
                        self.lblProfessionalWithinRange.text = "\(totalProfessional) Professional within"
                        
                        self.btnRangeProfessional.setTitle("\(self.initailProfessionalDropDownValue) Km", for: .normal)
                        
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
    
    
    //////////////
    
    func apiCallForGetBothDelAndProf(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["lat":"\(AddressLat)","long":"\(AddressLong)","distance":"20"]
            
            print(param)
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForCountBothDelAndProf as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let deliveryArr = receivedData.object(forKey: "Delivery") as? NSArray ?? []
                        
                        let professionalArr = receivedData.object(forKey: "Professional") as? NSArray ?? []
                        
                        if deliveryArr.count == 0{
                            
                            self.lblCaptainDeliveryWithinRange.text = "0 Captain Delivery within"
                            
                            self.btnRangeCaptainDelivery.setTitle("\(self.initailDeliveryDropDownValue) Km", for: .normal)
                        }
                        else{
                            
                            let dict = deliveryArr.object(at: 0) as? NSDictionary ?? [:]
                            
                            let count = dict.object(forKey: "myCount") as? Int ?? 0
                            
                            self.lblCaptainDeliveryWithinRange.text = "\(count) Captain Delivery within"
                            
                            self.btnRangeCaptainDelivery.setTitle("\(self.initailDeliveryDropDownValue) Km", for: .normal)
                        }
                        
                        if professionalArr.count == 0{
                            
                            self.lblProfessionalWithinRange.text = "0 Professional within"
                            
                            self.btnRangeProfessional.setTitle("\(self.initailProfessionalDropDownValue) Km", for: .normal)
                        }
                        else{
                            
                             let dict = professionalArr.object(at: 0) as? NSDictionary ?? [:]
                            
                             let count = dict.object(forKey: "myCount") as? Int ?? 0
                            
                             self.lblProfessionalWithinRange.text = "\(count) Professional within"
                            
                             self.btnRangeProfessional.setTitle("\(self.initailProfessionalDropDownValue) Km", for: .normal)
                            
                        }
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
    
    ///////
    
    func forTesting(){
        
        let dict1:[String:Any] = [
            "token":"67j4ALMKlv8HWnYeBLxhLHbHV",
            "order_id":"YMI15755306244",
            "chef_id":"14",
            "ratings":[
             [
                "rating":"5",
                "feedback":"cc",
                "dish_id":"65"
                
             ]
            
            ]
        
        ]
        
        self.connection.startConnectionWithStingWithJson("https://mobuloustech.com/yummy/api/addrating", method_type: methodType.post, params: dict1) { (receivedData) in
            
            print(receivedData)
            
            
        }
        
    }
    
    /////
    
}
