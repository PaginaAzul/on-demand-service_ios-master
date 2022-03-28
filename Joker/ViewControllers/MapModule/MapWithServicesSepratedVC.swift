//
//  MapWithServicesSepratedVC.swift
//  Joker
//
//  Created by Callsoft on 15/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyShadow
import GooglePlaces
import DropDown

class MapWithServicesSepratedVC: UIViewController {

    
    @IBOutlet weak var mapview: GMSMapView!
    @IBOutlet weak var viewUnderHeader: UIView!
    
    @IBOutlet weak var containerView: SwiftyInnerShadowView!
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnnoti: UIButton!
    
    @IBOutlet weak var viewDeliveryPerson: SwiftyInnerShadowView!
    
    @IBOutlet weak var viewProfessionalWorker: SwiftyInnerShadowView!
    
    @IBOutlet weak var btnDeliveryPerson: UIButton!
    
    @IBOutlet weak var btnProfessionalPerson: UIButton!
    
    
    @IBOutlet weak var lblCaptainDelivery: UILabel!
    
    @IBOutlet weak var btnCaptainDeliveryDropdown: UIButton!
    
    @IBOutlet weak var lblProfessional: UILabel!
    
    @IBOutlet weak var btnProfessionalDropdown: UIButton!
    
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtCountryCode: UITextField!
    
    @IBOutlet weak var txtAppLang: UITextField!
    
    @IBOutlet weak var txtSpeakLang: UITextField!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var btnHome: UIButton!
    
    @IBOutlet weak var btnMyOrder: UIButton!
    
    @IBOutlet weak var btnNotification: UIButton!
    
    @IBOutlet weak var btnProfile: UIButton!
    
    @IBOutlet weak var lblNav: UILabel!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var btnHelp: UIButton!
    
    @IBOutlet weak var lblTabHome: UILabel!
    @IBOutlet weak var lblTabMyOrder: UILabel!
    @IBOutlet weak var lblTabNoti: UILabel!
    @IBOutlet weak var lblTabProfile: UILabel!
    @IBOutlet weak var lblTabHelp: UILabel!

    @IBOutlet weak var imgTabHome: UIImageView!
    @IBOutlet weak var imgTabMyOrder: UIImageView!
    @IBOutlet weak var imgTabNoti: UIImageView!
    @IBOutlet weak var imgTabProfile: UIImageView!
    @IBOutlet weak var imgTabHelp: UIImageView!
    
    @IBOutlet weak var profileView : UIView!
    
    
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
    
    var controllerPurpuse = "Provide Service"
    
    var initailDeliveryDropDownValue = "20"
    var initailProfessionalDropDownValue = "20"
    
    let connection = webservices()
    let dropDownArr = ["20","30","40","50","60","70","80","90","100"]
    var dropdownTag = 0
    let dropDown = DropDown()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var userDataDict = NSDictionary()
    var newModule = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        newModule = UserDefaults.standard.value(forKey: "NewModul") as! Bool
        
        if newModule == true {
            self.viewUnderHeader.isHidden = true
            self.btnnoti.isHidden = true
            
            profileView.backgroundColor = .white
            
            btnMyOrder.backgroundColor = .clear
            btnHome.backgroundColor = .clear
          //  btnNotification.backgroundColor = .clear
            btnProfile.backgroundColor = .clear
            btnHelp.backgroundColor = .clear
            
            lblTabHome.textColor = .darkGray
            lblTabMyOrder.textColor = .darkGray
//            lblTabNoti.textColor = .darkGray
            lblTabProfile.textColor = AppColor.whiteColor
            lblTabHelp.textColor = .darkGray
            
            lblTabHome.text = "Home".localized()
            lblTabMyOrder.text = "Search".localized()
//            lblTabNoti.text = "My Order".localized()
            lblTabProfile.text = "My Profile".localized()
            lblTabHelp.text = "Help".localized()
            imgTabMyOrder.image = #imageLiteral(resourceName: "search_unN")
            imgTabProfile.image = #imageLiteral(resourceName: "profile_sN")
           // imgTabNoti.image = #imageLiteral(resourceName: "my_order_unN")
            btnProfile.backgroundColor = .white
            btnHelp.tintColor =  UIColor(red: 121/255, green: 121/255, blue: 121/255, alpha: 1.0)
          
        }else{
            
            lblTabHome.text = "Home".localized()
            lblTabMyOrder.text = "My Order".localized()
            //lblTabNoti.text = "Notifications".localized()
            lblTabProfile.text = "Profile".localized()
            lblTabHelp.text = "Help".localized()
            
            self.viewUnderHeader.isHidden = false
            self.btnnoti.isHidden = false
            btnHelp.tintColor = .black

        }
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
         self.apiCallForGetUserDetail()

        
        localization()
    }
    
    func localization(){
        
        lblNav.text = "My Profile".localized()
        
        btnEdit.setTitle("Edit".localized(), for: .normal)
        
        if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
            
            
            
            if newModule == true {
                profileView.backgroundColor = .white
                
                self.viewUnderHeader.isHidden = true
                self.btnnoti.isHidden = true
                
                imgTabMyOrder.image = #imageLiteral(resourceName: "search_unN")
                imgTabProfile.image = #imageLiteral(resourceName: "profile_sN")
//                imgTabNoti.image = #imageLiteral(resourceName: "my_order_unN")
                
                lblTabHome.text = "Home".localized()
                lblTabMyOrder.text = "Search".localized()
//                lblTabNoti.text = "My Order".localized()
                lblTabProfile.text = "My Profile".localized()
                lblTabHelp.text = "Help".localized()
                
                btnMyOrder.backgroundColor = .clear
                btnHome.backgroundColor = .clear
//                btnNotification.backgroundColor = .clear
                btnProfile.backgroundColor = .clear
                btnHelp.backgroundColor = .clear
                
                lblTabHome.textColor = .darkGray
                lblTabMyOrder.textColor = .darkGray
//                lblTabNoti.textColor = .darkGray
                lblTabProfile.textColor = AppColor.themeColor
                lblTabHelp.textColor = .darkGray
                
                
            }else{
               
                
                lblTabHome.text = "Home".localized()
                lblTabMyOrder.text = "My Order".localized()
//                lblTabNoti.text = "Notifications".localized()
                lblTabProfile.text = "Profile".localized()
                lblTabHelp.text = "Help".localized()
                
            }
            
            
            
        }
        else{
            if newModule == true {
                
                self.viewUnderHeader.isHidden = true
                self.btnnoti.isHidden = true
                
                profileView.backgroundColor = .white

                imgTabMyOrder.image = #imageLiteral(resourceName: "search_unN")
                imgTabProfile.image = #imageLiteral(resourceName: "profile_sN")
//                imgTabNoti.image = #imageLiteral(resourceName: "my_order_unN")

                lblTabHome.text = "Home".localized()
                lblTabMyOrder.text = "Search".localized()
//                lblTabNoti.text = "My Order".localized()
                lblTabProfile.text = "My Profile".localized()
                lblTabHelp.text = "Help".localized()
                
                btnMyOrder.backgroundColor = .clear
                btnHome.backgroundColor = .clear
//                btnNotification.backgroundColor = .clear
                btnProfile.backgroundColor = .clear
                btnHelp.backgroundColor = .clear
                
                lblTabHome.textColor = .darkGray
                lblTabMyOrder.textColor = .darkGray
//                lblTabNoti.textColor = .darkGray
                lblTabProfile.textColor = AppColor.themeColor
                lblTabHelp.textColor = .darkGray
                
            }else{
                
                lblTabHome.text = "Home".localized()
                lblTabMyOrder.text = "My Order".localized()
                //lblTabNoti.text = "Notifications".localized()
                lblTabProfile.text = "Profile".localized()
                lblTabHelp.text = "Help".localized()
                
                /*
                btnHome.setImage(UIImage(named: "shopsUnselected"), for: .normal)
                btnMyOrder.setImage(UIImage(named: "myOrderUnselected"), for: .normal)
                btnNotification.setImage(UIImage(named: "notificationsUnselected"), for: .normal)
                btnProfile.setImage(UIImage(named: "captainSelected"), for: .normal)
                */
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
        
        UserDefaults.standard.set(true, forKey: "SpecificRootToService")
        
        let vc = ScreenManager.getSignInSignupVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func tap_Help(_ sender: Any) {
        let vc = ScreenManager.getContactUsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    @IBAction func tap_shopsBtn(_ sender: Any) {
        
        if newModule == true {
            if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                
               let vc = ScreenManager.HomeScreenNew_VC()
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                appDelegate.window?.rootViewController = navController
                appDelegate.window?.makeKeyAndVisible()
                
            }
            else{
                
                self.alertWithAction()
            }
            
            
        }else{
            
            let vc = ScreenManager.getServiceProviderMapVC()
                   let navController = UINavigationController(rootViewController: vc)
                   navController.navigationBar.isHidden = true
                   appDelegate.window?.rootViewController = navController
                   appDelegate.window?.makeKeyAndVisible()
               }
            
        }
        
        
       
    
    @IBAction func tap_myOrdersBtn(_ sender: Any) {
        
        if newModule == true {
           
            
            if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                
                let vc = ScreenManager.SearchNew_VC()
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                appDelegate.window?.rootViewController = navController
                appDelegate.window?.makeKeyAndVisible()
                
            }
            else{
                
                self.alertWithAction()
            }
            
        }else{
            if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                       
                      // let vc = ScreenManager.getMyOrderNoralUserScrollerVC()
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
        
        
       
    }
    
    @IBAction func tap_notifications(_ sender: Any) {
        
        if newModule == true {
                   
            
            if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                           
                           let vc = ScreenManager.MyOrderOngoingVC()
                           let navController = UINavigationController(rootViewController: vc)
                           navController.navigationBar.isHidden = true
                           appDelegate.window?.rootViewController = navController
                           appDelegate.window?.makeKeyAndVisible()
                           
                       }
                       else{
                           
                           self.alertWithAction()
                       }
            
        }else{
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
    
    @IBAction func tap_captainsBtn(_ sender: Any) {
        
        
    }
    
    
    
    @IBAction func tap_btnProfessionalDropdown(_ sender: Any) {
        
        dropdownTag = 1
        dropDown.dataSource = dropDownArr
        dropDown.anchorView = btnProfessionalDropdown
        dropDown.show()
    }
    
    @IBAction func tap_btnCaptainDeliveryDropdown(_ sender: Any) {
        
        dropdownTag = 0
        dropDown.dataSource = dropDownArr
        dropDown.anchorView = btnCaptainDeliveryDropdown
        dropDown.show()
    }
    
    
    @IBAction func tap_btnProfessional(_ sender: Any) {
        
        if controllerPurpuse == ""{
            
            UserDefaults.standard.set("", forKey: "RequestDeliveryID")
            
            let vc = ScreenManager.getPrfessionalWorkerGoOrderVC()
            
            vc.comingFrom = "ServiceProviderMap"
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            
            ///here we are applying check for user is regitered as professional worker or not
            
            if CommonClass.sharedInstance.isUserProfessionalWorker == "true"{
                
//                let vc = ScreenManager.getProfessionalWorkerScrollManagerVC()
//                self.navigationController?.pushViewController(vc, animated: true)
                
                self.apiCallForGetFreezeStatus(userType: "Professional")
                
            }
            else{
                
                let vc = ScreenManager.getBecomeAProfessionalWorkerVC()
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
         
        }
    }
    
    @IBAction func tap_btnDelivery(_ sender: Any) {
        
        if controllerPurpuse == ""{
            
            UserDefaults.standard.set("", forKey: "RequestDeliveryID")
            
            let vc = ScreenManager.getDeliveryPersonGoOrderVC()
            
            vc.comingFrom = "ServiceProviderMap"
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            
            ///here we are applying check for user is regitered as delivery worker or not. If delivery worker then redirect to dashboard else redirect to register
            
            if CommonClass.sharedInstance.isUserDeliveryWorker == "true"{
                
//                let vc = ScreenManager.getDeliveryPersonScrollManagerVC()
//                self.navigationController?.pushViewController(vc, animated: true)
                
                self.apiCallForGetFreezeStatus(userType: "Delivery")
            }
            else{
                
                let vc = ScreenManager.getBecomeADeliveryPersonVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
          
        }
    }
    
    @IBAction func tap_menuBtn(_ sender: Any) {
        
        let vc = ScreenManager.getMoreVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tap_notificationBtn(_ sender: Any) {
        
        
        if newModule == true {
            
            if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                
                let vc = ScreenManager.MyOrderOngoingVC()
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                appDelegate.window?.rootViewController = navController
                appDelegate.window?.makeKeyAndVisible()
                
            }
            else{
                
                self.alertWithAction()
            }

            
        }else{
         
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
    }
    
    
    @IBAction func tap_editBtn(_ sender: Any) {
        
        if self.userDataDict.count != 0{
            
            let vc = ScreenManager.getNewEditProfileViewController()
            
            vc.userDataDict = self.userDataDict
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            
            self.apiCallForGetUserDetail()
        }
       
    }
    

}


extension MapWithServicesSepratedVC{
    
    func updateElement(){
        
        if userDataDict.count != 0{
            
            let countryName = userDataDict.object(forKey: "country") as? String ?? ""
            let countryCode = userDataDict.object(forKey: "countryCode") as? String ?? ""
            //   let gender = userDataDict.object(forKey: "gender") as? String ?? ""
            let email = userDataDict.object(forKey: "email") as? String ?? ""
            let appLanguage = userDataDict.object(forKey: "appLanguage") as? String ?? ""
            let speakLanguage = userDataDict.object(forKey: "speakLanguage") as? String ?? ""
            let name = userDataDict.object(forKey: "name") as? String ?? ""
            
            let globalNameStatus = userDataDict.object(forKey: "userName") as? String ?? ""
            
            if globalNameStatus == "true"{
                
                self.lblUserName.text = name
            }
            else{
                
                self.lblUserName.text = name
            }
            
            txtCountryCode.text = "\(countryCode) - \(countryName)"
            // txtGender.text = gender
            txtEmail.text = email
            let newText = appLanguage
            let LocNewText = newText.localized()
            txtAppLang.text = "App - \(LocNewText)"
            txtSpeakLang.text = "Speak - \(speakLanguage)"
            
            imgUser.layer.cornerRadius = imgUser.frame.size.width/2
            imgUser.clipsToBounds = true
            
            let imgStr = userDataDict.object(forKey: "profilePic") as? String ?? ""
            
            let imgUrl = URL(string: imgStr)
            
            if imgUrl != nil{
                
                imgUser.setImageWith(imgUrl!, placeholderImage: UIImage(named:"newPlace"))
                
//                if let data = try? Data(contentsOf: imgUrl!)
//                {
//                    self.imageData = data as NSData
//                }
                
            }
            
        }
        
    }
}


//MARK:- Mapview delegate
//MARK:-
extension MapWithServicesSepratedVC:GMSMapViewDelegate{
    
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
extension MapWithServicesSepratedVC:CLLocationManagerDelegate{
    
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
                
                self.count = self.count + 1
                
                self.apiCallForGetDeliveryWithinRange()
                
                self.apiCallForGetProfessionalWithinRange()
                
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


extension MapWithServicesSepratedVC{
    
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
                        
                        self.lblCaptainDelivery.text = "\(totalDeliveryPerson) Captain Delivery within \(self.initailDeliveryDropDownValue)KM"
                        
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
                        
                        self.lblProfessional.text = "\(totalProfessional) Professional within \(self.initailProfessionalDropDownValue)KM"
                        
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
                                
                                CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
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
        
    }
    
    
    //MARK:-
    //Api for get freeze status
    
    func apiCallForGetFreezeStatus(userType:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetFreezeStatus as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        if let dataDict = receivedData.object(forKey: "Data") as? NSDictionary{
                            
                            if userType == "Delivery"{
                                
                                let activeOrderStatus = dataDict.object(forKey: "deliveryActiveOrder") as? Bool ?? false
                                
                                var activeStatus = ""
                                
                                if activeOrderStatus{
                                    
                                    activeStatus = "yes"
                                }
                                else{
                                    
                                    activeStatus = "no"
                                }
                                
                                let vc = ScreenManager.getDeliveryPersonScrollManagerVC()
                                
                                vc.weNeedToFreezeTheActiveOrder = activeStatus
                                
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            }
                            else{
                                
                                let activeOrderStatus = dataDict.object(forKey: "professionalActiveOrder") as? Bool ?? false
                                
                                var activeStatus = ""
                                
                                if activeOrderStatus{
                                    
                                    activeStatus = "yes"
                                }
                                else{
                                    
                                    activeStatus = "no"
                                }
                                
                                let vc = ScreenManager.getProfessionalWorkerScrollManagerVC()
                                
                                vc.weNeedToFreezeTheActiveOrder = activeStatus
                                
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            }
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
                    
                     CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please try again", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
    
    
    func apiCallForGetUserDetail(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param:[String:String] = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForUserDetail as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        if let response = receivedData.object(forKey: "response") as? NSDictionary{
                            
                            self.userDataDict = response
                            
                            self.updateElement()
                        }
                        
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            if self.newModule == true {
                                
                            }else{
                               CommonClass.sharedInstance.redirectToHome()
                            }
                            
                            
                        }
                        else{
                            if self.newModule == true {
                                
                            }else{
                                CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                            }
                            
                        }
                    }
                }
                else{
                    
                    if self.newModule == true {
                        
                    }else{
                       CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                    }
                    
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
    
    
    
}


