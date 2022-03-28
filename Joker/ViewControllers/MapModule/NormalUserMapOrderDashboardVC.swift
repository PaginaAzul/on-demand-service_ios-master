//
//  NormalUserMapOrderDashboardVC.swift
//  Joker
//
//  Created by Callsoft on 02/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyShadow
import GooglePlaces

class NormalUserMapOrderDashboardVC: UIViewController {

    @IBOutlet weak var containerView: SwiftyInnerShadowView!
    
    @IBOutlet weak var viewDeliveryPerson: SwiftyInnerShadowView!
    
    @IBOutlet weak var viewProfessionalWorker: SwiftyInnerShadowView!
    
    @IBOutlet weak var mapview: GMSMapView!
    
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addressWindow.viewContainer.layer.cornerRadius = 20
        addressWindow.viewContainer.clipsToBounds = true
        addressWindow.layer.cornerRadius = 20
        addressWindow.clipsToBounds = true
        
        viewDeliveryPerson.shadowLayer.cornerRadius = 20.0
        viewDeliveryPerson.clipsToBounds = true
        viewDeliveryPerson.shadowLayer.shadowRadius = 4.0
        viewDeliveryPerson.shadowLayer.shadowColor = UIColor.darkGray.cgColor
        viewDeliveryPerson.shadowLayer.shadowOpacity = 0.8
        viewDeliveryPerson.shadowLayer.shadowOffset = CGSize.zero
        viewDeliveryPerson.generateInnerShadow()
        viewProfessionalWorker.shadowLayer.cornerRadius = 20.0
        viewProfessionalWorker.shadowLayer.shadowRadius = 4.0
        viewProfessionalWorker.shadowLayer.shadowColor = UIColor.darkGray.cgColor
        viewProfessionalWorker.shadowLayer.shadowOpacity = 0.8
        viewProfessionalWorker.shadowLayer.shadowOffset = CGSize.zero
        viewProfessionalWorker.generateInnerShadow()
        
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
        
        UserDefaults.standard.set(true, forKey: "SpecificRootToService")
        
        let vc = ScreenManager.getSignInSignupVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    @IBAction func tap_sideMenuBtn(_ sender: Any) {
        
        let vc = ScreenManager.getMoreVC()
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
    
    @IBAction func tap_professionalWorkerBtn(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "NewRedirectionProfessional") == false {
            
            let vc = ScreenManager.getNormalUserWithProfessionalWorkerScrollerVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            
            UserDefaults.standard.set("", forKey: "RequestDeliveryID")
            
            let vc = ScreenManager.getPrfessionalWorkerGoOrderVC()
            
            vc.comingFrom = "ServiceProviderMap"
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
//        let vc = ScreenManager.getNormalUserWithProfessionalWorkerScrollerVC()
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tap_deliveryPersonBtn(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "NewRedirectionDelivery") == false{
            
            let vc = ScreenManager.getMyOrderNoralUserScrollerVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            
            
            UserDefaults.standard.set("", forKey: "RequestDeliveryID")
            
            let vc = ScreenManager.getDeliveryPersonGoOrderVC()
            
            vc.comingFrom = "ServiceProviderMap"
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}


extension NormalUserMapOrderDashboardVC:GMSMapViewDelegate{
    
    
    func sizeForOffset(view: UIView) -> CGFloat {
        return  96.0
    }
    
    
    func sizeForOffsetX(view: UIView) -> CGFloat{
        return 110.0
    }
    
    
    func configureMap(){
        
        mapview.delegate = self
        
        mapview.clear()
        
        let camera = GMSCameraPosition.camera(withLatitude: AddressLat, longitude: AddressLong, zoom: 14.0)//:::
        
        mapview.camera = camera
        
        let marker = GMSMarker()
        
        let position = CLLocationCoordinate2D(latitude: Double(AddressLat), longitude: Double(AddressLong))
        marker.position = position
        
     // marker.icon = UIImage(named:"jokerMarkerImg")
        
        addressWindow.lblAddress.text = strAddress
        
        marker.iconView = addressWindow
        
        marker.map = mapview
        
        // mapview.selectedMarker = marker
        
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
extension NormalUserMapOrderDashboardVC:CLLocationManagerDelegate{
    
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
