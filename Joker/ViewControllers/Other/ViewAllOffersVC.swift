//
//  ViewAllOffersVC.swift
//  Joker
//
//  Created by abc on 30/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class ViewAllOffersVC: UIViewController {
    
    @IBOutlet weak var tblViewAllOffers: UITableView!
    
    var orderID = ""
    var deliveryUserId = ""
    
    let connection = webservices()
    
    var viewAllOfferArr = NSArray()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("All offers Screen Name-- ViewAllOffersVC ")
        
        initialSetup()
      
        NotificationCenter.default.addObserver(self, selector: #selector(self.apiCallForViewAllOffer), name: NSNotification.Name(rawValue: "NotificationForUpdatePendingListNormalUserByDelivery"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.apiCallForViewAllOffer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
         NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "NotificationForUpdatePendingListNormalUserByDelivery"), object: nil)
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}



extension ViewAllOffersVC{
    
    func initialSetup(){
        
        tblViewAllOffers.tableFooterView = UIView()
    }
}


extension ViewAllOffersVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewAllOfferArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tblViewAllOffers.register(UINib(nibName: "ViewAllOfferTableViewCell", bundle: nil), forCellReuseIdentifier: "ViewAllOfferTableViewCell")
        
        let cell = tblViewAllOffers.dequeueReusableCell(withIdentifier: "ViewAllOfferTableViewCell", for: indexPath) as! ViewAllOfferTableViewCell
        
        cell.btnAcceptOffer.tag = indexPath.row
        
        cell.btnAcceptOffer.addTarget(self, action: #selector(ViewAllOffersVC.tap_acceptOfferBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.btnCancelOrder.tag = indexPath.row
        cell.btnCancelOrder.addTarget(self, action: #selector(self.tapRejectOfferBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.btnTotalRating.tag = indexPath.row
        
        cell.btnTotalRating.addTarget(self, action: #selector(ViewAllOffersVC.tap_viewRatingBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        let dict = viewAllOfferArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        cell.lblDeliveryOffer.text = "\(dict.object(forKey: "minimumOffer") as? String ?? "") SAR \("Only".localized())"
        
        cell.lblDeliveryMessage.text = dict.object(forKey: "message") as? String ?? ""
        cell.lblEstimatedDeliveryTime.text = "\(dict.object(forKey: "apprxTime") as? String ?? "")"
        
        if cell.lblDeliveryMessage.text == ""{
            
            cell.lblDeliveryMessage.text = "Not Define".localized()
        }
        
        if cell.lblEstimatedDeliveryTime.text == ""{
            
            cell.lblEstimatedDeliveryTime.text = "Not Define".localized()
        }
        
        cell.lblName.text = dict.object(forKey: "offerMakeByName") as? String ?? ""
        
        let deliveryPersonToPickupDistance = dict.object(forKey: "currentToPicupLocation") as? String ?? ""
        
        let pickupToDropDistance = dict.object(forKey: "pickupToDropLocation") as? String ?? ""
        
        cell.lblDeliveryPersonToPickupLocation.text = "\(deliveryPersonToPickupDistance)KM"
        cell.lblPickupLocationToDropLocation.text = "\(pickupToDropDistance)KM"
        
        let imgStr = dict.object(forKey: "offerAcceptedByProfilePic") as? String ?? ""
        
        if imgStr == ""{
            
            cell.imgProfile.image = UIImage(named: "placeholderImg")
        }
        else{
            
            let urlStr = URL(string: imgStr)
            cell.imgProfile.setImageWith(urlStr!, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
        let avgRating = dict.object(forKey: "AvgRating") as? Double ?? 0.0
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        
        cell.lblAvgRating.text = "\(avgRating)"
        
        if totalRating == 0{
            
            cell.btnTotalRating.setTitle("(0 "+"Rating".localized()+")", for: .normal)
        }
        else{
            
            cell.btnTotalRating.setTitle("(\(totalRating) \("Rating view all".localized()))", for: .normal)
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @objc func tap_acceptOfferBtn(sender:UIButton){
        
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
        
        
//        let vc = ScreenManager.getPopupVC()
//
//        vc.controllerName = "Accept Offer"
//
//        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func tapRejectOfferBtn(sender:UIButton){
        
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
    
    
    @objc func tap_viewRatingBtn(sender:UIButton){
        
        let dict = viewAllOfferArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        let id = dict.object(forKey: "makeOfferById") as? String ?? ""
        
        if totalRating != 0{
            
            let vc = ScreenManager.getUserDetailVC()
            vc.userID = id
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}



extension ViewAllOffersVC{
    
    @objc func apiCallForViewAllOffer(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","lat":"\(CommonClass.sharedInstance.locationLatCordinate)","long":"\(CommonClass.sharedInstance.locationLongCordinate)","orderId":orderID]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetViewAllOffered as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
//                        if let dataDict = receivedData.object(forKey: "Data") as? NSDictionary{
//
//                            self.viewAllOfferArr = dataDict.object(forKey: "docs") as? NSArray ?? []
//
//                            self.tblViewAllOffers.reloadData()
//                        }
                        
                        self.viewAllOfferArr = receivedData.object(forKey: "Data1") as? NSArray ?? []
                        
                        self.tblViewAllOffers.reloadData()
                        
//                        if self.viewAllOfferArr.count == 0{
//
//                            self.navigationController?.popViewController(animated: true)
//                        }
                        
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
            
            let param = ["userId":deliveryUserId,"orderId":orderID,"offerId":offerID]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForAcceptOfferOfDeliveryPerson as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
//                        let vc = ScreenManager.getPopupVC()
//
//                        vc.controllerName = "Accept Offer"
//                        vc.acceptOfferDelegate = self
//
//                        self.present(vc, animated: true, completion: nil)
                        
                        UserDefaults.standard.set(true, forKey: "MyOrderSecondIndexSelected")
                        
                        let vc = ScreenManager.getMyOrderNoralUserScrollerVC()
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
        
        //apiCallForRejectOfferByNormal
        
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


extension ViewAllOffersVC:AcceptOfferRefreshDelegate{
    
    func changeAcceptOfferScreenStatus(status: String) {
        
        if status == "Yes"{
            
            self.apiCallForViewAllOffer()
        }
    }
    
}
