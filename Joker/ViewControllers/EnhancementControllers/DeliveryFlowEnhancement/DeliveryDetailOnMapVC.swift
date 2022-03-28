//
//  DeliveryDetailOnMapVC.swift
//  Joker
//
//  Created by retina on 02/09/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyShadow


class DeliveryDetailOnMapVC: UIViewController {

    @IBOutlet weak var lblRequiredHours: UILabel!
    
    @IBOutlet weak var mapview: GMSMapView!
    
    @IBOutlet weak var viewRequestOrder: SwiftyInnerShadowView!
    
    @IBOutlet weak var lblPickupLocation: UILabel!
    
    @IBOutlet weak var lblPickupDistance: UILabel!
    
    @IBOutlet weak var lblDropoffLocation: UILabel!
    
    @IBOutlet weak var lblDropOffDistance: UILabel!
    
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var lblNavHeader: UILabel!
    
    @IBOutlet weak var deliveryInfoStackView: UIStackView!
    
    @IBOutlet weak var professionalInfoView: UIView!
    
    @IBOutlet weak var lblServiceLocationProfessional: UILabel!
    
    @IBOutlet weak var lblDistanceBetweenServiceLocation: UILabel!
    
    
    var dataDict = NSDictionary()
    
    var controllerPurpuse = ""
    
    var controllerInfoForm = ""
    
    let addressWindow = Bundle.main.loadNibNamed("DeliveryAddress", owner: self, options: nil)!.first! as! DeliveryAddress
    
    let pickupWindow = Bundle.main.loadNibNamed("DeliveryAddress", owner: self, options: nil)!.first! as! DeliveryAddress
    
    let dropoffWindow = Bundle.main.loadNibNamed("DeliveryAddress", owner: self, options: nil)!.first! as! DeliveryAddress
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewRequestOrder.shadowLayer.cornerRadius = 20.0
        viewRequestOrder.shadowLayer.shadowRadius = 4.0
        viewRequestOrder.shadowLayer.shadowColor = UIColor.darkGray.cgColor
        viewRequestOrder.shadowLayer.shadowOpacity = 0.8
        viewRequestOrder.shadowLayer.shadowOffset = CGSize.zero
        viewRequestOrder.generateInnerShadow()
        
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
        
       // configureMap()
        
        initialSetup()
        
    }
    
    @IBAction func tap_continueBtn(_ sender: Any) {
        
        UserDefaults.standard.set("", forKey: "OfferIDToUpdate")
        
        if self.controllerInfoForm == ""{
            
            let vc = ScreenManager.getSubmitOfferAsDeliveryVC()
            vc.dict = self.dataDict
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            
            let vc = ScreenManager.getSubmitOfferAsProfessionalWorkerVC()
            vc.dict = self.dataDict
            self.navigationController?.pushViewController(vc, animated: true)
        }
     
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tap_serviceLocationProfessionalSide(_ sender: Any) {
        
        if dataDict.count != 0{
            
            let pickupLat = dataDict.object(forKey: "pickupLat") as? Double ?? 00
            let pickupLong = dataDict.object(forKey: "pickupLong") as? Double ?? 00
            
            let locationURl = "https://www.google.com/maps?q=\(pickupLat),\(pickupLong)&z=17&hl=en"
            
            guard let url = URL(string: locationURl) else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }
    }
    
    @IBAction func tap_pickupLocationDeliverySide(_ sender: Any) {
        
        if dataDict.count != 0{
            
            let pickupLat = dataDict.object(forKey: "pickupLat") as? Double ?? 00
            let pickupLong = dataDict.object(forKey: "pickupLong") as? Double ?? 00
            
            let locationURl = "https://www.google.com/maps?q=\(pickupLat),\(pickupLong)&z=17&hl=en"
            
            guard let url = URL(string: locationURl) else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }
    }
    
    @IBAction func tap_dropOffLocationDeliverySide(_ sender: Any) {
        
        if dataDict.count != 0{
            
            let dropLat = dataDict.object(forKey: "dropOffLat") as? Double ?? 00
            let dropLong = dataDict.object(forKey: "dropOffLong") as? Double ?? 00
            
            let locationURl = "https://www.google.com/maps?q=\(dropLat),\(dropLong)&z=17&hl=en"
            
            guard let url = URL(string: locationURl) else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }
    }
    
}


extension DeliveryDetailOnMapVC:GMSMapViewDelegate{
    
    func initialSetup(){
        
        if self.controllerInfoForm == ""{
            
            ///Delivery Flow Coding(user and worker)
            
            professionalInfoView.isHidden = true
            deliveryInfoStackView.isHidden = false
            
            if self.controllerPurpuse == "TrackingDelivierySide"{
                
                self.btnContinue.isHidden = true
                self.viewRequestOrder.isHidden = true
            }
            else{
                
                self.btnContinue.isHidden = false
                self.viewRequestOrder.isHidden = false
            }
        }
        else{
            
            ///Professional Flow Coding(user and worker)
            
            self.lblNavHeader.text = "Service Location Details"
            
            if self.controllerPurpuse == "TrackingProfessionalSide"{
                
                self.btnContinue.isHidden = true
                self.viewRequestOrder.isHidden = true
            }
            else{
                
                self.btnContinue.isHidden = false
                self.viewRequestOrder.isHidden = false
            }
            
            professionalInfoView.isHidden = false
            deliveryInfoStackView.isHidden = true
            
        }
            
        
        let estimatedTime = self.dataDict.object(forKey: "seletTime") as? String ?? ""
        
        if estimatedTime != ""{
            
            let estimatedArr = estimatedTime.split(separator: " ")
            
            if estimatedArr.count != 0 && estimatedArr.count == 3{
                
                print(estimatedArr[1])
                print(estimatedArr[2])
                
                self.lblRequiredHours.text = "\(estimatedArr[1]) \(estimatedArr[2])"
                
            }
            
        }
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
        
        addressWindow.lblAddress.text = self.strAddress
        addressWindow.lblAddressType.text = "You"
        
        marker.iconView = addressWindow
        
        marker.map = mapview
        
        let pickupLat = dataDict.object(forKey: "pickupLat") as? Double ?? 00
        let pickupLong = dataDict.object(forKey: "pickupLong") as? Double ?? 00
        let pickupAddress = dataDict.object(forKey: "pickupLocation") as? String ?? ""
        
        let dropLat = dataDict.object(forKey: "dropOffLat") as? Double ?? 00
        let dropLong = dataDict.object(forKey: "dropOffLong") as? Double ?? 00
        let dropAddress = dataDict.object(forKey: "dropOffLocation") as? String ?? ""
        
        let pickupMarker = GMSMarker()
        let dropoffMarker = GMSMarker()
        
        let pickupPosition = CLLocationCoordinate2D(latitude: Double(pickupLat), longitude: Double(pickupLong))
        pickupMarker.position = pickupPosition
        
        if self.controllerPurpuse == "TrackingDelivierySide"{
            
            pickupWindow.lblAddress.text = self.getDistanceFromCurrentToAll(currentLocationLat: AddressLat, currentLocationLong: AddressLong, latitude: pickupLat, longitude: pickupLong)
            
            pickupWindow.lblAddress.textAlignment = .center
        }
        else{
            
            pickupWindow.lblAddress.text = pickupAddress
        }
      
        pickupWindow.lblAddressType.text = "Pickup"
        
        pickupWindow.viewAddressType.backgroundColor = UIColor(red:0.99, green:0.69, blue:0.24, alpha:1.0)
        pickupWindow.imgMarker.image = UIImage(named: "pickupOrange")
        
        pickupMarker.iconView = pickupWindow
        pickupMarker.map = mapview
        
        self.lblPickupLocation.text = pickupAddress
        self.lblPickupDistance.text = self.getDistanceFromCurrentToAll(currentLocationLat: AddressLat, currentLocationLong: AddressLong, latitude: pickupLat, longitude: pickupLong)
        
        let dropPosition = CLLocationCoordinate2D(latitude: Double(dropLat), longitude: Double(dropLong))
        dropoffMarker.position = dropPosition
        dropoffWindow.lblAddressType.text = "Dropoff"
        
        if self.controllerPurpuse == "TrackingDelivierySide"{
            
            dropoffWindow.lblAddress.text = self.getDistanceFromCurrentToAll(currentLocationLat: AddressLat, currentLocationLong: AddressLong, latitude: dropLat, longitude: dropLong)
            
            dropoffWindow.lblAddress.textAlignment = .center
        }
        else{
            
            dropoffWindow.lblAddress.text = dropAddress
        }
        
        dropoffWindow.viewAddressType.backgroundColor = UIColor(red:0.24, green:0.62, blue:0.14, alpha:1.0)
        dropoffWindow.imgMarker.image = UIImage(named: "dropoffGreen")
        
        dropoffMarker.iconView = dropoffWindow
        dropoffMarker.map = mapview
        
        self.lblDropoffLocation.text = dropAddress
        
        self.lblDropOffDistance.text = self.getDistanceFromCurrentToAll(currentLocationLat: AddressLat, currentLocationLong: AddressLong, latitude: dropLat, longitude: dropLong)
        
    }
    
    
    func configuringMapForProfessional(){
        
        self.mapview.clear()
        
        mapview.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: AddressLat, longitude: AddressLong, zoom: 14.0)//:::
        
        mapview.camera = camera
        
        let marker = GMSMarker()
        
        let position = CLLocationCoordinate2D(latitude: Double(AddressLat), longitude: Double(AddressLong))
        marker.position = position
        
        addressWindow.lblAddress.text = self.strAddress
        addressWindow.lblAddressType.text = "You"
        
        marker.iconView = addressWindow
        
        marker.map = mapview
        
        let pickupLat = dataDict.object(forKey: "pickupLat") as? Double ?? 00
        let pickupLong = dataDict.object(forKey: "pickupLong") as? Double ?? 00
        let pickupAddress = dataDict.object(forKey: "pickupLocation") as? String ?? ""
        
        let pickupMarker = GMSMarker()
        
        let pickupPosition = CLLocationCoordinate2D(latitude: Double(pickupLat), longitude: Double(pickupLong))
        pickupMarker.position = pickupPosition
        
        pickupWindow.lblAddress.text = pickupAddress
        
        pickupWindow.lblAddressType.text = "Service"
        
        pickupWindow.viewAddressType.backgroundColor = UIColor(red:0.99, green:0.69, blue:0.24, alpha:1.0)
        pickupWindow.imgMarker.image = UIImage(named: "dropoffGreen")
        
        pickupMarker.iconView = pickupWindow
        pickupMarker.map = mapview
        
        self.lblServiceLocationProfessional.text = pickupAddress
        self.lblDistanceBetweenServiceLocation.text = self.getDistanceFromCurrentToAll(currentLocationLat: AddressLat, currentLocationLong: AddressLong, latitude: pickupLat, longitude: pickupLong)
        
//        if self.controllerPurpuse == "TrackingProfessionalSide"{
//            
//
//        }
        
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
                    
                    if self.controllerInfoForm == ""{
                        
                        //configuring map for delivery(user and worker) flow
                        
                        self.configureMap()
                    }
                    else{
                        
                        //configuring map for professional(user and worker)  flow
                        
                        self.configuringMapForProfessional()
                    }
                    
                }
            }
        }
    }
    
    
    func getDistanceFromCurrentToAll(currentLocationLat:Double,currentLocationLong:Double,latitude:Double,longitude:Double) -> String{
        
        print(currentLocationLat)
        print(currentLocationLong)
        print(latitude)
        print(longitude)
        
        let coordinate₀ = CLLocation(latitude: currentLocationLat, longitude: currentLocationLong)
        
        let coordinate₁ = CLLocation(latitude: latitude, longitude: longitude)
        
        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
        var distanceInKm = distanceInMeters / 1000
 
        distanceInKm = distanceInKm.rounded(toPlaces: 2)
        
        return "\(distanceInKm) Km"
        
    }
    
    
}

extension Double {
   
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}



extension DeliveryDetailOnMapVC:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            
            let currentLocation:CLLocation = locations.first!
            manager.stopUpdatingLocation()
            
            self.AddressLat = currentLocation.coordinate.latitude
            self.AddressLong = currentLocation.coordinate.longitude
            
            self.mapview.animate(toLocation: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude))
            
           // configureMap()
            
            if count == 0{
                
                self.initialLat = self.AddressLat
                self.initialLong = self.AddressLong
                
                self.count = self.count + 1
                
                CommonClass.sharedInstance.locationLatCordinate = AddressLat
                CommonClass.sharedInstance.locationLongCordinate = AddressLong
                
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
