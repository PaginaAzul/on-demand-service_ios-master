//
//  NormalUserProfessionalActiveVC.swift
//  Joker
//
//  Created by Callsoft on 02/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class NormalUserProfessionalActiveVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    var normalUserActiveArr = NSArray()
    
    let connection = webservices()
    
    var dataPassingDict = NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblPlaceholder.isHidden = true
        
        lblPlaceholder.text = "No data found".localized()
        
        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
        initialSetup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.apiCallForGetActiveOrder), name: NSNotification.Name(rawValue: "NotificationForUpdateActiveOrderNormalUserProfessionalPersonDone"), object: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        apiCallForGetActiveOrder()
        
    }

}


extension NormalUserProfessionalActiveVC{
    
    func initialSetup(){
        tableview.tableFooterView = UIView()
    }
 
}


//MARK: - Extension TableView Controller
extension NormalUserProfessionalActiveVC:UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return normalUserActiveArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableview.register(UINib(nibName: "MyOrderDashBoardProffessionalActiveTableViewCellAndXib", bundle: nil), forCellReuseIdentifier: "MyOrderDashBoardProffessionalActiveTableViewCellAndXib")
        let cell = tableview.dequeueReusableCell(withIdentifier: "MyOrderDashBoardProffessionalActiveTableViewCellAndXib", for: indexPath) as! MyOrderDashBoardProffessionalActiveTableViewCellAndXib
       // cell.lblDescription.text = "Tap plumber, any kind of tap \nProfessional tap plumber"
        
        cell.btnReportOrder.tag = indexPath.row
        cell.btnReportOrder.addTarget(self, action: #selector(NormalUserProfessionalActiveVC.tapIssueWithMyOrderBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.lblNote.attributedText = CommonClass.sharedInstance.setNoteText("Note", "We are using only cash for the payment")
        
        cell.btnViewRating.tag = indexPath.row
        cell.btnViewRating.addTarget(self, action: #selector(NormalUserProfessionalActiveVC.tapBtnViewRating(sender:)), for: UIControlEvents.touchUpInside)
        
        let dict = normalUserActiveArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        /////////////
        
        
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
        
        
        /////////////
        
        
        let orderId = dict.object(forKey: "orderNumber") as? String ?? ""
        let createdDate = dict.object(forKey: "createdAt") as? String ?? ""
        
        cell.lblOrderID.attributedText = CommonClass.sharedInstance.setOrderIDText("Order ID".localized(),orderId)
        
        cell.lblDateAndTime.text = fetchData(dateToConvert: createdDate)
        
        
        print("Active -- \(fetchData(dateToConvert: createdDate))")
        
        let invoiceDate = dict.object(forKey: "invoiceCreatedAt") as? String ?? ""
        
        if invoiceDate != ""{
            
            
            cell.lblInvoiceDate.text = self.fetchData(dateToConvert: invoiceDate)
        }
        else{
            
            cell.lblInvoiceDate.text = "No date found".localized()
        }
        
        let imgStr = dict.object(forKey: "offerAcceptedOfProfilePic") as? String ?? ""
        if imgStr == ""{
            
            cell.imgUser.image = UIImage(named: "placeholderImg")
        }
        else{
            
            let urlStr = URL(string: imgStr)
            cell.imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
        
        cell.lblUsername.text = dict.object(forKey: "offerAcceptedOfName") as? String ?? ""
        
        let avgRating = dict.object(forKey: "AvgRating") as? Double ?? 0.0
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        
        cell.lblAvgRating.text = "\(avgRating)"
        
        if totalRating == 0{
            
            cell.btnViewRating.setTitle("(0 "+"Rating".localized()+")", for: .normal)
        }
        else{
            
            cell.btnViewRating.setTitle("(\(totalRating) "+"Rating View All".localized()+")", for: .normal)
        }
        
        let pickupLocation = dict.object(forKey: "pickupLocation") as? String ?? ""
        
        let currentToPickupLocation = dict.object(forKey: "currentToPicupLocation") as? String ?? ""
        
        cell.lblStartToDropOffLocation.text = "\(currentToPickupLocation)\("KM".localized())"
        cell.lblDropOffToProfWorkingLocation.text = "0KM"
        cell.lblProfessionalToDeliveredLocation.text = "0KM"
        
        let orderDetail = dict.object(forKey: "orderDetails") as? String ?? ""
        
       // cell.lblOrderDetail.text = "Order Details".localized()+" : \(orderDetail)"
        
        cell.lblOrderDetail.text = "Order Details".localized()
        
        cell.lblOrderDetailValue.text =  "\(orderDetail)"
        cell.lblOrderDetail.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 14.0)
        
        let chargeOffer = dict.object(forKey: "minimumOffer") as? String ?? ""
        
        let approxTime = dict.object(forKey: "apprxTime") as? String ?? ""
        let message = dict.object(forKey: "message") as? String ?? ""
        
        let currency = dict.object(forKey: "currency") as? String ?? ""
        
        cell.lblChargeOffer.text = "\(chargeOffer) \(currency)"
        cell.lblWorkCompletionTime.text = "\(approxTime)"
        cell.lblMessage.text = message
        
        if cell.lblWorkCompletionTime.text == ""{
            
            cell.lblWorkCompletionTime.text = "Not Defined".localized()
        }
        
        if cell.lblMessage.text == ""{
            
            cell.lblMessage.text = "Not Defined".localized()
        }
        
        let deliveryOffer = dict.object(forKey: "deliveryOffer") as? String ?? ""
        
        let tax = dict.object(forKey: "tax") as? String ?? ""
        let total = dict.object(forKey: "total") as? String ?? ""
        
        cell.lblDeliveryOffer.text = "\(deliveryOffer) \(currency)"
        cell.lblTax.text = "\(tax) \(currency)"
        cell.lblTotal.text = "\(total) \(currency)"
        
        var selectCate = ""
        var subCat = ""
        
        if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
            
            selectCate = dict.object(forKey: "portugueseCategoryName") as? String ?? ""
            
            subCat = dict.object(forKey: "portugueseSubCategoryName") as? String ?? ""
        }
        else{
            
            selectCate = dict.object(forKey: "selectCategoryName") as? String ?? ""
            
            subCat = dict.object(forKey: "selectSubCategoryName") as? String ?? ""
        }      
        
        cell.lblCategory.text = selectCate
        
        if subCat == ""{
            
             cell.lblSubcategory.text = "No subcategory found".localized()
        }
        else{
            
            cell.lblSubcategory.text = subCat
        }
        
        cell.lblStartHeading.text = "Start".localized()
        cell.lblArrivedHeading.text = "Arrived".localized()
        cell.lblProfessionalWorkingHeading.text = "Professional Working".localized()
        cell.lblDeliveredHeading.text = "Delivered".localized()
        cell.lblChangeOfferHeading.text = "Charge Offer".localized()
        cell.lblProfessionalMessageHeading.text = "Professional Message".localized()
        cell.lblWorkCompletionTimeHeading.text = "Work Completion Time".localized()
        cell.lblCategoryHeading.text = "Category".localized()
        cell.lblSubcategoryHeading.text = "Sub-Category".localized()
        cell.lblInvoiceDetailsHeading.text = "Invoice Details".localized()
        cell.lblDeliveryOfferHeading.text = "Delivery Offer".localized()
        cell.lblTax5Percent.text = "Tax 5%".localized()
        cell.lblTotalHeading.text = "Total".localized()
        
        cell.btnReportOrder.setTitle("Contact Professional".localized(), for: .normal)
        
        return cell
        
    }
    
    
    func fetchData(dateToConvert:String) -> String {
        
        
        let dateFormatter = DateFormatter()
        // dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = Locale(identifier: NSLocale.current.languageCode!)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let pendingDate = dateFormatter.date(from: dateToConvert)!
        let sendTime = self.dateFormatterForTime.string(from: pendingDate)
        let sendDate = self.dateFormatterForDate.string(from: pendingDate)
        
        var locaMonth =  "\(sendDate)".substring(with: 3..<6)

        //if "\(self.fetchData(dateToConvert: createdDate))".contains(locaMonth) {
        var newM = locaMonth.localized()

        //   "\(sendDate)".replacingOccurrences(of: newM, with: sendDate)

        print("")

        print("==== At NormalUserProfessionalActiveVC","\(sendDate)".replacingOccurrences(of: locaMonth, with: newM))

        let converTedDate = "\(sendDate)".replacingOccurrences(of: locaMonth, with: newM)
        
        return "\(converTedDate) \(sendTime)"
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
    
    
    ///////////////////
    
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
    
    
    //////////////////
    
    @objc func tapIssueWithMyOrderBtn(sender:UIButton){
        
//        let dict = normalUserActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
//        let id = dict.object(forKey: "_id") as? String ?? ""
//
//        let vc = ScreenManager.getCancellationVC()
//        vc.controllerPurpuse = "ReportCancel"
//
//        vc.reportType = "NormalUser"
//
//        vc.orderID = id
//        self.navigationController?.pushViewController(vc, animated: true)
        
        //we are using this func for message and track order after changes in UI
        
        
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
            
            let currency = dict.object(forKey: "currency") as? String ?? ""
            
            let vc = ScreenManager.getMessagesVC()
            
            vc.isComing = "NormalProfessional"
            
            vc.receiverID = receiverId
            vc.roomID = roomId
            
            vc.userOrderInfo = self.dataPassingDict
            
            vc.currency = currency
            
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
        
        let currency = dict.object(forKey: "currency") as? String ?? ""
        
        let vc = ScreenManager.getMessagesVC()
        
        vc.isComing = "NormalProfessional"
        
        vc.receiverID = receiverId
        vc.roomID = roomId
        
        vc.currency = currency
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapTrackBtn(sender:UIButton){
        
        let vc = ScreenManager.getActiveOrderTrackingVC()
        
        let dict = normalUserActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        vc.dict = dict
        
        vc.isComing = "NormalProfessional"
        
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
        
      //  let countryCode = dict.object(forKey: "offerAcceptedOfCountryCode") as? String ?? ""
        
        let phoneNo = dict.object(forKey: "offerAcceptedOfMobileNumber") as? String ?? ""
        
        if let phoneCallURL:URL = URL(string: "tel://\(phoneNo)"){
            
            if #available(iOS 10.0, *) {
                
                UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
                
            } else {
                
                UIApplication.shared.openURL(phoneCallURL)
            }
        }
        
    }
    
}



extension NormalUserProfessionalActiveVC{
    
    @objc func apiCallForGetActiveOrder(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","lat":"\(CommonClass.sharedInstance.locationLatCordinate)","long":"\(CommonClass.sharedInstance.locationLongCordinate)","serviceType":"ProfessionalWorker","langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]
            
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
                    
                   // CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
}


extension NormalUserProfessionalActiveVC:InstructionDismissDelegate{
    
    func instructionDismissle(status: String) {
        
        if status == "yes"{
            
            let vc = ScreenManager.getOrderStartedPopupVC()
            
            vc.delegate = self
            
            vc.orderID = dataPassingDict.object(forKey: "_id") as? String ?? ""
            vc.controllerPurpuse = "Normal"
            
            vc.subControllerPurpuse = "NormalProfessional"
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}


extension NormalUserProfessionalActiveVC:OrderStartDelegate{
    
    func orderStarted(status: String) {
        
        if status == "yes"{
            
            print("success")
            
            let receiverId = dataPassingDict.object(forKey: "offerAcceptedOfId") as? String ?? ""
            let roomId = dataPassingDict.object(forKey: "roomId") as? String ?? ""
            
            let currency = dataPassingDict.object(forKey: "currency") as? String ?? ""
            
            let vc = ScreenManager.getMessagesVC()
            
            vc.isComing = "NormalProfessional"
            
            vc.receiverID = receiverId
            vc.roomID = roomId
            
            vc.currency = currency
            
            vc.userOrderInfo = self.dataPassingDict
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}




