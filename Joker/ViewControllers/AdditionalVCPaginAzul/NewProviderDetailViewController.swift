//
//  NewProviderDetailViewController.swift
//  Joker
//
//  Created by retina on 19/06/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit
import GoogleMaps

class NewProviderDetailViewController: UIViewController {

    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var lblAvgRating: UILabel!
    
    @IBOutlet weak var btnViewAllRating: UIButton!
    
    @IBOutlet weak var lblChargeOffer: UILabel!
    
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblCategory: UILabel!
    
    @IBOutlet weak var lblModeOfTransport: UILabel!
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    @IBOutlet weak var lblNav: UILabel!

    @IBOutlet weak var lblChargeOfferHeading: UILabel!
    
    @IBOutlet weak var lblMsgHeading: UILabel!
    
    @IBOutlet weak var lblWorkCompletionHeading: UILabel!
    
    @IBOutlet weak var lblCategoryHeading: UILabel!
    
    @IBOutlet weak var lblModeofTransportHeading: UILabel!
    
    @IBOutlet weak var lblPreviousWorkHeading: UILabel!
    
    
    let connection = webservices()
    
    var userID = ""
    
    var dictRatingResponse = NSDictionary()
    
    var distance = ""
    var msg = ""
    var workTime = ""
    var category = ""
    var chargeOffer = ""
    var totalRating = 0
    var modeOfTransport = ""
    
    var avgRating = 0.0
    var name = ""
    var imgStr = ""
    
    var currency = ""
    
    var langCategory = ""
    
    var locDict = NSDictionary()
    
    var longitudeT = Double()
    var latitudeT = Double()
    
    var selfCurrentLatT = Double()
    var selfCurrentLongT = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        localization()
        initialSetup()
        //self.apiCallForGetUserDetail()
    }
    
    func localization(){
        
        lblNav.text = "Provider detail".localized()
        lblChargeOfferHeading.text = "Charge Offer".localized()
        lblWorkCompletionHeading.text = "Work Completion Time".localized()
        lblCategoryHeading.text = "Category".localized()
        lblModeofTransportHeading.text = "Mode of Transport".localized()
        lblMsgHeading.text = "Message".localized()
        lblPreviousWorkHeading.text = "Previous Work".localized()
    }
    
    
    @IBAction func tap_viewAllrating(_ sender: Any) {
        
        let vc = ScreenManager.getUserDetailVC()
        vc.userID = userID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_navigationBtn(_ sender: Any) {
        
        let vc = ScreenManager.getTackDistanceVCViewController()
        
       // TackDistanceVCViewController
        
        vc.latM = longitudeT
        vc.langM = latitudeT
        vc.userLatitude = selfCurrentLatT
        vc.userLongitude = selfCurrentLongT
        
        print("selfCurrentLatT /selfCurrentLongT /latitudeT /longitudeT",selfCurrentLatT , selfCurrentLongT ,latitudeT ,longitudeT)
        self.navigationController?.pushViewController(vc, animated: true)
        print(self.longitudeT,self.latitudeT)
        
    }
    
    
    
    
}


extension NewProviderDetailViewController{
    
    func initialSetup(){
        
       // lblDistance.text = "\(distance) KM"
        
        if totalRating == 0{
            
            btnViewAllRating.setTitle("(0 "+"Rating".localized()+")", for: .normal)
            btnViewAllRating.isUserInteractionEnabled = false
        }
        else{
            
            btnViewAllRating.setTitle("(\(totalRating) "+"Rating View All".localized()+")", for: .normal)
            btnViewAllRating.isUserInteractionEnabled = true
        }
        
        lblChargeOffer.text = "\(chargeOffer) \(currency)"
        
        if msg == ""{
            
             lblMessage.text = "Not Defined".localized()
        }
        else{
            
             lblMessage.text = msg
        }
        
        lblCategory.text = category
        
        
        print("Category At NewProviderDetailViewController",category )
        
        var vehicleTypeEnglishArr = ["Own Vehicle","Company Vehicle","No Vehicle"]
        
        var vehicleTypePortuguseArr = ["Carro próprio","Carro da empresa","Sem transporte"]
        
        var transPortMode = String()
        
        if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
            for index in 0..<vehicleTypeEnglishArr.count {
                if modeOfTransport == vehicleTypeEnglishArr[index] {
                    transPortMode = vehicleTypePortuguseArr[index]
                    break
                }else{
                    transPortMode = modeOfTransport
                }
            }
        }else{
            for index in 0..<vehicleTypePortuguseArr.count {
                if modeOfTransport == vehicleTypePortuguseArr[index] {
                    transPortMode = vehicleTypeEnglishArr[index]
                    break
                }else{
                    transPortMode = modeOfTransport
                }
            }
        }
        
        lblModeOfTransport.text = transPortMode
        
        if workTime == ""{
            
            lblTime.text = "Not Defined".localized()
        }
        else{
            
            lblTime.text = workTime
        }
        
        lblAvgRating.text = "\(avgRating)"
        lblName.text = name
        
        if imgStr == ""{
            
            imgUser.image = UIImage(named: "placeholderImg")
        }
        else{
            
            let urlStr = URL(string: imgStr)
            imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
        imgUser.layer.cornerRadius = imgUser.frame.width/2
        imgUser.clipsToBounds = true
        
        if self.locDict.count == 0{
            
            lblDistance.text = "0 \("KM".localized())"
        }
        else{
           
            let arr = locDict.object(forKey: "coordinates") as? NSArray ?? []
            
            if arr.count == 2{
                
                let longitude = arr.object(at: 0) as? Double ?? 0.0
                let latitude = arr.object(at: 1) as? Double ?? 0.0
                
                let selfCurrentLat = CommonClass.sharedInstance.locationLatCordinate
                let selfCurrentLong = CommonClass.sharedInstance.locationLongCordinate
                
                print(longitude)
                print(latitude)
                
                print(selfCurrentLat)
                print(selfCurrentLong)
                
                self.longitudeT = longitude
                self.latitudeT = latitude
                
                let distance = self.getDistanceFromCurrentToAll(currentLocationLat: selfCurrentLat, currentLocationLong: selfCurrentLong, latitude: latitude, longitude: longitude)
                
                lblDistance.text = distance
                
                
                
            }
            else{
                
                lblDistance.text = "0 \("KM".localized())"
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
        
        return "\(distanceInKm) \("KM".localized())"
        
    }
    
    
    func updateHeaderElement(){
        
        let avgRating = dictRatingResponse.object(forKey: "AvgRating") as? Double ?? 0.0
        let name = dictRatingResponse.object(forKey: "name") as? String ?? ""
        
       // let totalRating = dictRatingResponse.object(forKey: "TotalRating") as? Int ?? 0
        
        let imgStr = dictRatingResponse.object(forKey: "profilePic") as? String ?? ""
        
        lblName.text = name
        lblAvgRating.text = "\(avgRating)"
       
    }
}


extension NewProviderDetailViewController{
    
    func apiCallForGetUserDetail(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":userID]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetAllRating as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.dictRatingResponse = receivedData
                        
                        self.updateHeaderElement()
                        
                        
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
}
