//
//  MyOrderDashboardVC.swift
//  Joker
//
//  Created by abc on 30/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit
import GoogleMaps

class MyOrderDashboardVC: UIViewController {

    
    var locationManager : CLLocationManager = CLLocationManager()
    var AddressLat:Double = 0.0 //28.626169
    var AddressLong:Double = 0.0 //77.377365
    var count = 0
    
    var userType = ""
    let connection = webservices()
    
    var signupWithNormalPerson = ""
    var signupWithDeliveryPerson = ""
    var signupWithProfessionalPerson = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        CommonClass.sharedInstance.locationLatCordinate = AddressLat
        CommonClass.sharedInstance.locationLongCordinate = AddressLong
        
        self.apiCallForGetUserType()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        if CLLocationManager.locationServicesEnabled() {
//            switch CLLocationManager.authorizationStatus() {
//            case .notDetermined, .restricted, .denied:
//                print("No access")
//
//                self.alertToRedirectSettings()
//
//            case .authorizedAlways, .authorizedWhenInUse:
//                print("Access")
//
//                self.getLocation()
//            }
//        } else {
//
//            self.alertToRedirectSettings()
//            print("Location services are not enabled")
//
//        }
        
        count = 0
        
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
        
    }
  
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_normalUserBtn(_ sender: Any) {
        
        
//        if userType == "NormalUser"{
//
//            UserDefaults.standard.set(false, forKey: "NewRedirectionDelivery")
//            UserDefaults.standard.set(false, forKey: "NewRedirectionProfessional")
//
//            let vc = ScreenManager.getNormalUserMapOrderDashboardVC()
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        else{
//
//             CommonClass.sharedInstance.callNativeAlert(title: "", message: "You are not a normal user so you can't access the normal user dashboard", controller: self)
//        }
        
        if signupWithNormalPerson == "true"{
            
            UserDefaults.standard.set(false, forKey: "NewRedirectionDelivery")
            UserDefaults.standard.set(false, forKey: "NewRedirectionProfessional")
            
            let vc = ScreenManager.getNormalUserMapOrderDashboardVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Your profile is not verified as a normal user", controller: self)
        }
      
    }
    
    @IBAction func tap_deliveryWorkerBtn(_ sender: Any) {
        
//        if userType == "DeliveryPersion"{
//
//            let vc = ScreenManager.getDeliveryPersonScrollManagerVC()
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        else{
//
//             CommonClass.sharedInstance.callNativeAlert(title: "", message: "You are not a delivery person so you can't access the delivery person dashboard", controller: self)
//        }
        
        
        if signupWithDeliveryPerson == "true"{
            
            let vc = ScreenManager.getDeliveryPersonScrollManagerVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Your profile is not verified as a delivery worker", controller: self)
        }
        
    }
    
    @IBAction func tap_professionalBtn(_ sender: Any) {
        
//        if userType == "ProfessionalWorker"{
//
//            let vc = ScreenManager.getProfessionalWorkerScrollManagerVC()
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        else{
//
//            CommonClass.sharedInstance.callNativeAlert(title: "", message: "You are not a professional worker so you can't access the professional worker dashboard", controller: self)
//        }
        
        
        if signupWithProfessionalPerson == "true"{
            
            let vc = ScreenManager.getProfessionalWorkerScrollManagerVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Your profile is not verified as a professional worker", controller: self)
        }
      
    }
    
}


//MARK:- Custom Method
//MARK:-
extension MyOrderDashboardVC{
    
    func alertToRedirectSettings(){
        
        let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
    
            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func getLocation(){
        
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
        
    }
    
}





//MARK:- Location Manager Delegate
//MARK:-
extension MyOrderDashboardVC:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            
            let currentLocation:CLLocation = locations.first!
            manager.stopUpdatingLocation()
                        
            if count == 0{
                
                self.AddressLat = currentLocation.coordinate.latitude
                self.AddressLong = currentLocation.coordinate.longitude
                
                CommonClass.sharedInstance.locationLatCordinate = AddressLat
                CommonClass.sharedInstance.locationLongCordinate = AddressLong
                
                self.count = self.count + 1
                
            }
            
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
            
            self.locationManager.startUpdatingLocation()
            if CLLocationManager.headingAvailable() {
                self.locationManager.headingFilter = 100
            }
            
        case .denied, .notDetermined, .restricted:
            print("Location Denied/NotDetermined/Restricted")
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



extension MyOrderDashboardVC{
    
    func apiCallForGetUserType(){
        
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
                        
                        self.signupWithNormalPerson = receivedData.object(forKey: "signupWithNormalPerson") as? String ?? ""
                        
                        self.signupWithDeliveryPerson = receivedData.object(forKey: "adminVerifyDeliveryPerson") as? String ?? ""
                        
                        self.signupWithProfessionalPerson = receivedData.object(forKey: "adminVerifyProfessionalWorker") as? String ?? ""
                        
                        let profilePic = receivedData.object(forKey: "profilePic") as? String ?? ""
                        
                        UserDefaults.standard.setValue(profilePic, forKey: "ProfilePicForChatUse")
                        
                        CommonClass.sharedInstance.isUserProfessionalWorker = receivedData.object(forKey: "adminVerifyProfessionalWorker") as? String ?? ""
                        
                        CommonClass.sharedInstance.isUserDeliveryWorker = receivedData.object(forKey: "adminVerifyDeliveryPerson") as? String ?? ""
                        
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToHome()
                        }
                        else{
                            
                            self.navigationController?.popViewController(animated: true)
                            
                            CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                        }
                    }
                }
                else{
                    
                    self.navigationController?.popViewController(animated: true)
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
             CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
    
}
