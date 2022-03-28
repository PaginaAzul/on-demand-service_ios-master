//
//  DeliveryPersonNewVC.swift
//  Joker
//
//  Created by Callsoft on 02/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class DeliveryPersonNewVC: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    @IBOutlet weak var viewPlaceholder: UIView!
    
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    var newDataArrDeliveryPerson = NSArray()
    
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
        viewPlaceholder.isHidden = true
        
        initialSetup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.apiCallForGetNewRecordOfDeliveryPerson), name: NSNotification.Name(rawValue: "RefreshNewOrderScreenForDeliveryCaptain"), object: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.apiCallForGetNewRecordOfDeliveryPerson()
    }

}


extension DeliveryPersonNewVC{
   
    func initialSetup(){
        tableview.tableFooterView = UIView()
    }
    
    
    func checkValdation(offerAmount:String,DeliveryTime:String,msg:String,OrderId:String){
        
        print(offerAmount)
        print(DeliveryTime)
        print(msg)
        
        var mess = ""
        
        if offerAmount == ""{
            
            mess = "Please enter offer amount"
        }
//        else if DeliveryTime == ""{
//
//            mess = "Please enter estimated delivery time"
//        }
        else{
            
            mess = ""
        }
        
        if mess == ""{
            
            self.apiCallToCreateOffer(offerAmount: offerAmount, deliveryTime: DeliveryTime, msg: msg, orderId: OrderId)
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
        
    }
    
    
}

extension DeliveryPersonNewVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newDataArrDeliveryPerson.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableview.register(UINib(nibName: "DeliveryNewEnhancementTableViewCell", bundle: nil), forCellReuseIdentifier: "DeliveryNewEnhancementTableViewCell")
        let cell = tableview.dequeueReusableCell(withIdentifier: "DeliveryNewEnhancementTableViewCell", for: indexPath) as! DeliveryNewEnhancementTableViewCell
        
        let dict = newDataArrDeliveryPerson.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let orderId = dict.object(forKey: "orderNumber") as? String ?? ""
        
        cell.lblOrderId.attributedText = CommonClass.sharedInstance.setOrderIDText("Order ID","\(orderId)")
        
        let createdDate = dict.object(forKey: "createdAt") as? String ?? ""
        
        cell.lblDate.text = self.fetchData(dateToConvert: createdDate)
        
        cell.lblAvgRating.text = "\(dict.object(forKey: "AvgRating") as? Double ?? 0.0)"
        
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        
        if totalRating == 0{
        
            cell.btnViewAllRating.setTitle("(0 "+"Rating".localized()+")", for: .normal)
        }
        else{
        
            cell.btnViewAllRating.setTitle("(\(totalRating) \("Rating view all".localized()))", for: .normal)
        }
        
        cell.btnViewAllRating.tag = indexPath.row
        cell.btnViewAllRating.addTarget(self, action: #selector(DeliveryPersonNewVC.tapBtnViewRating(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.btnMakeAnOffer.tag = indexPath.row
        cell.btnMakeAnOffer.addTarget(self, action: #selector(self.tapBtnMakeOffer(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.lblUserName.text = "\(dict.object(forKey: "name") as? String ?? "")"
        
        let imgStr = dict.object(forKey: "profilePic") as? String ?? ""
        
        if imgStr == ""{
        
            cell.imgUser.image = UIImage(named: "placeholderImg")
        }
        else{
        
            let urlStr = URL(string: imgStr)
            cell.imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
        let meToPickupDistance = "\(dict.object(forKey: "currentToPicupLocation") as? String ?? "")KM"
        let pickupToDropLocation = "\(dict.object(forKey: "pickupToDropLocation") as? String ?? "")KM"
        
        cell.lblMyLocationToPickup.text = meToPickupDistance
        cell.lblPickupToDropoff.text = pickupToDropLocation
        
        let dropLocation = dict.object(forKey: "dropOffLocation") as? String ?? ""
        let pickupLocation = dict.object(forKey: "pickupLocation") as? String ?? ""
        
        let desc = dict.object(forKey: "orderDetails") as? String ?? ""
        
        let time = dict.object(forKey: "seletTime") as? String ?? ""
        
        cell.lblAddress.attributedText = CommonClass.sharedInstance.attributedStringToDeliveryNewEnhancement(title1: "Pickup Location", subTitle1: "\(pickupLocation)\n", delemit: " - ", titleColor1: #colorLiteral(red: 0.7970424294, green: 0.5491735935, blue: 0.9914678931, alpha: 1), SubtitleColor1: UIColor.black, title2: "Dropoff Location", subTitle2: "\(dropLocation)\n", titleColor2: #colorLiteral(red: 0.7970424294, green: 0.5491735935, blue: 0.9914678931, alpha: 1), SubtitleColor2: UIColor.black, title3: "Order Details", subTitle3: "Require \(time)\n", titleColor3: #colorLiteral(red: 0.7970424294, green: 0.5491735935, blue: 0.9914678931, alpha: 1), SubtitleColor3: UIColor.black, title4: "Message", subTitle4: "\(desc)", titleColor4: #colorLiteral(red: 0.7970424294, green: 0.5491735935, blue: 0.9914678931, alpha: 1), SubtitleColor4: UIColor.black)
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    
    @objc func tapBtnViewRating(sender:UIButton){
        
        let dict = newDataArrDeliveryPerson.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        
        let id = dict.object(forKey: "userId") as? String ?? ""
        
        if totalRating != 0{
            
            let vc = ScreenManager.getUserDetailVC()
            
            vc.userID = id
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
     
    }
    
    @objc func tapBtnMakeOffer(sender:UIButton){
        
        let dict = self.newDataArrDeliveryPerson.object(at: sender.tag) as? NSDictionary ?? [:]

        self.checkOrderIsAvailableOrNot(passDict: dict)
        
//        let vc = ScreenManager.getDeliveryDetailOnMapVC()
//
//        vc.dataDict = dict
//
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func fetchData(dateToConvert:String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let pendingDate = dateFormatter.date(from: dateToConvert)!
        let sendTime = self.dateFormatterForTime.string(from: pendingDate)
        let sendDate = self.dateFormatterForDate.string(from: pendingDate)
        
        return "\(sendDate) \(sendTime)"
    }
    
}



extension DeliveryPersonNewVC{
    
    @objc func apiCallForGetNewRecordOfDeliveryPerson(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","lat":"\(CommonClass.sharedInstance.locationLatCordinate)","long":"\(CommonClass.sharedInstance.locationLongCordinate)"]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetNewOrderOfDeliveryPerson as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.newDataArrDeliveryPerson = receivedData.object(forKey: "Data1") as? NSArray ?? []
                        
                        if self.newDataArrDeliveryPerson.count == 0{
                            
                            self.tableview.isHidden = true
                            self.viewPlaceholder.isHidden = false
                        }
                        else{
                            
                            self.tableview.isHidden = false
                            self.viewPlaceholder.isHidden = true
                            self.tableview.reloadData()
                            
                            let topIndex = IndexPath(row: 0, section: 0)
                            self.tableview.scrollToRow(at: topIndex, at: .top, animated: true)
                        }
                        
                    }
                    else{
                        
                        self.tableview.isHidden = true
                        self.viewPlaceholder.isHidden = false
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToHome()
                        }
                        else{
                            
                           // CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                        }
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
    
    
    
    
    func apiCallToCreateOffer(offerAmount:String,deliveryTime:String,msg:String,orderId:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["orderId":orderId,"userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","minimumOffer":offerAmount,"message":msg,"apprxTime":deliveryTime]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForMakeOfferByDeliveryPerson as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        
                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdatePendingListDelivery"), object: nil)
                        
                        
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
                        
                        self.apiCallForGetNewRecordOfDeliveryPerson()
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToHome()
                        }
                        else{
                            
                           // CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                        }
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
    
    
    
    func checkOrderIsAvailableOrNot(passDict:NSDictionary){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let orderId = passDict.object(forKey: "_id") as? String ?? ""
            
            let param = ["orderId":orderId,"userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForCheckOrderAcceptedOrNot as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                print(receivedData)
                
                IJProgressView.shared.hideProgressView()
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let vc = ScreenManager.getDeliveryDetailOnMapVC()
                        
                        vc.dataDict = passDict
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToHome()
                        }
                        else{
                            
                            CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                            
                            self.apiCallForGetNewRecordOfDeliveryPerson()
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




//let index = IndexPath(row: 0, section: 0)
//let cell: AddFriendC1Cell = self.myTableView.cellForRow(at: index) as! AddFriendC1Cell
//self.alias = cell.aliasTextField.text!
//self.primaryPhone = cell.primaryPhoneTextField.text!
//self.secondaryPhone = cell.seondaryPhoneTextField.text!
//self.email = cell.emailAddressTextField.text!
