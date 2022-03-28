//
//  MyOrderNormalUserActiveVC.swift
//  Joker
//
//  Created by Callsoft on 02/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class MyOrderNormalUserActiveVC: UIViewController {

    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    var normalUserActiveArr = NSArray()
    
    var dataPassingDict = NSDictionary()
    
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblPlaceholder.isHidden = true
        
        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
        initialSetup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.apiCallForGetActiveOrder), name: NSNotification.Name(rawValue: "NotificationForUpdateActiveOrderNormalUserDeliveryPersonDone"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.apiCallForGetActiveOrder()
    }

}


//MARK: - Extension User Defined Methods
extension MyOrderNormalUserActiveVC{
    //TODO: Initial Setup
    func initialSetup(){
        
        tableview.tableFooterView = UIView()
    }
}

//MARK: - Extension TableView Controller
extension MyOrderNormalUserActiveVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return normalUserActiveArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableview.register(UINib(nibName: "MyOrderDashBoardActiveTableViewCell", bundle: nil), forCellReuseIdentifier: "MyOrderDashBoardActiveTableViewCell")
        let cell = tableview.dequeueReusableCell(withIdentifier: "MyOrderDashBoardActiveTableViewCell", for: indexPath) as! MyOrderDashBoardActiveTableViewCell
        
        cell.btnGo.tag = indexPath.row
        cell.btnGo.addTarget(self, action: #selector(self.tap_goBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        let dict = normalUserActiveArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
//        let goStatus = dict.object(forKey: "goStatus") as? String ?? ""
//        if goStatus == "false"{
//
//            cell.btnGo.isHidden = true
//            cell.btnInvoiceCreated.isHidden = true
//            cell.btnArrived.isHidden = true
//            cell.btnDone.isHidden = true
//        }
//        else{
//
//            let invoiceStatus = dict.object(forKey: "invoiceStatus") as? String ?? ""
//            if invoiceStatus == "false"{
//
//                cell.btnGo.isHidden = false
//                cell.btnInvoiceCreated.isHidden = true
//                cell.btnArrived.isHidden = true
//                cell.btnDone.isHidden = true
//
//                cell.btnGo.setTitle("GO", for: .normal)
//                cell.btnGo.setTitleColor(UIColor.green, for: .normal)
//            }
//            else{
//
//                cell.btnGo.setTitle("Review Invoice", for: .normal)
//                cell.btnGo.setTitleColor(UIColor.purple, for: .normal)
//
//                cell.btnGo.isHidden = false
//                cell.btnInvoiceCreated.isHidden = false
//
//                let arrivedStatus = dict.object(forKey: "arrivedStatus") as? String ?? ""
//                if arrivedStatus == "false"{
//
//                    cell.btnArrived.isHidden = true
//                    cell.btnDone.isHidden = true
//                }
//                else{
//
//                    cell.btnArrived.isHidden = false
//
//                    let doneStatus = dict.object(forKey: "workDoneStatus") as? String ?? ""
//                    if doneStatus == "false"{
//
//                        cell.btnDone.isHidden = true
//                    }
//                    else{
//
//                        cell.btnDone.isHidden = false
//                    }
//
//                }
//
//            }
//
//        }
        
        
        cell.lblAvgRating.text = "\(dict.object(forKey: "AvgRating") as? Double ?? 0.0)"
        
        let orderNo = dict.object(forKey: "orderNumber") as? String ?? ""
        cell.lblOrderID.attributedText = CommonClass.sharedInstance.setOrderIDText("Order ID","\(orderNo)")
        
        cell.lblPickupName.text = dict.object(forKey: "orderDetails") as? String ?? ""
        
        cell.lblUsername.text = dict.object(forKey: "offerAcceptedOfName") as? String ?? ""
        
        let imgStr = dict.object(forKey: "offerAcceptedOfProfilePic") as? String ?? ""
        if imgStr == ""{
            
            cell.imgProfile.image = UIImage(named: "placeholderImg")
        }
        else{
            
            let urlStr = URL(string: imgStr)
            cell.imgProfile.setImageWith(urlStr!, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
        let createdDate = dict.object(forKey: "createdAt") as? String ?? ""
        
        cell.lblDateAndTime.text = self.fetchData(dateToConvert: createdDate)
        
        let invoiceDate = dict.object(forKey: "invoiceCreatedAt") as? String ?? ""
        
        if invoiceDate != ""{
            
            cell.lblInvoiceDetail.text = self.fetchData(dateToConvert: invoiceDate)
        }
        else{
            
            cell.lblInvoiceDetail.text = "No date found"
        }
        
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        
        if totalRating == 0{
            
            cell.btnViewRating.setTitle("(0 "+"Rating".localized()+")", for: .normal)
        }
        else{
            
            cell.btnViewRating.setTitle("\(totalRating) \("Rating view all".localized())", for: .normal)
        }
       
        
        let currentToPickupLocation = dict.object(forKey: "currentToPicupLocation") as? String ?? ""
        let pickupToDropLocation = dict.object(forKey: "pickupToDropLocation") as? String ?? ""
        
        cell.lblStartToPickupLocation.text = "\(currentToPickupLocation)KM"
        cell.lblPickupToDropOffLocation.text = "\(pickupToDropLocation)KM"
        cell.lblDropOffToDeliveredLocation.text = "0.0KM"
        
        let deliveryChargeOffer = dict.object(forKey: "minimumOffer") as? String ?? ""
        cell.lblDeliveryChargesOffer.text = "\(deliveryChargeOffer) SAR"
        
        cell.lblDeliveryMessage.text = dict.object(forKey: "message") as? String ?? ""
        cell.lblDeliveryTime.text = dict.object(forKey: "apprxTime") as? String ?? ""
        
        if cell.lblDeliveryMessage.text == ""{
            
            cell.lblDeliveryMessage.text = "Not Defined"
        }
        
        if cell.lblDeliveryTime.text == ""{
            
            cell.lblDeliveryTime.text = "Not Defined"
        }
        
        let deliveryOffer = dict.object(forKey: "deliveryOffer") as? String ?? ""
        cell.lblDeliveryOfferAmount.text = "\(deliveryOffer) SAR"
        
        cell.lblTax.text = "\(dict.object(forKey: "tax") as? String ?? "") SAR"
        cell.lblTotal.text = "\(dict.object(forKey: "total") as? String ?? "") SAR"
        
        cell.btnViewRating.tag = indexPath.row
        cell.btnViewRating.addTarget(self
            , action: #selector(MyOrderNormalUserActiveVC.tapBtnViewRating(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.btnReportOrder.tag = indexPath.row
        cell.btnReportOrder.addTarget(self, action: #selector(self.tap_messageAndTrackOrder(sender:)), for: UIControlEvents.touchUpInside)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    
    @objc func tapContactAdminBtn(sender:UIButton){
        
        let vc = ScreenManager.getContactAdminVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func tap_goBtn(sender:UIButton){
        
        let dict = normalUserActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let invoiceStatus = dict.object(forKey: "invoiceStatus") as? String ?? ""
        if invoiceStatus == "false"{
            
            
        }
        else{
            
            //review invoice url get here
            
            let invoicePdfUrl = dict.object(forKey: "invoicePdf") as? String ?? ""
            
            guard let url = URL(string: "\(invoicePdfUrl)") else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }
        
    }
    
    
    @objc func tapIssueWithMyOrderBtn(sender:UIButton){
        
//        let vc = ScreenManager.getIssueWithMyOrderVC()
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let dict = normalUserActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
        let id = dict.object(forKey: "_id") as? String ?? ""
        
        let vc = ScreenManager.getCancellationVC()
        vc.controllerPurpuse = "ReportCancel"
        
        vc.reportType = "NormalUser"
        
        vc.orderID = id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func tap_messageAndTrackOrder(sender:UIButton){
        
        self.dataPassingDict = normalUserActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let popupStatus = self.dataPassingDict.object(forKey: "popupStatus") as? String ?? ""
        
        if popupStatus == "Show"{
            
            let vc = ScreenManager.getOrderInstructionPopupVC()
            
            vc.controllerPurpuse = "MsgAndTrack"
            vc.delegate = self
            
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
        else{
            
            let dict = normalUserActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
            
            let receiverId = dict.object(forKey: "offerAcceptedOfId") as? String ?? ""
            let roomId = dict.object(forKey: "roomId") as? String ?? ""
            
            let vc = ScreenManager.getMessagesVC()
            
            vc.isComing = "NormalDelivery"
            
            vc.receiverID = receiverId
            vc.roomID = roomId
            
            vc.userOrderInfo = self.dataPassingDict
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
      
    }
    
    
    @objc func tapCancelOrderBtn(sender:UIButton){
        
        let dict = normalUserActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
        let id = dict.object(forKey: "_id") as? String ?? ""
        
        let vc = ScreenManager.getCancellationVC()
        vc.controllerPurpuse = ""
        vc.orderID = id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @objc func tapMsgBtn(sender:UIButton){
        
        let dict = normalUserActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let receiverId = dict.object(forKey: "offerAcceptedOfId") as? String ?? ""
        let roomId = dict.object(forKey: "roomId") as? String ?? ""
        
        let vc = ScreenManager.getMessagesVC()
        
        vc.isComing = "NormalDelivery"
        
        vc.receiverID = receiverId
        vc.roomID = roomId
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapTrackBtn(sender:UIButton){
        
        let vc = ScreenManager.getActiveOrderTrackingVC()
        
        let dict = normalUserActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        vc.dict = dict
        
        vc.isComing = "NormalDelivery"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapBtnViewRating(sender:UIButton){
        
        let dict = normalUserActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let totalCount = dict.object(forKey: "TotalRating") as? Int ?? 0
        
        let id = dict.object(forKey: "offerAcceptedOfId") as? String ?? ""
        
        if totalCount != 0{
            
            let vc = ScreenManager.getUserDetailVC()
            vc.userID = id
            self.navigationController?.pushViewController(vc, animated: true)
        }
     
    }
    
    
    @objc func tap_callBtn(sender:UIButton){
        
        let dict = normalUserActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
       // let countryCode = dict.object(forKey: "offerAcceptedOfCountryCode") as? String ?? ""
        let phoneNo = dict.object(forKey: "offerAcceptedOfMobileNumber") as? String ?? ""
        
        if let phoneCallURL:URL = URL(string: "tel://\(phoneNo)"){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(phoneCallURL)
            }
        }
        
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


extension MyOrderNormalUserActiveVC{
    
    @objc func apiCallForGetActiveOrder(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","lat":"\(CommonClass.sharedInstance.locationLatCordinate)","long":"\(CommonClass.sharedInstance.locationLongCordinate)","serviceType":"DeliveryPersion"]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForFetchActiveOrderOfNormalUser as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.normalUserActiveArr = receivedData.object(forKey: "Data1") as? NSArray ?? []
                        
                        if self.normalUserActiveArr.count == 0{
                            
                            self.lblPlaceholder.isHidden = false
                            self.tableview.isHidden = true
                        }
                        else{
                            
                            self.lblPlaceholder.isHidden = true
                            self.tableview.isHidden = false
                            self.tableview.reloadData()
                            
                            let topIndex = IndexPath(row: 0, section: 0)
                            self.tableview.scrollToRow(at: topIndex, at: .top, animated: true)
                            
                        }
                    }
                    else{
                        
                        self.lblPlaceholder.isHidden = false
                        self.tableview.isHidden = true
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToHome()
                        }
                        else{
                        
                            
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


extension MyOrderNormalUserActiveVC:InstructionDismissDelegate{
    
    func instructionDismissle(status: String) {
        
        if status == "yes"{
            
            let vc = ScreenManager.getOrderStartedPopupVC()
            
            vc.delegate = self
            
            vc.orderID = dataPassingDict.object(forKey: "_id") as? String ?? ""
            vc.controllerPurpuse = "Normal"
            
            vc.subControllerPurpuse == "NormalDelivery"
            
            self.present(vc, animated: true, completion: nil)
        }
    }

}


extension MyOrderNormalUserActiveVC:OrderStartDelegate{
    
    func orderStarted(status: String) {
        
        if status == "yes"{
            
            print("success")
            
            let receiverId = dataPassingDict.object(forKey: "offerAcceptedOfId") as? String ?? ""
            let roomId = dataPassingDict.object(forKey: "roomId") as? String ?? ""

            let vc = ScreenManager.getMessagesVC()

            vc.isComing = "NormalDelivery"

            vc.receiverID = receiverId
            vc.roomID = roomId
            
            vc.userOrderInfo = self.dataPassingDict
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
 
}
