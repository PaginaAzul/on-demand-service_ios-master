//
//  MyOrderNormalUserPendingVC.swift
//  Joker
//
//  Created by Callsoft on 02/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class MyOrderNormalUserPendingVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    let connection = webservices()
    
    var normalUserPendingArr = NSArray()
    
    var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(localTimeZoneAbbreviation)
        
        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        
      //  dateFormatterForTime.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation)
        
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
        initialSetup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.apiCallForGetPendingOrders), name: NSNotification.Name(rawValue: "NotificationForUpdatePendingListNormalUserByDelivery"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.lblPlaceholder.isHidden = true
        
        self.apiCallForGetPendingOrders()
    }

}


extension MyOrderNormalUserPendingVC{
    
    func initialSetup(){
        tableview.tableFooterView = UIView()
    }
}


extension MyOrderNormalUserPendingVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.normalUserPendingArr.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableview.register(UINib(nibName: "MyOrderDashBoardPendingTableViewCell", bundle: nil), forCellReuseIdentifier: "MyOrderDashBoardPendingTableViewCell")
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "MyOrderDashBoardPendingTableViewCell", for: indexPath) as! MyOrderDashBoardPendingTableViewCell
        
        cell.btnViewAllOffers.tag = indexPath.row
        cell.btnViewAllOffers.addTarget(self, action: #selector(MyOrderNormalUserPendingVC.tapViewAllOfferBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.btnDeleteOrder.tag = indexPath.row
        cell.btnDeleteOrder.addTarget(self, action: #selector(MyOrderNormalUserPendingVC.tapCancelOrderBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        let dict = self.normalUserPendingArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let orderId = dict.object(forKey: "orderNumber") as? String ?? ""
        
        cell.lblOrderID.attributedText = CommonClass.sharedInstance.setOrderIDText("Order ID","\(orderId)")
        
        let dropLocation = dict.object(forKey: "dropOffLocation") as? String ?? ""
        let pickupLocation = dict.object(forKey: "pickupLocation") as? String ?? ""
        
        cell.lblAddressDetail.text = "Pickup Location - \(pickupLocation)\n\nDropOff Location - \(dropLocation)"
        
        cell.lblMeToPickup.text = "\(dict.object(forKey: "currentToPicupLocation") as? String ?? "")KM"
        
        cell.lblPickupToDrop.text = "\(dict.object(forKey: "pickupToDropLocation") as? String ?? "")KM"
        
        let totalOffer = dict.object(forKey: "TotalOffer") as? Int ?? 0
        
        cell.btnViewAllOffers.setTitle("View All Offered (\(totalOffer))", for: .normal)
        
        let createdDate = dict.object(forKey: "createdAt") as? String ?? ""
        
        cell.lblDateAndTime.text = self.fetchData(dateToConvert: createdDate)
        
        let time = dict.object(forKey: "seletTime") as? String ?? ""
        
        let orderDetails = dict.object(forKey: "orderDetails") as? String ?? ""
        
        cell.lblAddressDetail.attributedText = CommonClass.sharedInstance.attributedStringToDeliveryNewEnhancement(title1: "Pickup Location", subTitle1: "\(pickupLocation)\n", delemit: " - ", titleColor1: #colorLiteral(red: 0.7970424294, green: 0.5491735935, blue: 0.9914678931, alpha: 1), SubtitleColor1: UIColor.black, title2: "Dropoff Location", subTitle2: "\(dropLocation)\n", titleColor2: #colorLiteral(red: 0.7970424294, green: 0.5491735935, blue: 0.9914678931, alpha: 1), SubtitleColor2: UIColor.black, title3: "Order Time", subTitle3: "Require \(time)\n", titleColor3: #colorLiteral(red: 0.7970424294, green: 0.5491735935, blue: 0.9914678931, alpha: 1), SubtitleColor3: UIColor.black, title4: "Order Details", subTitle4: "\(orderDetails)", titleColor4: #colorLiteral(red: 0.7970424294, green: 0.5491735935, blue: 0.9914678931, alpha: 1), SubtitleColor4: UIColor.black)
  
        return cell
 
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    @objc func tapViewAllOfferBtn(sender:UIButton){
        
       // let vc = ScreenManager.getViewAllOffersVC()
       // self.navigationController?.pushViewController(vc, animated: true)
        
        let dict = normalUserPendingArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let totalOffer = dict.object(forKey: "TotalOffer") as? Int ?? 0
        
        if totalOffer == 0{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "No Offer found for this request at this time.".localized(), controller: self)
        }
        else{
            
            let orderId = dict.object(forKey: "_id") as? String ?? ""
            let createdUserId = dict.object(forKey: "userId") as? String ?? ""
            
            let vc = ScreenManager.getViewAllOffersVC()
            
            vc.orderID = orderId
            vc.deliveryUserId = createdUserId
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    @objc func tapCancelOrderBtn(sender:UIButton){
        
        let dict = normalUserPendingArr.object(at: sender.tag) as? NSDictionary ?? [:]
        let orderId = dict.object(forKey: "_id") as? String ?? ""
        
//        let vc = ScreenManager.getCancellationVC()
//        vc.controllerPurpuse = ""
//        vc.orderID = orderId
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let vc = ScreenManager.getDeleteOfferPopupVC()
        vc.orderID = orderId
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    func fetchData(dateToConvert:String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
       // dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
     //   dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation)
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let pendingDate = dateFormatter.date(from: dateToConvert)!
        let sendTime = self.dateFormatterForTime.string(from: pendingDate)
        let sendDate = self.dateFormatterForDate.string(from: pendingDate)
        
        return "\(sendDate) \(sendTime)"
    }
    
    
    func dateFromISOString(string: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return dateFormatter.date(from: string)
    }
    
}



extension MyOrderNormalUserPendingVC{
    
    @objc func apiCallForGetPendingOrders(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","lat":"\(CommonClass.sharedInstance.locationLatCordinate)","long":"\(CommonClass.sharedInstance.locationLongCordinate)","serviceType":"DeliveryPersion"]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetNormalUserPendingOrder as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        if let dataDict = receivedData.object(forKey: "Data") as? NSDictionary{
                            
                            self.normalUserPendingArr = dataDict.object(forKey: "docs") as? NSArray ?? []
                            
                            
                            if self.normalUserPendingArr.count == 0{
                                
                                self.tableview.isHidden = true
                                self.lblPlaceholder.isHidden = false
                            }
                            else{
                                
                                self.tableview.isHidden = false
                                self.lblPlaceholder.isHidden = true
                                
                                self.tableview.reloadData()
                                
                                let topIndex = IndexPath(row: 0, section: 0)
                                self.tableview.scrollToRow(at: topIndex, at: .top, animated: true)
                                
                            }
                           
                        }
                    }
                    else{
                        
                        
                        self.tableview.isHidden = true
                        self.lblPlaceholder.isHidden = false
                        
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
}
