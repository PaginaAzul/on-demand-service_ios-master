//
//  ViewAllOffersPopupVC.swift
//  Joker
//
//  Created by retina on 04/09/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class ViewAllOffersPopupVC: UIViewController {
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var lblAvgRating: UILabel!
    
    @IBOutlet weak var btnViewAllRating: UIButton!
    
    @IBOutlet weak var lblDeliveryChargeOffer: UILabel!
    
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblDeliveryToPickupLocation: UILabel!
    
    @IBOutlet weak var lblPickupToDropLocation: UILabel!
    
    @IBOutlet weak var btnViewAllOffer: UIButton!
    
    
    @IBOutlet weak var deliveryChargeHeadingLbl: UILabel!
    
    @IBOutlet weak var deliveryMsgHeadingLbl: UILabel!
    
    @IBOutlet weak var deliveryTimeHeadingLbl: UILabel!
    
    @IBOutlet weak var viewTrackingDelivery: UIView!
    
    @IBOutlet weak var viewTrackingProfessional: UIView!
    
    @IBOutlet weak var lblDistanceBetweenProfessionalLocation: UILabel!
    
    @IBOutlet weak var lblModeOfTransport: UILabel!
    
    @IBOutlet weak var lblOfferNav: UILabel!
    
    @IBOutlet weak var lblChargeOfferHeading: UILabel!
    
    @IBOutlet weak var lblDeliveryMsgHeading: UILabel!
    
    @IBOutlet weak var lblDeliveryTimeHeading: UILabel!
    
    @IBOutlet weak var lblModeofTransport: UILabel!
    
    @IBOutlet weak var btnReject: UIButton!
    
    @IBOutlet weak var btnAccept: UIButton!
    
    @IBOutlet weak var lblOffersAreComing: UILabel!
    
    @IBOutlet weak var btnCancelOrder: UIButton!
    
    
    let connection = webservices()
    var viewAllOfferArr = NSArray()
    var orderId = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var category = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.value(forKey: "SepratorType") as? String ?? "" == "RequestingDelivery"{
            
            viewTrackingDelivery.isHidden = false
            viewTrackingProfessional.isHidden = true
            
        }
        else{
            
            viewTrackingDelivery.isHidden = true
            viewTrackingProfessional.isHidden = false
            
            deliveryChargeHeadingLbl.text = "Charge Offer"
            deliveryMsgHeadingLbl.text = "Message"
            deliveryTimeHeadingLbl.text = "Time"
            
        }
        
        if UserDefaults.standard.value(forKey: "SepratorType") as? String ?? "" == "RequestingDelivery"{
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.apiCallForViewAllOffer), name: NSNotification.Name(rawValue: "NotificationForUpdatePendingListNormalUserByDelivery"), object: nil)
        }
        else{
            
            //register this notification when we are getting professional offer.
            NotificationCenter.default.addObserver(self, selector: #selector(self.apiCallForViewAllOffer), name: NSNotification.Name(rawValue: "NotificationForUpdatePendingListNormalUserByProfessionalWorker"), object: nil)
        }
        
        
        initialSetup()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        localization()
        
        self.apiCallForViewAllOffer()
    }
    
    func localization(){
        
        lblOfferNav.text = "Offers".localized()
        lblChargeOfferHeading.text = "Delivery Charge Offer".localized()
        lblDeliveryTimeHeading.text = "Order Time".localized()
        lblDeliveryMsgHeading.text = "Message".localized()
        lblModeofTransport.text = "Mode of Transport".localized()
        lblOffersAreComing.text = "Offers are coming".localized()
        btnAccept.setTitle("Accept".localized(), for: .normal)
        btnReject.setTitle("Reject".localized(), for: .normal)
        
    }
    
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func tap_cancelOrderbtn(_ sender: Any) {
        
        let vc = ScreenManager.getDeleteOfferPopupVC()
        vc.orderID = self.orderId
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tap_rejectOrderBtn(_ sender: Any) {
        
        let alertController = UIAlertController(title: "", message: "Are you sure? You want to reject this offer.".localized(), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let dict = self.viewAllOfferArr.object(at: 0) as? NSDictionary ?? [:]
            
            let offerId = dict.object(forKey: "_id") as? String ?? ""
            
            self.apiCallForRejectOffer(offerID: offerId)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func tap_acceptOfferBtn(_ sender: Any) {
        
        let alertController = UIAlertController(title: "", message: "Are you sure? You want to accept this offer.".localized(), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let dict = self.viewAllOfferArr.object(at: 0) as? NSDictionary ?? [:]
            
            let offerId = dict.object(forKey: "_id") as? String ?? ""
            
            self.apiCallForAcceptOffer(offerID: offerId)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func tap_allOfferBtn(_ sender: Any) {
        
        let dict = viewAllOfferArr.object(at: 0) as? NSDictionary ?? [:]
        
       // let orderId = dict.object(forKey: "_id") as? String ?? ""
        let createdUserId = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        
        if UserDefaults.standard.value(forKey: "SepratorType") as? String ?? "" == "RequestingDelivery"{
            
            let vc = ScreenManager.getViewAllOffersVC()
            
            vc.orderID = self.orderId
            vc.deliveryUserId = createdUserId
            
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            
            let vc = ScreenManager.getProffessionalViewAllOffersVC()
            
            vc.orderId = self.orderId
            vc.category = self.category
            vc.userIdOfSelf = createdUserId
            
            print("self.category",self.category,vc.category)
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
     
    }
    
    @IBAction func tap_viewAllRating(_ sender: Any) {
        
        let dict = viewAllOfferArr.object(at: 0) as? NSDictionary ?? [:]
        
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        let id = dict.object(forKey: "makeOfferById") as? String ?? ""
        
        if totalRating != 0{
            
            let vc = ScreenManager.getUserDetailVC()
            vc.userID = id
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    
}


extension ViewAllOffersPopupVC{
    
    func initialSetup(){
        btnCancelOrder.setTitle("Cancel Order".localized(), for: .normal)
        btnViewAllOffer.setTitle("\(viewAllOfferArr.count) \("Offer".localized())", for: .normal)
        
        let dict = viewAllOfferArr.object(at: 0) as? NSDictionary ?? [:]
        
        let currency = dict.object(forKey: "currency") as? String ?? ""
        
        lblDeliveryChargeOffer.text = "\(dict.object(forKey: "minimumOffer") as? String ?? "") \(currency) \("Only".localized())"
        
        lblMessage.text = dict.object(forKey: "message") as? String ?? ""
        lblTime.text = "\(dict.object(forKey: "apprxTime") as? String ?? "")"
        
        if lblMessage.text == ""{
            
            lblMessage.text = "Not Define".localized()
        }
        
        if lblTime.text == ""{
            
           lblTime.text = "Not Define".localized()
        }
         
        lblUsername.text = dict.object(forKey: "offerMakeByName") as? String ?? ""
        
        if UserDefaults.standard.value(forKey: "SepratorType") as? String ?? "" == "RequestingDelivery"{
            
            let deliveryPersonToPickupDistance = dict.object(forKey: "currentToPicupLocation") as? String ?? ""
            
            let pickupToDropDistance = dict.object(forKey: "pickupToDropLocation") as? String ?? ""
            
            lblDeliveryToPickupLocation.text = "\(deliveryPersonToPickupDistance)\("KM".localized())"
            lblPickupToDropLocation.text = "\(pickupToDropDistance)\("KM".localized())"
        }
        else{
            
            let deliveryPersonToPickupDistance = dict.object(forKey: "currentToPicupLocation") as? String ?? ""
            
            lblDistanceBetweenProfessionalLocation.text = "\(deliveryPersonToPickupDistance)\("KM".localized())"
        }
        
        
        let imgStr = dict.object(forKey: "offerAcceptedByProfilePic") as? String ?? ""
        
        if imgStr == ""{
            
            imgUser.image = UIImage(named: "placeholderImg")
        }
        else{
            
            let urlStr = URL(string: imgStr)
           
            imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
        let avgRating = dict.object(forKey: "AvgRating") as? Double ?? 0.0
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        
        lblAvgRating.text = "\(avgRating)"
        
        if totalRating == 0{
            
            btnViewAllRating.setTitle("(0 "+"Rating".localized()+")", for: .normal)
        }
        else{
            
            btnViewAllRating.setTitle("(\(totalRating) \("Rating view all".localized()))", for: .normal)
        }
        
        let modeOfTransfer = dict.object(forKey: "transportMode") as? String ?? ""
        
        lblModeOfTransport.text = modeOfTransfer.localized()
        
    }
}


//MARK:- Webservices
//MARK:-
extension ViewAllOffersPopupVC{
    
    func apiCallForAcceptOffer(offerID:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","orderId":self.orderId,"offerId":offerID,"langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForAcceptOfferOfDeliveryPerson as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        if UserDefaults.standard.value(forKey: "SepratorType") as? String ?? "" == "RequestingDelivery"{
                            
                            UserDefaults.standard.set(true, forKey: "MyOrderSecondIndexSelected")
                            
                            
                           //  let vc = ScreenManager.getPopupVC()
                            //
                            //        vc.controllerName = "Accept Offer"
                            //
                            //        self.present(vc, animated: true, completion: nil)
                            
                            let vc = ScreenManager.getMyOrderNoralUserScrollerVC()
                            let navController = UINavigationController(rootViewController: vc)
                            navController.navigationBar.isHidden = true
                            self.appDelegate.window?.rootViewController = navController
                            self.appDelegate.window?.makeKeyAndVisible()
                            
                        }
                        else{
                            
                             UserDefaults.standard.set(true, forKey: "MyOrderSecondIndexSelectedProfessionalTab")
                            
                            let vc = ScreenManager.getNormalUserWithProfessionalWorkerScrollerVC()
                            let navController = UINavigationController(rootViewController: vc)
                            navController.navigationBar.isHidden = true
                            self.appDelegate.window?.rootViewController = navController
                            self.appDelegate.window?.makeKeyAndVisible()
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
    
    
    func apiCallForRejectOffer(offerID:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","offerId":offerID,"langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForRejectOfferByNormal as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        if UserDefaults.standard.value(forKey: "SepratorType") as? String ?? "" == "RequestingDelivery"{
                            
                            let vc = ScreenManager.getMyOrderNoralUserScrollerVC()
                            let navController = UINavigationController(rootViewController: vc)
                            navController.navigationBar.isHidden = true
                            self.appDelegate.window?.rootViewController = navController
                            self.appDelegate.window?.makeKeyAndVisible()
                        }
                        else{
                            
                            let vc = ScreenManager.getNormalUserWithProfessionalWorkerScrollerVC()
                            let navController = UINavigationController(rootViewController: vc)
                            navController.navigationBar.isHidden = true
                            self.appDelegate.window?.rootViewController = navController
                            self.appDelegate.window?.makeKeyAndVisible()
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
}




extension ViewAllOffersPopupVC{
    
    @objc func apiCallForViewAllOffer(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","lat":"\(CommonClass.sharedInstance.locationLatCordinate)","long":"\(CommonClass.sharedInstance.locationLongCordinate)","orderId":orderId,"langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]
            
            //   IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetViewAllOffered as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                // IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let viewAllOfferArr = receivedData.object(forKey: "Data1") as? NSArray ?? []
                        
                        self.viewAllOfferArr = viewAllOfferArr
                        
                        if viewAllOfferArr.count == 0{
                            
                            self.navigationController?.popViewController(animated: true)
                        }
                        else{
                            
                            self.initialSetup()
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
}
