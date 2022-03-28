//
//  DeliveryPersonActiveVC.swift
//  Joker
//
//  Created by Callsoft on 02/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import GoogleMaps
import SocketIO


class DeliveryPersonActiveVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    var deliveryPersonActiveArr = NSArray()
    
    let connection = webservices()
    
    var dataPassingDict = NSDictionary()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var lastLocation:CLLocation?
    var locationManager = CLLocationManager()
    var sourceLat: Double = 0.0
    var sourceLong: Double = 0.0
    
    let socketManager = SocketManager(socketURL: URL(string: "http://18.189.223.53:3000")!, config: ["log": true])
    var socket: SocketIOClient!
    
    var globalRoomId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblPlaceholder.isHidden = true
        
        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
        initialSetup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DeliveryPersonActiveVC.apiCallForGetActiveOrderOfDeliveryPerson), name: NSNotification.Name(rawValue: "NotificationForUpdatePendingAndActiveOrderOfDeliveryPerson"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.redirectToHomeInCaseOfOrderHasCancelledByNormal), name: NSNotification.Name(rawValue: "RedirectToHomeFromDashboardOfBothServiceProvider"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.apiCallForGetActiveOrderOfDeliveryPerson), name: NSNotification.Name(rawValue: "OfferAcceptedByNormal"), object: nil)
        
        socketHandling()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.apiCallForGetActiveOrderOfDeliveryPerson()
    }
    
    
    func updateLocationSetup(){
        
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
       // self.locationManager.allowsBackgroundLocationUpdates = true
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.distanceFilter = 10.0
        self.locationManager.pausesLocationUpdatesAutomatically = true
        
        self.locationManager.startUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func generateRoomId()->String{
        
        if self.deliveryPersonActiveArr.count != 0{
            
            let dict = self.deliveryPersonActiveArr.object(at: 0) as? NSDictionary ?? [:]
            
            let realOrderId = dict.object(forKey: "realOrderId") as? String ?? ""
            let orderOwner = dict.object(forKey: "orderOwner") as? String ?? ""
            
            return "\(orderOwner)\(realOrderId)"
        }
        
        return ""
    }
    
    
    func socketHandling() {
        
        socket = socketManager.defaultSocket
        
        let socketConnectionStatus = socket.status
        
        switch socketConnectionStatus {
        case SocketIOStatus.connected:
            print("socket connected")
        case SocketIOStatus.connecting:
            print("socket connecting")
        case SocketIOStatus.disconnected:
            socket.connect()
            print("socket disconnected")
        case SocketIOStatus.notConnected:
            socket.connect()
            print("socket not connected")
        }
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            
        }
        
        socket.on("room join") { (data, ack) in
            
            print("Room Joined")
            print(data)
            
        }
        
        socket.on("tracking") { (data, ack) in
            
            print("Track Coordinate sent to server")
            print(data)
            
        }
        
    }
    
}


extension DeliveryPersonActiveVC{

    func initialSetup(){
        
        tableview.tableFooterView = UIView()
    }
    
    @objc func redirectToHomeInCaseOfOrderHasCancelledByNormal(){
        
        let vc = ScreenManager.getServiceProviderMapVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
        
    }
}

extension DeliveryPersonActiveVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return deliveryPersonActiveArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableview.register(UINib(nibName: "MyDashboardDeliveryWorkerActiveTableViewCellAndXib", bundle: nil), forCellReuseIdentifier: "MyDashboardDeliveryWorkerActiveTableViewCellAndXib")
        let cell = tableview.dequeueReusableCell(withIdentifier: "MyDashboardDeliveryWorkerActiveTableViewCellAndXib", for: indexPath) as! MyDashboardDeliveryWorkerActiveTableViewCellAndXib
        
        cell.btnWorkDone.tag = indexPath.row
        cell.btnWorkDone.addTarget(self, action: #selector(DeliveryPersonActiveVC.tapWorkDoneBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.tapViewRating.tag = indexPath.row
        cell.tapViewRating.addTarget(self, action: #selector(DeliveryPersonActiveVC.tapBtnViewRating(sender:)), for: UIControlEvents.touchUpInside)
        
        let dict = deliveryPersonActiveArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let orderId = dict.object(forKey: "orderNumber") as? String ?? ""
        cell.lblOrderId.attributedText = CommonClass.sharedInstance.setOrderIDText("Order ID",orderId)
        
        let createdDate = dict.object(forKey: "createdAt") as? String ?? ""
        
        cell.lblDateAndTime.text = self.fetchData(dateToConvert: createdDate)
        
        let invoiceDate = dict.object(forKey: "invoiceCreatedAt") as? String ?? ""
        
        if invoiceDate != ""{
            
            cell.lblInvoiceDate.text = self.fetchData(dateToConvert: invoiceDate)
        }
        else{
            
            cell.lblInvoiceDate.text = "No date found"
        }
        
        cell.lblName.text = dict.object(forKey: "offerAcceptedByName") as? String ?? ""
        
        cell.lblAvgRating.text = "\(dict.object(forKey: "AvgRating") as? Double ?? 0.0)"
        
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        
        if totalRating == 0{
            
            cell.tapViewRating.setTitle("(0 "+"Rating".localized()+")", for: .normal)
        }
        else{
            
            cell.tapViewRating.setTitle("\(totalRating) Rating view all", for: .normal)
        }
        
        let imgStr = dict.object(forKey: "offerAcceptedByProfilePic") as? String ?? ""
        if imgStr == ""{
            
            cell.imgProfile.image = UIImage(named: "placeholderImg")
        }
        else{
            
            let urlStr = URL(string: imgStr)
            cell.imgProfile.setImageWith(urlStr!, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
        let startToPickupLocation = dict.object(forKey: "currentToPicupLocation") as? String ?? ""
        let pickupToDropOffLocation = dict.object(forKey: "pickupToDropLocation") as? String ?? ""
        
        cell.lblStartToPickupLocation.text = "\(startToPickupLocation)KM"
        cell.lblPickupToDropoffLocation.text = "\(pickupToDropOffLocation)KM"
        cell.lblDropOffToDeliveredLocation.text = "0.0KM"
        
        let pickupLocation = dict.object(forKey: "pickupLocation") as? String ?? ""
        let dropOffLocation = dict.object(forKey: "dropOffLocation") as? String ?? ""
        
        //cell.lblOrderDetail.text = "Pickup Location : \(pickupLocation)\n\nDropOff Location : \(dropOffLocation)"
        
        let countryCode = dict.object(forKey: "offerAcceptedByCountryCode") as? String ?? ""
        let phoneNo = dict.object(forKey: "offerAcceptedByMobileNumber") as? String ?? ""
        
        cell.lblContactNo.text = "\(countryCode)\(phoneNo)"
        
        let orderDetail = dict.object(forKey: "orderDetails") as? String ?? ""
        let selectTime = dict.object(forKey: "seletTime") as? String ?? ""
        
        cell.lblAddress.attributedText = CommonClass.sharedInstance.attributedStringToDeliveryNewEnhancement(title1: "Pickup Location", subTitle1: "\(pickupLocation)\n", delemit: " - ", titleColor1: #colorLiteral(red: 0.7970424294, green: 0.5491735935, blue: 0.9914678931, alpha: 1), SubtitleColor1: UIColor.black, title2: "Dropoff Location", subTitle2: "\(dropOffLocation)\n", titleColor2: #colorLiteral(red: 0.7970424294, green: 0.5491735935, blue: 0.9914678931, alpha: 1), SubtitleColor2: UIColor.black, title3: "Message", subTitle3: "\(orderDetail)\n", titleColor3: #colorLiteral(red: 0.7970424294, green: 0.5491735935, blue: 0.9914678931, alpha: 1), SubtitleColor3: UIColor.black, title4: "", subTitle4: "", titleColor4: UIColor.clear, SubtitleColor4: UIColor.clear)
        
        cell.lblDeliveryOffer.text = "\(dict.object(forKey: "deliveryOffer") as? String ?? "")SAR"
        
        cell.lblTax.text = "\(dict.object(forKey: "tax") as? String ?? "")SAR"
        cell.lblTotal.text = "\(dict.object(forKey: "total") as? String ?? "")SAR"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    
    @objc func tap_GoBtn(sender:UIButton){
        
        let dict = deliveryPersonActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let goStatus = dict.object(forKey: "goStatus") as? String ?? ""
        if goStatus == "false"{
            
            let orderId = dict.object(forKey: "_id") as? String ?? ""
            
            self.apiCallForGoStatus(orderID: orderId)
        }
        else{
            
            //edit invoice here
            
            let invoiceStatus = dict.object(forKey: "invoiceStatus") as? String ?? ""
            
            if invoiceStatus == "true"{
                
                let vc = ScreenManager.getCreateInvoiceVC()
                
                let orderId = dict.object(forKey: "_id") as? String ?? ""
                
                vc.orderId = orderId
                vc.userType = "DeliveryWorker"
                vc.controllerPurpuse = "Edit"
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }
    }
    
    
    @objc func tap_createInvoiceBtn(sender:UIButton){
        
        let dict = deliveryPersonActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let invoiceStatus = dict.object(forKey: "invoiceStatus") as? String ?? ""
        
        if invoiceStatus == "false"{
            
            let vc = ScreenManager.getCreateInvoiceVC()
            
            let orderId = dict.object(forKey: "_id") as? String ?? ""
            
            vc.orderId = orderId
            vc.userType = "DeliveryWorker"
            vc.controllerPurpuse = ""
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            
            
        }
     
    }
    
    
    @objc func tap_arrivedBtn(sender:UIButton){
        
        let dict = deliveryPersonActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let orderId = dict.object(forKey: "_id") as? String ?? ""
        
        self.apiCallForArrived(orderId: orderId)
        
    }
    
    @objc func tap_DoneBtn(sender:UIButton){
        
//        let dict = self.deliveryPersonActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
//
//        let orderId = dict.object(forKey: "_id") as? String ?? ""
//
//        let anotherUserId = dict.object(forKey: "offerAcceptedById") as? String ?? ""
//
//        self.apiCallForWorkDone(orderId: orderId, anotherUserId: anotherUserId)
        
    }
    
    
    @objc func tapWorkDoneBtn(sender:UIButton){
        
//        let alertController = UIAlertController(title: "", message: "Do you want to work done for this order?", preferredStyle: .alert)
//
//        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//            UIAlertAction in
//
//            let dict = self.deliveryPersonActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
//
//            let orderId = dict.object(forKey: "_id") as? String ?? ""
//
//            let anotherUserId = dict.object(forKey: "offerAcceptedById") as? String ?? ""
//
//            self.apiCallForWorkDone(orderId: orderId, anotherUserId: anotherUserId)
//
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
//            UIAlertAction in
//
//        }
//
//        alertController.addAction(okAction)
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true, completion: nil)
      
        
        let dict = self.deliveryPersonActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        self.dataPassingDict = self.deliveryPersonActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let popupStatus = dict.object(forKey: "popupStatus") as? String ?? ""
        
        if popupStatus == "Show"{
            
            let vc = ScreenManager.getOrderInstructionPopupVC()
            
            vc.controllerPurpuse = "MsgAndTrack"
            vc.delegate = self
            
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
        else{
            
            let dict = deliveryPersonActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
            
            let receiverId = dict.object(forKey: "offerAcceptedById") as? String ?? ""
            let roomId = dict.object(forKey: "roomId") as? String ?? ""
            
            let vc = ScreenManager.getMessagesVC()
            
            vc.isComing = "DeliveryWorker"
            
            vc.receiverID = receiverId
            vc.roomID = roomId
            
            vc.userOrderInfo = self.dataPassingDict
            
            vc.roomIdForTracking = self.globalRoomId
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    @objc func tapReportCancelOrder(sender:UIButton){
        
        let dict = deliveryPersonActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let orderId = dict.object(forKey: "_id") as? String ?? ""
        
        let vc = ScreenManager.getCancellationVC()
        
        vc.controllerPurpuse = "ReportCancel"
        vc.orderID = orderId
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func tapCancelOrder(sender:UIButton){
        
        let dict = deliveryPersonActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let orderId = dict.object(forKey: "_id") as? String ?? ""
        
        let vc = ScreenManager.getCancellationVC()
        
        vc.controllerPurpuse = ""
        vc.orderID = orderId
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func tapMessageAction(sender:UIButton){
        
        let dict = deliveryPersonActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let receiverId = dict.object(forKey: "offerAcceptedById") as? String ?? ""
        let roomId = dict.object(forKey: "roomId") as? String ?? ""
        
        let vc = ScreenManager.getMessagesVC()
        
        vc.isComing = "DeliveryWorker"
        
        vc.receiverID = receiverId
        vc.roomID = roomId
        
        vc.roomIdForTracking = self.globalRoomId
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @objc func tapTrackAction(sender:UIButton){
        
        let vc = ScreenManager.getActiveOrderTrackingVC()
        
        let dict = deliveryPersonActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        vc.dict = dict
        
        vc.isComing = "DeliveryWorker"
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @objc func tapContactAdminBtn(sender:UIButton){
        
        let vc = ScreenManager.getContactAdminVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func tapBtnViewRating(sender:UIButton){
        
        let dict = deliveryPersonActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        
        let id = dict.object(forKey: "offerAcceptedById") as? String ?? ""
        
        if totalRating != 0{
            
            let vc = ScreenManager.getUserDetailVC()
            
            vc.userID = id
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
      
    }
    
    
    @objc func tap_callBtn(sender:UIButton){
        
        let dict = deliveryPersonActiveArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
       // let countryCode = dict.object(forKey: "offerAcceptedByCountryCode") as? String ?? ""
        let phoneNo = dict.object(forKey: "offerAcceptedByMobileNumber") as? String ?? ""
        
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


extension DeliveryPersonActiveVC{
    
    @objc func apiCallForGetActiveOrderOfDeliveryPerson(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","lat":"\(CommonClass.sharedInstance.locationLatCordinate)","long":"\(CommonClass.sharedInstance.locationLongCordinate)"]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetActiveOrderDeliveryPerson as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.deliveryPersonActiveArr = receivedData.object(forKey: "Data1") as? NSArray ?? []
                        
                        if self.deliveryPersonActiveArr.count == 0{
                            
                            self.lblPlaceholder.isHidden = false
                            self.tableview.isHidden = true
                        }
                        else{
                            
                            self.globalRoomId = self.generateRoomId()
                            
                            if self.globalRoomId != ""{
                                
                                self.socket.emit("room join", ["roomId": self.globalRoomId])
                            }
                            
                            self.updateLocationSetup()
                            
                            self.lblPlaceholder.isHidden = true
                            self.tableview.isHidden = false
                            self.tableview.reloadData()
                            
                            let topIndex = IndexPath(row: 0, section: 0)
                            self.tableview.scrollToRow(at: topIndex, at: .top, animated: true)
                            
                             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FreezeStatusOfDeliveryWorker"), object: nil)
                            
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
    
    
    func apiCallForWorkDone(orderId:String,anotherUserId:String){
        
        let param:[String:String] = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","orderId":orderId]
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForWorkDoneByDeliveryPerson as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdatePastListDelivery"), object: nil)
                        
                        let alertController = UIAlertController(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            
                            let vc = ScreenManager.getReviewAndRatingVC()
                            vc.isComing = "DELIVERY"
                            
                            vc.ratingPurpuse = "OrderRating"
                            
                            vc.orderId = orderId
                            vc.ratingToUserId = anotherUserId
                            vc.ratingToTypeUser = "NormalUser"
                            vc.ratingByTypeUser = "DeliveryPerson"
                            
                            UserDefaults.standard.set("", forKey: "ISCOMIMG_RATINGPOPUP")
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        
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



//MARK:- Using extension for tracking
//MARK:-
extension DeliveryPersonActiveVC{
    
    func apiCallForGoStatus(orderID:String){
        
        let param:[String:String] = ["orderId":orderID]
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGoStatus as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.apiCallForGetActiveOrderOfDeliveryPerson()
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
    
    
    func apiCallForArrived(orderId:String){
        
        let param:[String:String] = ["orderId":orderId]
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForArrivedStatus as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.apiCallForGetActiveOrderOfDeliveryPerson()
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


extension DeliveryPersonActiveVC:InstructionDismissDelegate{
    
    func instructionDismissle(status: String) {
        
        if status == "yes"{
            
            let vc = ScreenManager.getOrderStartedPopupVC()
            
            vc.delegate = self
            
            vc.orderID = dataPassingDict.object(forKey: "_id") as? String ?? ""
            vc.controllerPurpuse = "Delivery"
            
            vc.subControllerPurpuse == "DeliveryWorker"
            
            self.present(vc, animated: true, completion: nil)
        }
    }
}


extension DeliveryPersonActiveVC:OrderStartDelegate{
    
    func orderStarted(status: String) {
        
        if status == "yes"{
            
            print("success")
            
            let receiverId = dataPassingDict.object(forKey: "offerAcceptedById") as? String ?? ""
            let roomId = dataPassingDict.object(forKey: "roomId") as? String ?? ""
            
            let vc = ScreenManager.getMessagesVC()
            
            vc.isComing = "DeliveryWorker"
            
            vc.receiverID = receiverId
            vc.roomID = roomId
            
            vc.userOrderInfo = self.dataPassingDict
            
            vc.roomIdForTracking = self.globalRoomId
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}



//MARK:- Location Manager Delegate
//MARK:-
extension DeliveryPersonActiveVC:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("----------->ViewController Location Update")
        
        lastLocation = locations.last!
        print("Location: \(String(describing: lastLocation))")
        
        self.createRegion(location: lastLocation)
        
        if UIApplication.shared.applicationState == .active {
            
        } else {
            //App is in BG/ Killed or suspended state
            //send location to server
            // create a New Region with current fetched location
            let location = locations.last
            lastLocation = location
            
            //Make region and again the same cycle continues.
            self.createRegion(location: lastLocation)
        }
    }
    
    func createRegion(location:CLLocation?) {
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let coordinate = CLLocationCoordinate2DMake((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
            let regionRadius = 5.0
            
            let region = CLCircularRegion(center: CLLocationCoordinate2D(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude),
                                          radius: regionRadius,
                                          identifier: "aabb")
            
            region.notifyOnExit = true
            region.notifyOnEntry = true
            
            sourceLat = coordinate.latitude
            sourceLong = coordinate.longitude
            
            //Send your fetched location to server
            
            self.socket.emit("tracking", ["roomId": self.globalRoomId,"lattitude":"\(sourceLat)","longitude":"\(sourceLong)"])
            
            print("----------->AppDelegate Region Update")
            
            //Update location with source lat and long when region is being change
            
            //self.locationManager.stopUpdatingLocation()
            self.locationManager.startMonitoring(for: region)
            
        }
            
        else {
            print("System can't track regions")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        print("Entered Region")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        print("Exited Region")
        //locationManager.stopMonitoring(for: region)
        locationManager.startUpdatingLocation()
      
    }
}
