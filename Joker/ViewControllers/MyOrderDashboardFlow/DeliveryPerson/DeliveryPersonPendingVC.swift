//
//  DeliveryPersonPendingVC.swift
//  Joker
//
//  Created by Callsoft on 02/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class DeliveryPersonPendingVC: UIViewController {

    @IBOutlet weak var lblPlaceholder: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var viewPlaceholder: UIView!
    
    
    var pendingRecordArrDeliveryPerson = NSArray()
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
     //   NotificationCenter.default.addObserver(self, selector: #selector(DeliveryPersonPendingVC.apiCallForGetPendingRecordOfDeliveryPerson), name: NSNotification.Name(rawValue: "NotificationForUpdatePendingListDelivery"), object: nil)
        
    //    NotificationCenter.default.addObserver(self, selector: #selector(DeliveryPersonPendingVC.apiCallForGetPendingRecordOfDeliveryPerson), name: NSNotification.Name(rawValue: "NotificationForUpdatePendingAndActiveOrderOfDeliveryPerson"), object: nil)
        
        self.lblPlaceholder.text = "Delivery person is busy right now.\n\nAs, He is working on an\nActive order"
        
        self.viewPlaceholder.isHidden = false
        initialSetup()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
      //  self.apiCallForGetPendingRecordOfDeliveryPerson()
    }
    
}


extension DeliveryPersonPendingVC{
    
    func initialSetup(){
        tableview.tableFooterView = UIView()
    }
}



extension DeliveryPersonPendingVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pendingRecordArrDeliveryPerson.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableview.register(UINib(nibName: "MockUpPending14TableViewCell", bundle: nil), forCellReuseIdentifier: "MockUpPending14TableViewCell")
        let cell = tableview.dequeueReusableCell(withIdentifier: "MockUpPending14TableViewCell", for: indexPath) as! MockUpPending14TableViewCell
      //  cell.lblDescription.text = "Item Name 1 - 15.00 \nItem Name 2 - 20.00"
        
        cell.btnReportOrder.tag = indexPath.row
        cell.btnReportOrder.addTarget(self, action: #selector(DeliveryPersonPendingVC.tapReportOrderBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.btnReportCancelOrder.tag = indexPath.row
        cell.btnReportCancelOrder.addTarget(self, action: #selector(DeliveryPersonPendingVC.tapReportCancelOrder(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.btnViewRating.tag = indexPath.row
        cell.btnViewRating.addTarget(self, action: #selector(DeliveryPersonPendingVC.tapBtnViewRating(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.btnContactAdmin.tag = indexPath.row
        cell.btnContactAdmin.addTarget(self, action: #selector(self.tapContactAdminBtn(sender:)), for: UIControlEvents.touchUpInside)
        
      //  cell.lblOrderId.attributedText = CommonClass.sharedInstance.setOrderIDText("Order ID","2345678")
        
        
        let dict = pendingRecordArrDeliveryPerson.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let orderNumber = dict.object(forKey: "orderNumber") as? String ?? ""
        cell.lblOrderId.attributedText = CommonClass.sharedInstance.setOrderIDText("Order ID","\(orderNumber)")
        
        let myToPickupLocation = dict.object(forKey: "currentToPicupLocation") as? String ?? ""
        let pickupToDropLocation = dict.object(forKey: "pickupToDropLocation") as? String ?? ""
        
        cell.lblMeToPickup.text = "\(myToPickupLocation)KM"
        cell.lblPickupToDrop.text = "\(pickupToDropLocation)KM"
        
        let dropLocation = dict.object(forKey: "dropOffLocation") as? String ?? ""
        let pickupLocation = dict.object(forKey: "pickupLocation") as? String ?? ""
        
       // cell.lblAddressDetail.text = "Address Detail : \( dict.object(forKey: "pickupLocation") as? String ?? "")"
        
         cell.lblAddressDetail.text = "Pickup Location - \(pickupLocation)\n\nDropOff Location - \(dropLocation)"
        
        cell.lblContactNumber.text = "\(dict.object(forKey: "countryCode") as? String ?? "")\(dict.object(forKey: "mobileNumber") as? String ?? "")"
        
        let time = dict.object(forKey: "seletTime") as? String ?? ""
        
        cell.lblDescription.text = "\(dict.object(forKey: "orderDetails") as? String ?? "") and Order Require \(time)"
        
      //  cell.lblDateAndTime.text = "Today \(dict.object(forKey: "seletTime") as? String ?? "")"
        
        cell.lblName.text = dict.object(forKey: "name") as? String ?? ""
        
        let imgStr = dict.object(forKey: "profilePic") as? String ?? ""
        if imgStr == ""{
            
            cell.imgProfile.image = UIImage(named: "placeholderImg")
        }
        else{
            
            let urlStr = URL(string: imgStr)
            cell.imgProfile.setImageWith(urlStr!, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
        cell.lblTotalAmount.text = "\(dict.object(forKey: "minimumOffer") as? String ?? "") SAR"
        
        cell.lblMessage.text = dict.object(forKey: "message") as? String ?? ""
        cell.lblWorkCompletionTime.text = dict.object(forKey: "apprxTime") as? String ?? ""
        
        cell.lblDeliveryOffer.text = "\(dict.object(forKey: "deliveryOffer") as? String ?? "") SAR"
        
        cell.lblTax.text = "\(dict.object(forKey: "tax") as? String ?? "") SAR"
        cell.lblTotal.text = "\(dict.object(forKey: "total") as? String ?? "") SAR"
        
        let createdDate = dict.object(forKey: "createdAt") as? String ?? ""
        
        cell.lblDateAndTime.text = self.fetchData(dateToConvert: createdDate)
        
        let avgRating = dict.object(forKey: "AvgRating") as? Double ?? 0.0
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        
        cell.lblAvgRating.text = "\(avgRating)"
        
        if totalRating == 0{
            
             cell.btnViewRating.setTitle("(0 "+"Rating".localized()+")", for: .normal)
        }
        else{
            
             cell.btnViewRating.setTitle("(\(totalRating) \("Rating view all".localized()))", for: .normal)
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
//    @objc func tapMakeNewOffer(sender:UIButton){
//
//        let vc = ScreenManager.getMakeNewOfferAlertVC()
//
//        vc.isComing = "DELIVERY"
//
//        self.present(vc, animated: true, completion: nil)
//    }
    
    
    @objc func tapReportOrderBtn(sender:UIButton){
    
        let dict = pendingRecordArrDeliveryPerson.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let orderId = dict.object(forKey: "_id") as? String ?? ""
        
        let vc = ScreenManager.getCancellationVC()
        
        vc.controllerPurpuse = "ReportCancel"
        vc.orderID = orderId
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapReportCancelOrder(sender:UIButton){
        
        let dict = pendingRecordArrDeliveryPerson.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let orderId = dict.object(forKey: "_id") as? String ?? ""
        
        let vc = ScreenManager.getCancellationVC()
        
        vc.controllerPurpuse = ""
        vc.orderID = orderId
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func tapBtnViewRating(sender:UIButton){
        
        let dict = pendingRecordArrDeliveryPerson.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        let id = dict.object(forKey: "makeOfferById") as? String ?? ""
        
        if totalRating != 0{
            
            let vc = ScreenManager.getUserDetailVC()
            
            vc.userID = id
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
      
    }
    
    
    @objc func tapContactAdminBtn(sender:UIButton){
        
        let vc = ScreenManager.getContactAdminVC()
        self.navigationController?.pushViewController(vc, animated: true)
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


extension DeliveryPersonPendingVC{
    
    @objc func apiCallForGetPendingRecordOfDeliveryPerson(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","lat":"\(CommonClass.sharedInstance.locationLatCordinate)","long":"\(CommonClass.sharedInstance.locationLongCordinate)"]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetPendingOrderDeliveryPerson as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.pendingRecordArrDeliveryPerson = receivedData.object(forKey: "Data1") as? NSArray ?? []
                        
                        if self.pendingRecordArrDeliveryPerson.count == 0{
                        
                            self.viewPlaceholder.isHidden = false
                            self.tableview.isHidden = true
                         }
                        else{
                        
                            self.viewPlaceholder.isHidden = true
                            self.tableview.isHidden = false
                            self.tableview.reloadData()
                            
                            let topIndex = IndexPath(row: 0, section: 0)
                            self.tableview.scrollToRow(at: topIndex, at: .top, animated: true)
                        }
                        
                    }
                    else{
                        
                        self.viewPlaceholder.isHidden = false
                        self.tableview.isHidden = true
                        
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
                    
                  //  CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
             CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
}
