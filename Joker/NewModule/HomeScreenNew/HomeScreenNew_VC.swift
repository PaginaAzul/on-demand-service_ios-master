//
//  HomeScreenNew_VC.swift
//  Joker
//
//  Created by cst on 21/10/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit
import Foundation
import GoogleMaps
import GooglePlaces
import CoreLocation

struct homeScreenModel{
    
    var title:String
    var categoryArr:[String]
    var address:String
    var distance:String
    var image:String
    
}


class HomeScreenNew_VC: UIViewController,GetAddressFromMapDelegate {
    
    func getAddress(address: String,lat: String,long: String) {
        
        locationManager.stopUpdatingLocation()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            
            GloblaLong = long
            GloblaLat = lat
            self.txtFieldHeader.text = address
            self.getapiService()
            
        }
        
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var tblViewHome: UITableView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var txtFieldHeader: UITextField!
    @IBOutlet weak var heightHeader: NSLayoutConstraint!
    
    @IBOutlet weak var locationBtnTapp: UIButton!
    @IBOutlet weak var btnCart: UIButton!
    
    @IBOutlet weak var btnTabHome:UIButton!
    @IBOutlet weak var btnTabSearch:UIButton!
    
    @IBOutlet weak var btnTabMyOrder:UIButton!
    @IBOutlet weak var btnTabProfile:UIButton!
    @IBOutlet weak var btnTabHelp:UIButton!
    
    @IBOutlet weak var lblTabHome: UILabel!
    
    @IBOutlet weak var lblTabMyOrder: UILabel!
    @IBOutlet weak var lblTabSearch: UILabel!
    @IBOutlet weak var lblTabProfile: UILabel!
    @IBOutlet weak var lblTabHelp: UILabel!

    var mainArrCate = ["Exclusive Offers".localized(),"Near-by Restaurants".localized(),"Near-by Grocery Stores".localized()]
    var collectionModelArr = [homeScreenModel]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var locationManager = CLLocationManager()
    var latM = CLLocationDegrees()
    var langM = CLLocationDegrees()
    
    var userLatitude = Double()
    var userLongitude = Double()
    let viewModel = ViewModel()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblViewHome.tableFooterView = UIView()
        commonController = self
        initializeTheLocationManager()
        //self.getapiService()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Localize.currentLanguage() == "en" {
            
        }else{
            
            lblTabHome.text = "Home".localized()
            lblTabMyOrder.text = "My Order".localized()
            lblTabSearch.text = "Search".localized()
            lblTabProfile.text = "My Profile".localized()
            lblTabHelp.text = "Help".localized()
            
        }
        self.getapiService()
        
        /*
        commonController = self
        self.getapiService()
        */
        
        getCountV()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       // getCountV()
    }
   
    @IBAction func tap_menuBtn(_ sender: Any) {
        let vc = ScreenManager.getMoreVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_cartBtn(_ sender: Any) {
        
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            UserDefaults.standard.removeObject(forKey: "Shop")
            let vc = ScreenManager.MyCartNew_VC()
            vc.comgFromOffer = false
            let data = self.viewModel.ResAndStoreDetailArray.first?.Data?.resAndStoreDetail
            //print("data...........\(data)")
            if let closingTime = data?.closingTime{
                print("closingDate.........\(closingTime)")
                vc.closingTime = closingTime
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            self.alertWithAction()
        }
        
    }
    
    @IBAction func tap_HometBtn(_ sender: Any) {
    
    }
    
    
    
    @IBAction func tapReDirectOnMap(_ sender: UIButton) {
        
        let vc = ScreenManager.mainStoryboard().instantiateViewController(withIdentifier: "AddressPickerVC") as! AddressPickerVC
        vc.addressDelegate = self
        vc.isComing = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tap_SearchBtn(_ sender: Any) {
        
       // if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            let vc = ScreenManager.SearchNew_VC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navController
            appDelegate.window?.makeKeyAndVisible()
            
//        }
//        else{
//            self.alertWithAction()
//        }
        
    }
    
    
    @IBAction func tap_Help(_ sender: Any) {
        let vc = ScreenManager.getContactUsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func tap_MyOrdersBtn(_ sender: Any) {
        
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
        
    }
    
    @IBAction func tap_MyProfileBtn(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            UserDefaults.standard.set(true, forKey: "NewModul")
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
    
    func makeRootToLoginSignup(){
        
        let vc = ScreenManager.getSignInSignupVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
        
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
    
}


extension HomeScreenNew_VC:CLLocationManagerDelegate {
    
    
    //TODO: Method Access Current Location
    func initializeTheLocationManager() {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        locationManager.startUpdatingHeading()
        
        var location = locationManager.location?.coordinate
        //cameraMoveToLocation(toLocation: location)
        latM = CLLocationDegrees(location?.latitude ?? 0.0)
        langM = CLLocationDegrees(location?.longitude ?? 0.0)
        
        GloblaLat = location?.latitude.description ?? ""
        GloblaLong = location?.longitude.description ?? ""

        self.reverseGeocodeCoordinate(inLat: location?.latitude ?? 0.0, inLong: location?.longitude ?? 0.0)
        print("lat and long home \(latM) \(langM)")
        
    }
    
    func reverseGeocodeCoordinate(inLat:Double, inLong:Double) {
        
        let cordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: inLat, longitude: inLong)
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(cordinate) { response, error in
            
            if let address = response?.results() {
                
                let lines = address.first
                
                if let addressNew = lines?.lines {
                    
                    self.txtFieldHeader.text = self.makeAddressString(inArr: addressNew)
                    UserDefaults.standard.set("\(self.makeAddressString(inArr: addressNew))", forKey: "CurrentAdd")
                    
                }
            }
        }
    }

    func makeAddressString(inArr:[String]) -> String {
        
        var fVal:String = ""
        for val in inArr {
            
            fVal =  fVal + val + " "
            
        }
        
        return fVal
        
    }

}
func getDistanceFromCurrentToAll(currentLocationLat:Double,currentLocationLong:Double,latitude:String,longitude:String) -> String{
    
    print(currentLocationLat)
    print(currentLocationLong)
    print(latitude)
    print(longitude)
    
    if currentLocationLat == 0.0 || currentLocationLong == 0.0{
        
        return ""
    }
    
    let lati = latitude.trimmingCharacters(in: .whitespaces)
    let longi = longitude.trimmingCharacters(in: .whitespaces)
    
    if lati == "" || longi == ""{
        
        return ""
    }
    
    let doubleLat = Double(lati)
    let doubleLong = Double(longi)
    
    let coordinate₀ = CLLocation(latitude: currentLocationLat, longitude: currentLocationLong)
    
    let coordinate₁ = CLLocation(latitude: doubleLat!, longitude: doubleLong!)
    
    let distanceInMeters = coordinate₀.distance(from: coordinate₁)
    let distanceInKm = distanceInMeters / 1000
    
    var integerDistance = Int()
    
    if distanceInKm < 1.0 && distanceInKm > 0.0{
        
        integerDistance = 1
    }
    else{
        
        integerDistance = Int(distanceInKm)
    }
    
    return "\(integerDistance) \("KM".localized())"
    
}

var GloblaLat = String()
var GloblaLong = String()

func alertWithAction(){
    
    let alertController = UIAlertController(title: "", message: "You are not logged in. Please login/signup before proceeding further.".localized(), preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
        UIAlertAction in
        
        makeRootToLoginSignup()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
        UIAlertAction in
        
    }
    
    alertController.addAction(okAction)
    alertController.addAction(cancelAction)
    commonController.present(alertController, animated: true, completion: nil)
    
}

func makeRootToLoginSignup(){
    
    let vc = ScreenManager.getSignInSignupVC()
    let navController = UINavigationController(rootViewController: vc)
    navController.navigationBar.isHidden = true
    appDel.window?.rootViewController = navController
    appDel.window?.makeKeyAndVisible()
    
}
