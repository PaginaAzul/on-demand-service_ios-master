//
//  ProffessionalViewAllOffersVC.swift
//  Joker
//
//  Created by abc on 01/02/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class ProffessionalViewAllOffersVC: UIViewController {
   
    @IBOutlet weak var tblViewAllOffers: UITableView!
    
    @IBOutlet weak var lblAllOffersNav: UILabel!
    
    
    var orderId = ""
    var category = ""
    var userIdOfSelf = ""
    
    var viewAllOfferArr = NSArray()
    
    let connection = webservices()
    
    var controllerName = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblAllOffersNav.text = "All Offers".localized()
        
        initialSetup()
        
        self.apiCallForViewAllOffer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.apiCallForViewAllOffer), name: NSNotification.Name(rawValue: "NotificationForUpdatePendingListNormalUserByProfessionalWorker"), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
         NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "NotificationForUpdatePendingListNormalUserByProfessionalWorker"), object: nil)
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension ProffessionalViewAllOffersVC{
   
    func initialSetup(){
        
        tblViewAllOffers.tableFooterView = UIView()
    }
}


extension ProffessionalViewAllOffersVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewAllOfferArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tblViewAllOffers.register(UINib(nibName: "ProffessionalViewAllOrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "ProffessionalViewAllOrdersTableViewCell")
        
        let cell = tblViewAllOffers.dequeueReusableCell(withIdentifier: "ProffessionalViewAllOrdersTableViewCell", for: indexPath) as! ProffessionalViewAllOrdersTableViewCell
        
        cell.btnAcceptOffer.tag = indexPath.row
        
        cell.btnAcceptOffer.addTarget(self, action: #selector(ProffessionalViewAllOffersVC.tap_acceptOfferBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.btnReject.tag = indexPath.row
        cell.btnReject.addTarget(self, action: #selector(ProffessionalViewAllOffersVC.tap_rejectOfferBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        
        cell.btnTotalRating.tag = indexPath.row
        cell.btnTotalRating.addTarget(self, action: #selector(self.tap_ratingBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        let dict = viewAllOfferArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        cell.lblUsername.text = dict.object(forKey: "offerAcceptedByName") as? String ?? ""
        
        let avgRating = dict.object(forKey: "AvgRating") as? Double ?? 0.0
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        
        cell.lblAvgRating.text = "\(avgRating)"
        
        if totalRating == 0{
            
             cell.btnTotalRating.setTitle("(0 "+"Rating".localized()+")", for: .normal)
        }
        else{
            
             cell.btnTotalRating.setTitle("(\(totalRating) "+"Rating View All".localized()+")", for: .normal)
        }
       
        let deliveryChargeOffer = dict.object(forKey: "minimumOffer") as? String ?? ""
        
        let currency = dict.object(forKey: "currency") as? String ?? ""
        
        cell.lblDeliveryChargesOffer.text = "\(deliveryChargeOffer) \(currency) "+"Only".localized()
        
        cell.lblDeliveryMsg.text = dict.object(forKey: "message") as? String ?? ""
        cell.lblDeliveryTime.text = dict.object(forKey: "apprxTime") as? String ?? ""
        
        if cell.lblDeliveryMsg.text == ""{
            
            cell.lblDeliveryMsg.text = "Not Defined".localized()
        }
        
        if cell.lblDeliveryTime.text == ""{
            
            cell.lblDeliveryTime.text = "Not Defined".localized()
        }
        
        let distance = dict.object(forKey: "currentToPicupLocation") as? String ?? ""
        
        cell.lblPickupToDropoffLocation.text = "\(distance)KM"
        
        let imgStr = dict.object(forKey: "offerAcceptedByProfilePic") as? String ?? ""
        if imgStr == ""{
            
            cell.imgProfile.image = UIImage(named: "placeholderImg")
        }
        else{
            
            let urlStr = URL(string: imgStr)
            cell.imgProfile.setImageWith(urlStr!, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
        let modeOfTransfer = dict.object(forKey: "transportMode") as? String ?? ""
        
        
        var vehicleTypeEnglishArr = ["Own Vehicle","Company Vehicle","No Vehicle"]
        
        var vehicleTypePortuguseArr = ["Carro próprio","Carro da empresa","Sem transporte"]
        
        var transPortMode = String()
        
        if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
            
            for index in 0..<vehicleTypeEnglishArr.count {
                
                if modeOfTransfer == vehicleTypeEnglishArr[index] {
                    transPortMode = vehicleTypePortuguseArr[index]
                    break
                }else{
                    transPortMode = modeOfTransfer
                }
            }
            
        }else{
            
            for index in 0..<vehicleTypePortuguseArr.count {
                if modeOfTransfer == vehicleTypePortuguseArr[index] {
                    transPortMode = vehicleTypeEnglishArr[index]
                    break
                }else{
                    transPortMode = modeOfTransfer
                }
            }
            
        }
        
        cell.lblModeOfTransport.text = transPortMode
        
        cell.btnViewProfile.tag = indexPath.row
        cell.btnViewProfile.addTarget(self, action: #selector(self.tap_viewProfileBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.lblChargeOfferHeading.text = "Charge Offer".localized()
        cell.lblTime.text = "Order Time".localized()
        cell.lblMessageHeading.text = "Message".localized()
        cell.lblModeOfTransportHeading.text = "Mode of Transport".localized()
        cell.btnViewProfile.setTitle("View Profile".localized(), for: .normal)
        cell.btnReject.setTitle("Reject".localized(), for: .normal)
        cell.btnAcceptOffer.setTitle("Accept".localized(), for: .normal)
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    @objc func tap_acceptOfferBtn(sender:UIButton){
        
//        let vc = ScreenManager.getPopupVC()
//
//        vc.controllerName = "Accept Offer"
//
//        self.present(vc, animated: true, completion: nil)
        
        let alertController = UIAlertController(title: "", message: "Are you sure? You want to accept this offer.".localized(), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let dict = self.viewAllOfferArr.object(at: sender.tag) as? NSDictionary ?? [:]
            
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
    
    
    @objc func tap_rejectOfferBtn(sender:UIButton){
        
        let alertController = UIAlertController(title: "", message: "Are you sure? You want to reject this offer.".localized(), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let dict = self.viewAllOfferArr.object(at: sender.tag) as? NSDictionary ?? [:]
            
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
    
    
    @objc func tap_ratingBtn(sender:UIButton){
        
        let dict = viewAllOfferArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        let id = dict.object(forKey: "makeOfferById") as? String ?? ""
        
        if totalRating != 0{
            
            let vc = ScreenManager.getUserDetailVC()
            vc.userID = id
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    @objc func tap_viewProfileBtn(sender:UIButton){
        
        let dict = viewAllOfferArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let distance = dict.object(forKey: "currentToPicupLocation") as? String ?? ""
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        
        let deliveryChargeOffer = dict.object(forKey: "minimumOffer") as? String ?? ""
        let msg = dict.object(forKey: "message") as? String ?? ""
        let approxTime = dict.object(forKey: "apprxTime") as? String ?? ""
        let modeOfTransfer = dict.object(forKey: "transportMode") as? String ?? ""
        
        let id = dict.object(forKey: "makeOfferById") as? String ?? ""
        
        let avgRating = dict.object(forKey: "AvgRating") as? Double ?? 0.0
        let name = dict.object(forKey: "offerAcceptedByName") as? String ?? ""
        let imgStr = dict.object(forKey: "offerAcceptedByProfilePic") as? String ?? ""
        
        let currency = dict.object(forKey: "currency") as? String ?? ""
        
        let locationDict = dict.object(forKey: "location") as? NSDictionary ?? [:]
        
       // let langCat = dict.object(forKey: "currency") as? String ?? ""
        
        let vc = ScreenManager.getNewProviderDetailViewController()
        vc.category = self.category
        vc.userID = id
        vc.msg = msg
        vc.workTime = approxTime
        vc.modeOfTransport = modeOfTransfer.localized()
        vc.chargeOffer = deliveryChargeOffer
        vc.totalRating = totalRating
        vc.distance = distance
        
        vc.avgRating = avgRating
        vc.name = name
        vc.imgStr = imgStr
        
        vc.locDict = locationDict
        
        vc.currency = currency
        print("Now  Category", self.category)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension ProffessionalViewAllOffersVC{
    
    @objc func apiCallForViewAllOffer(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","lat":"\(CommonClass.sharedInstance.locationLatCordinate)","long":"\(CommonClass.sharedInstance.locationLongCordinate)","orderId":orderId]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetViewAllOffered as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.viewAllOfferArr = receivedData.object(forKey: "Data1") as? NSArray ?? []
                        
                        self.tblViewAllOffers.reloadData()
                        
                        if self.viewAllOfferArr.count == 0{

                            if self.controllerName == "ViaPending"{
                                
                               self.navigationController?.popViewController(animated: true)
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
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    
    
    func apiCallForAcceptOffer(offerID:String){

        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","orderId":orderId,"offerId":offerID]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForAcceptOfferOfDeliveryPerson as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                
                        UserDefaults.standard.set(true, forKey: "MyOrderSecondIndexSelectedProfessionalTab")
                        
                        let vc = ScreenManager.getNormalUserWithProfessionalWorkerScrollerVC()
                        let navController = UINavigationController(rootViewController: vc)
                        navController.navigationBar.isHidden = true
                        self.appDelegate.window?.rootViewController = navController
                        self.appDelegate.window?.makeKeyAndVisible()
                        
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
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","offerId":offerID]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForRejectOfferByNormal as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                       self.apiCallForViewAllOffer()
                        
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


extension ProffessionalViewAllOffersVC:AcceptOfferRefreshDelegate{
    
    func changeAcceptOfferScreenStatus(status: String) {
        
        if status == "Yes"{
            
            self.apiCallForViewAllOffer()
        }
    }
}
