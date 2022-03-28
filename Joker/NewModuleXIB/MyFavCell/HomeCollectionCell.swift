//
//  HomeCollectionCell.swift
//  OWIN
//
//  Created by SinhaAirBook on 20/08/20.
//  Copyright © 2020 Mobulous. All rights reserved.
//

import UIKit
import Cosmos
import CoreLocation

protocol favProtocol {
    func unlike(_ status:Bool , index:Int)
}

class HomeCollectionCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var heartView: UIView!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var imgResaurent: UIImageView!
    @IBOutlet weak var viewCosmos: CosmosView!
    @IBOutlet weak var lblRatingReview: UILabel!
    @IBOutlet weak var btnFavRef: FavtButton!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var disLbl: UILabel!
    
    //MARK:- Variable
    var favDelegate:favProtocol?
    var lat = String()
    var long = String()
    var locationManager = CLLocationManager()
    var vc = UIViewController()
    var locationTExt = ["North Indian" , "Italian" ,"Chinese"]
    var collectionModelArr = [homeScreenModel]()
    var imageSet = String()
    
    let apiHandle = ApiHandler()
    var id = String()
    var distLat = String()
    var distLong = String()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        AccessCurrentLocationuser()
        //locationTap()
        self.btnFavRef.addTarget(self, action: #selector(btnFavClick), for: .touchUpInside)
        self.locationBtn.addTarget(self, action: #selector(locationTap), for: .touchUpInside)
      
    }
    
 
    var item: RestaurantList? {
        
        didSet{
            
            let lat = (item?.latitude ?? "") as NSString
            let long = (item?.longitude ?? "") as NSString
            
            disLbl.text = getDistanceFromCurrentToAll(currentLocationLat: lat.doubleValue , currentLocationLong: long.doubleValue, latitude: GloblaLat, longitude: GloblaLong)
            
            viewCosmos.rating = Double(item?.avgRating ?? 0)
            
            btnFavRef.setImage((item?.isFav ?? true) ? #imageLiteral(resourceName: "fav"):UIImage(named: "Unfav") , for: .normal)
            isFavt = item?.isFav ?? true
            CommonClass.sharedInstance.provideCornarRadius(btnRef: heartView)
            CommonClass.sharedInstance.provideShadow(btnRef: mainView)
            mainView.layer.cornerRadius = 8
            
            imgResaurent.setImage(withImageId: item?.image ?? "", placeholderImage: UIImage())
            
            lblDetails.attributedText = CommonClass.sharedInstance.updateHomeTableViewCellLabel(title: item?.name ?? "", cusineArray: item?.cuisinesName ?? [], address: item?.address ?? "", delemit: "\n")
            id = item?.Id ?? ""
            self.distLat = item?.latitude ?? ""
            self.distLong = item?.longitude ?? ""
            
            let avgRat = Double(round(item?.avgRating ?? 0.0))
            lblRatingReview.text = "\(avgRat) (\(item?.totalRating ?? 0) \("Reviews".localized()))"
        }
    }
    
    var Storeitem: StoreList? {
        
        didSet{
            
            let lat = (Storeitem?.latitude ?? "") as NSString
            let long = (Storeitem?.longitude ?? "") as NSString
            disLbl.text = getDistanceFromCurrentToAll(currentLocationLat: lat.doubleValue , currentLocationLong: long.doubleValue, latitude: GloblaLat, longitude: GloblaLong)
            viewCosmos.rating = Double(Storeitem?.avgRating ?? 0)
           
            let avgRat =  Double(round(Storeitem?.avgRating ?? 0.0))
            lblRatingReview.text = "\(avgRat) (\(Storeitem?.totalRating ?? 0) \("Reviews".localized()))"
            
            btnFavRef.setImage((Storeitem?.isFav ?? true) ? #imageLiteral(resourceName: "fav"):UIImage(named: "Unfav") , for: .normal)
            
            isFavt = Storeitem?.isFav ?? true
            CommonClass.sharedInstance.provideCornarRadius(btnRef: heartView)
            CommonClass.sharedInstance.provideShadow(btnRef: mainView)
            mainView.layer.cornerRadius = 8
            
            imgResaurent.setImage(withImageId: Storeitem?.image ?? "", placeholderImage: UIImage())
            
            lblDetails.attributedText = CommonClass.sharedInstance.updateHomeTableViewCellLabelGrocery(title: Storeitem?.name ?? "", cusineArray: Storeitem?.cuisinesName ?? [], address: Storeitem?.address ?? "", delemit: "\n")
            id = Storeitem?.Id ?? ""
            self.distLat = Storeitem?.latitude ?? ""
            self.distLong = Storeitem?.longitude ?? ""
            
        }
        
    }
    
    var itemFavt:FavtData? {
        didSet{
            let lat = (itemFavt?.sellerData?.latitude ?? "") as NSString
            let long = (itemFavt?.sellerData?.longitude ?? "") as NSString
            disLbl.text = getDistanceFromCurrentToAll(currentLocationLat: lat.doubleValue , currentLocationLong: long.doubleValue, latitude: GloblaLat, longitude: GloblaLong)
            viewCosmos.rating = Double(itemFavt?.sellerData?.avgRating ?? 0)
            
            
            btnFavRef.setImage( #imageLiteral(resourceName: "fav") , for: .normal)
            btnFavRef.isUserInteractionEnabled = true
           // isFavt = item?.isFav ?? true
            CommonClass.sharedInstance.provideCornarRadius(btnRef: heartView)
            CommonClass.sharedInstance.provideShadow(btnRef: mainView)
            mainView.layer.cornerRadius = 8
            
            imgResaurent.setImage(withImageId: itemFavt?.sellerData?.image ?? "", placeholderImage: UIImage())
            
            lblDetails.attributedText = CommonClass.sharedInstance.updateHomeTableViewCellLabel(title: itemFavt?.sellerData?.name ?? "", cusineArray: itemFavt?.sellerData?.cuisinesName ?? [], address: itemFavt?.sellerData?.address ?? "", delemit: "\n")
          //  id = item?.resAndStoreId ?? ""
            self.distLat = itemFavt?.sellerData?.latitude ?? ""
            self.distLong = itemFavt?.sellerData?.longitude ?? ""
        }
    }
    
    //MARK:- favt Method
    @objc func btnFavClick(_ sender : UIButton){
        
        guard UserDefaults.standard.bool(forKey: "IsUserLogin") else {
           // alertWithAction()
            CommonClass.sharedInstance.alertWithAction()
            return
        }
       
        guard CommonClass.sharedInstance.isConnectedToNetwork() else {
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: commonController)
            return
        }
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                     "resAndStoreId":self.id,
                     "langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ]
        
        print("param At fav" , param)
        
        apiHandle.fetchApiService(method: .post, url: Domain.baseUrl().appending(APIEndpoint.addToFavourite), passDict: param, header: header) { (result) in
            switch result{
            
            case .success(let data):
                print(data)
                
                let response_message = data["response_message"].stringValue
                
                if response_message == "Added to favourite successfully".localized(){
                    self.btnFavRef.setImage(#imageLiteral(resourceName: "fav") , for: .normal)
                    isFavt = true
                    self.btnFavRef.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    
                    UIView.animate(withDuration: 2.0,
                                   delay: 0,
                                   usingSpringWithDamping: 0.2,
                                   initialSpringVelocity: 6.0,
                                   options: .allowUserInteraction,
                                   animations: { [weak self] in
                                    self?.btnFavRef.transform = .identity
                                   },
                                   completion: nil)
                    
                    
                }else if response_message == "Remove from favourite successfully".localized(){
                    self.btnFavRef.setImage(UIImage(named: "Unfav") , for: .normal)
                    isFavt = false
                    self.favDelegate?.unlike(true, index: sender.tag)
                } else{
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: response_message, controller: commonController)
                }
                
            break
            case .failure(let error):
                CommonClass.sharedInstance.callNativeAlert(title: "", message: error.localizedDescription, controller: commonController)
                break
            }
        }
    }
    
    //MARK:- Location Method
    
    @objc func locationTap(){
        CommonClass.sharedInstance.openMapButtonAction(commonController, distLat, distLong)
    }
}

//MARK:- Get Total Distance From Current Location

extension HomeCollectionCell{
    func getDistanceFromCurrentToAll(currentLocationLat:Double,currentLocationLong:Double,latitude:String,longitude:String) -> String{
        
        let lati = latitude.trimmingCharacters(in: .whitespaces)
        let longi = longitude.trimmingCharacters(in: .whitespaces)
        guard currentLocationLat != 0.0 || currentLocationLong != 0.0 || lati == "" || longi == "" else {
            return ""
        }
        let coordinate₀ = CLLocation(latitude: currentLocationLat, longitude: currentLocationLong)
        let coordinate₁ = CLLocation(latitude: Double(lati) ?? 0.0, longitude: Double(longi) ?? 0.0)
        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
        let distanceInKm = distanceInMeters / 1000
        var integerDistance = Double()
        if distanceInKm < 1.0 && distanceInKm > 0.0{
            integerDistance = 1
        }
        else{
            integerDistance =  Double(round(distanceInKm))
        }
        return "\(integerDistance) \("KM".localized())"
        
    }
    
}
//MARK: - Extension Location Delegates
extension HomeCollectionCell {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation:CLLocation = locations.first!
        print("LATTITUDE IS:", currentLocation.coordinate.latitude)
        print("LONGITUDE IS:", currentLocation.coordinate.longitude)
        self.lat = String(currentLocation.coordinate.latitude)
        self.long = String(currentLocation.coordinate.longitude)
        self.locationManager.delegate = nil
        // nearByResService()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}

//MARK: - Extension Method Access Current Location
extension HomeCollectionCell: CLLocationManagerDelegate {
    
    func AccessCurrentLocationuser(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }else{
            let locationAlert = UIAlertController(title: "Data Collection", message: "GPS is not enabled. Do you want to go to settings menu?", preferredStyle: UIAlertController.Style.alert)
            locationAlert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { (alert: UIAlertAction!) in
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            }))
            locationAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction) in}))
        }
    }
}

class FavtButton: UIButton{
    var isFavt = Bool()
   
}
