//
//  MessagesVC.swift
//  Joker
//
//  Created by abc on 02/02/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SocketIO
import GoogleMaps


class MessagesVC: UIViewController {
    //MARK: - Outlets
    
    @IBOutlet weak var btnGo: UIButton!
    
    @IBOutlet weak var btnCreateInvoice: UIButton!
    
    @IBOutlet weak var btnArrived: UIButton!
    
    @IBOutlet weak var btnDone: UIButton!
    
    @IBOutlet var headerView: UIView!
    
    @IBOutlet weak var tblViewMessages: UITableView!
    
    @IBOutlet weak var lblStart: UILabel!
    
    @IBOutlet weak var lblPickup: UILabel!
    
    @IBOutlet weak var lblDropof: UILabel!
    @IBOutlet weak var lblDelivered: UILabel!
    
    @IBOutlet weak var sendMessageBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var txtViewMsg: UITextView!
    
    @IBOutlet weak var tableviewTopConstraint: NSLayoutConstraint!
    
    //header outlet
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblAvgRating: UILabel!
    
    @IBOutlet weak var lblDeliveryCost: UILabel!
    
    @IBOutlet weak var lblOrderId: UILabel!
    
    @IBOutlet weak var lblPickupToDropoffLocation: UILabel!
    
    @IBOutlet weak var lblStartToPickupLocation: UILabel!
    
    @IBOutlet weak var viewTrack: UIView!
    
    @IBOutlet weak var lblnav: UILabel!
    
    @IBOutlet weak var lblCall: UILabel!
    
    @IBOutlet weak var lblTrack: UILabel!
    
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //MARK: - Variable
    var isComing = String()
    
    var globalHeight = CGFloat()
    var yCordinateOfView = CGFloat()
    
    var receiverID = ""
    var roomID = ""
    
    var currency = ""
    
    let connection = webservices()
    
    let socketManager = SocketManager(socketURL: URL(string: "http://3.129.47.202:3000")!, config: ["log": true])
    
    var socket: SocketIOClient!
    var imageName = ""
    var imageData = NSData()
    var imagePicker = UIImagePickerController()
    
    var chatingArr = NSMutableArray()
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    var forFirstTimeOnly = true
    
    var userOrderInfo = NSDictionary()
    var globalOrderID = ""
    
    var deliveryTrackingDict = NSDictionary()
    var normalWithDeliveryDict = NSDictionary()
    
    
    var lastLocation:CLLocation?
    var locationManager = CLLocationManager()
    var sourceLat: Double = 0.0
    var sourceLong: Double = 0.0
    var roomIdForTracking = ""
    
    var realOrderIdForWithdraw = ""
    
    var withdrawOfferPopupOpenStatus = ""
    var imageType = String()
    
//    var longitudeT = Double()
//    var latitudeT = Double()
//
//    var selfCurrentLatT = Double()
//    var selfCurrentLongT = Double()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.globalHeight = self.view.frame.size.height
        self.yCordinateOfView = self.view.frame.origin.y
        
        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
        self.apiCallForGetUserType()
        
        lblnav.text = "Messages".localized()
        lblCall.text = "Call".localized()
        lblTrack.text = "Track".localized()
        
        if isComing == "NormalDelivery"{
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.trackOrderForNormal), name: NSNotification.Name(rawValue: "UpdateNormalUserTrackingStatus"), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.updateChatForNormalWhenActionTakenByDeliveryWorker), name: NSNotification.Name(rawValue: "ActionTakenByDeliveryWorkerInTracking"), object: nil)
            
            //register work done status for normal delivery, same notificatio is being done in active section of normal delivery to update list
            
           // NotificationCenter.default.addObserver(self, selector: #selector(self.sendToPastDashboardOfNormalDelivery), name: NSNotification.Name(rawValue: "NotificationForUpdateActiveOrderNormalUserDeliveryPersonDone"), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.presentPopupInCaseOfWithdrawByDelivery), name: NSNotification.Name(rawValue: "WithdrawByDeliveryWorker"), object: nil)
            
            let withdrawOfferStatus = userOrderInfo.object(forKey: "status") as? String ?? ""
            
            if withdrawOfferStatus == "Request"{
                
                globalOrderID = self.userOrderInfo.object(forKey: "_id") as? String ?? ""
                self.presentPopupInCaseOfWithdrawByDelivery()
            }
            
        }
        else if isComing == "NormalProfessional"{
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.trackOrderForNormal), name: NSNotification.Name(rawValue: "UpdateNormalUserTrackingStatus"), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.updateChatForNormalWhenActionTakenByProfessionalWorker), name: NSNotification.Name(rawValue: "ActionTakenByProfessionalWorkerInTracking"), object: nil)
            
            //register work done status for normal professional
            
           // NotificationCenter.default.addObserver(self, selector: #selector(self.sendToPastDashboardOfNormalProfessional), name: NSNotification.Name(rawValue: "NotificationForUpdateActiveOrderNormalUserProfessionalPersonDone"), object: nil)
            
            
             NotificationCenter.default.addObserver(self, selector: #selector(self.presentPopupInCaseOfWithdrawByProfessional), name: NSNotification.Name(rawValue: "WithdrawByProfessionalWorker"), object: nil)
            
            let withdrawOfferStatus = userOrderInfo.object(forKey: "status") as? String ?? ""
            
            if withdrawOfferStatus == "Request"{
                
                globalOrderID = self.userOrderInfo.object(forKey: "_id") as? String ?? ""
                self.presentPopupInCaseOfWithdrawByProfessional()
            }
            
        }
//        else if isComing == "DeliveryWorker"{
//
//            NotificationCenter.default.addObserver(self, selector: #selector(self.withdrawRequestAcceptedByNormalDelivery), name: NSNotification.Name(rawValue: "WithdrawRequesteAcceptedByNormalDelivery"), object: nil)
//        }
//        else if isComing == "ProfessionalWorker"{
//
//            NotificationCenter.default.addObserver(self, selector: #selector(self.withdrawRequestAcceptedByNormalProfessional), name: NSNotification.Name(rawValue: "WithdrawRequesteAcceptedByNormalProfessional"), object: nil)
//        }
        else{}
        
        initialSetup()
        
        socketHandling()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        globalOrderID = self.userOrderInfo.object(forKey: "_id") as? String ?? ""
        
        realOrderIdForWithdraw = self.userOrderInfo.object(forKey: "realOrderId") as? String ?? ""
        
        if isComing == "DeliveryWorker"{
            
            self.updateLocationSetup()
            self.apiCallForGetTrackingTrackingOrderDelivery(orderId: globalOrderID)
        }
        else if isComing == "NormalDelivery"{
            
            self.apiCallForGetTrackingTrackingNormalUser(orderId: globalOrderID)
        }
        else if isComing == "NormalProfessional"{
            
            self.apiCallForGetTrackingTrackingNormalUser(orderId: globalOrderID)
        }
        else if isComing == "ProfessionalWorker"{
            
            self.updateLocationSetup()
            self.apiCallForGetTrackingTrackingOrderDelivery(orderId: globalOrderID)
        }
        else{
            
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        CommonClass.sharedInstance.chatScreenIsOpen = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        
       // socketManager.defaultSocket.disconnect()
    }
    
    
    func updateLocationSetup(){
        
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
      //  self.locationManager.allowsBackgroundLocationUpdates = true
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.distanceFilter = 10.0
        self.locationManager.pausesLocationUpdatesAutomatically = true
        
        self.locationManager.startUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()
        
    }
    
    
    @objc func sendToPastDashboardOfNormalDelivery(){
                
        let vc = ScreenManager.getSuccessfullDeliveredPopupVC()
        vc.controllerPurpuse = "NormalDelivery"
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func sendToPastDashboardOfNormalProfessional(){
                
        let vc = ScreenManager.getSuccessfullDeliveredPopupVC()
        vc.controllerPurpuse = "NormalProfessional"
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @objc func presentPopupInCaseOfWithdrawByDelivery(){
        
        let vc = ScreenManager.getNormalUserGettingRequestForWithdrawVC()
        vc.controllerPurpuse = self.isComing
        vc.orderId = self.globalOrderID
        vc.nabObj = self
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func presentPopupInCaseOfWithdrawByProfessional(){
        
        let vc = ScreenManager.getNormalUserGettingRequestForWithdrawVC()
        vc.controllerPurpuse = self.isComing
        vc.orderId = self.globalOrderID
        vc.nabObj = self
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @objc func withdrawRequestAcceptedByNormalDelivery(){
        
        UserDefaults.standard.set(true, forKey: "RootApply")
        
        let vc = ScreenManager.getDeliveryPersonScrollManagerVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @objc func withdrawRequestAcceptedByNormalProfessional(){
        
        UserDefaults.standard.set(true, forKey: "RootApplyForProfessional")
        
        let vc = ScreenManager.getProfessionalWorkerScrollManagerVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        self.appDelegate.window?.rootViewController = navController
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func tap_trackingDone(_ sender: Any) {
        
        if isComing == "DeliveryWorker"{
            
            tap_workingDone()
        }
        else if isComing == "ProfessionalWorker"{
            
            //call here work done api for professional worker. working done by professional worker
            
            tap_workingDoneByProfessionalWorker()
        }
        else{
            
            
        }
        
    }
    
    @IBAction func tap_trackingArrived(_ sender: Any) {
        
        if isComing == "DeliveryWorker" || isComing == "ProfessionalWorker"{
            
            if isComing == "DeliveryWorker"{
                
                //here we are using arrived button as create invoice for delivery flow
                
                let invoiceStatus = deliveryTrackingDict.object(forKey: "invoiceStatus") as? String ?? ""
                
                if invoiceStatus == "false"{
                    
                    let deliveryOffer = userOrderInfo.object(forKey: "deliveryOffer") as? String ?? ""
                    
                    let tax = userOrderInfo.object(forKey: "tax") as? String ?? ""
                    
                    let vc = ScreenManager.getCreateInvoiceVC()
                    
                    vc.orderId = globalOrderID
                    vc.userType = "DeliveryWorker"
                    vc.controllerPurpuse = ""
                    
                    vc.deliveryCost = deliveryOffer
                    vc.tax = tax
                    
                    vc.delegate = self
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            }
            else{
                
                // In case of professional no change in UI
                
                self.apiCallForArrived(orderId: self.globalOrderID)
            }
            
        }
        else{
            
            
        }
        
    }
    
    @IBAction func tap_trackingCreateInvoice(_ sender: Any) {
        
        if isComing == "DeliveryWorker" || isComing == "ProfessionalWorker"{
            
            if isComing == "DeliveryWorker"{
                
                //In case of delivery we are using this button as arrived
                
                self.apiCallForArrived(orderId: self.globalOrderID)
                
            }
            else{
                
                //in case of professional no change
                
                let invoiceStatus = deliveryTrackingDict.object(forKey: "invoiceStatus") as? String ?? ""
                
                if invoiceStatus == "false"{
                    
                    let deliveryOffer = userOrderInfo.object(forKey: "deliveryOffer") as? String ?? ""
                    
                    let tax = userOrderInfo.object(forKey: "tax") as? String ?? ""
                    
                    let vc = ScreenManager.getCreateInvoiceVC()
                    
                    vc.orderId = globalOrderID
                    vc.userType = "DeliveryWorker"
                    vc.controllerPurpuse = ""
                    
                    vc.deliveryCost = deliveryOffer
                    vc.tax = tax
                    
                    vc.delegate = self
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
            
        }
        else{
            
            
        }
        
    }
    
    @IBAction func tap_trackingGo(_ sender: Any) {
        
        if isComing == "DeliveryWorker" || isComing == "ProfessionalWorker"{
            
            let goStatus = deliveryTrackingDict.object(forKey: "goStatus") as? String ?? ""
            if goStatus == "false"{
                
                self.apiCallForGoStatus(orderID: globalOrderID)
            }
            else{
                
                //edit invoice here
                
                let invoiceStatus = deliveryTrackingDict.object(forKey: "invoiceStatus") as? String ?? ""
                
                if invoiceStatus == "true"{
                    
                    let deliveryOffer = userOrderInfo.object(forKey: "deliveryOffer") as? String ?? ""
                    
                    let tax = userOrderInfo.object(forKey: "tax") as? String ?? ""
                    
                    let vc = ScreenManager.getCreateInvoiceVC()
                    
                    vc.orderId = globalOrderID
                    vc.userType = "DeliveryWorker"
                    vc.controllerPurpuse = "Edit"
                    
                    vc.deliveryCost = deliveryOffer
                    vc.tax = tax
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            }
        }
        else{
            
            //normal user can view invoice created by delivery person.
            
            let invoiceStatus = normalWithDeliveryDict.object(forKey: "invoiceStatus") as? String ?? ""
            if invoiceStatus == "false"{
                
            }
            else{
                
                //review invoice url get here
                
                let invoicePdfUrl = normalWithDeliveryDict.object(forKey: "invoicePdf") as? String ?? ""
                
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
        
    }
    
    
    
    @IBAction func tap_trackBtn(_ sender: Any) {
//
//        let vc = ScreenManager.getTackDistanceVCViewController()
//
//        // TackDistanceVCViewController
//
//        vc.latM = longitudeT
//        vc.langM = latitudeT
//        vc.userLatitude = selfCurrentLatT
//        vc.userLongitude = selfCurrentLongT
//
//        print("selfCurrentLatT /selfCurrentLongT /latitudeT /longitudeT",selfCurrentLatT , selfCurrentLongT ,latitudeT ,longitudeT)
//        self.navigationController?.pushViewController(vc, animated: true)
      
        
        
//        if isComing == "DeliveryWorker"{
//
//            let vc = ScreenManager.getDeliveryDetailOnMapVC()
//
//            vc.dataDict = self.userOrderInfo
//
//            vc.controllerPurpuse = "TrackingDelivierySide"
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        else if isComing == "NormalDelivery"{
//
//            let vc = ScreenManager.getActiveOrderTrackingVC()
//
//            vc.isComing = "NormalDelivery"
//            vc.trackingDict = self.normalWithDeliveryDict
//            vc.globalOrderId = self.globalOrderID
//            vc.dict = self.userOrderInfo
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        else if isComing == "ProfessionalWorker"{
//
//            let vc = ScreenManager.getDeliveryDetailOnMapVC()
//
//            vc.dataDict = self.userOrderInfo
//
//            vc.controllerInfoForm = "ProfessionalFlow"
//            vc.controllerPurpuse = "TrackingProfessionalSide"
//
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }
//        else{
//
//            //normal professional
//
//            let vc = ScreenManager.getActiveOrderTrackingVC()
//
//            vc.isComing = "NormalProfessional"
//            vc.trackingDict = self.normalWithDeliveryDict
//            vc.globalOrderId = self.globalOrderID
//            vc.dict = self.userOrderInfo
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    @IBAction func tap_callBtn(_ sender: Any) {
        
        var phoneNo = ""
        
        if isComing == "DeliveryWorker" || isComing == "ProfessionalWorker"{
            
            let countryCode = userOrderInfo.object(forKey: "offerAcceptedByCountryCode") as? String ?? ""
            
            let mob = userOrderInfo.object(forKey: "offerAcceptedByMobileNumber") as? String ?? ""
            
            phoneNo = "\(countryCode)\(mob)"
        }
        else{
            
            let countryCode = userOrderInfo.object(forKey: "offerAcceptedOfCountryCode") as? String ?? ""
            
            let mob = userOrderInfo.object(forKey: "offerAcceptedOfMobileNumber") as? String ?? ""
            
            phoneNo = "\(countryCode)\(mob)"
        }
        
        if let phoneCallURL:URL = URL(string: "tel://\(phoneNo)"){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(phoneCallURL)
            }
        }
        
    }
    
    
    
    @IBAction func tap_sendMessageBtn(_ sender: Any) {
        
        if self.txtViewMsg.text != "" && self.txtViewMsg.text != "Type here"{
            
            self.socket.emit("message", ["roomId":self.roomID,"senderId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","receiverId":self.receiverID,"message":self.txtViewMsg.text!,"messageType":"Text","profilePic":UserDefaults.standard.value(forKey: "ProfilePicForChatUse") as? String ?? ""])
        }
    }
    
    
    @IBAction func tap_attachmentBtn(_ sender: Any) {
        
        
        if isComing == "DeliveryWorker" || isComing == "ProfessionalWorker"{
            
            let invoiceStatus = self.deliveryTrackingDict.object(forKey: "invoiceStatus") as? String ?? "false"
            
            let vc = ScreenManager.getAdditionalChatAlertVC()
            
            vc.delegate = self
            
            if invoiceStatus == "true"{
                
                vc.invoiceBool = true
            }
            else{
                
                vc.invoiceBool = false
            }
            
            vc.controllerUsingFor = isComing
            
            self.present(vc, animated: true, completion: nil)
        }
        else if isComing == "NormalDelivery"{
            
            let vc = ScreenManager.getChatAdditionalFeatureVC()
            
            vc.delegate = self
            
            self.present(vc, animated: true, completion: nil)
            
        }
        else{
            
            //normal user with professional worker
            
            let vc = ScreenManager.getChatAdditionalFeatureVC()
            
            vc.delegate = self
            
            vc.controllerUsingFor = self.isComing
            
            self.present(vc, animated: true, completion: nil)
            
            
//            let alert = UIAlertController()
//
//            alert.addAction(UIAlertAction(title: "Choose Photo", style: .default , handler:{ (UIAlertAction)in
//
//                self.openImagePicker()
//
//            }))
//
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
//
//            }))
//
//            self.present(alert, animated: true, completion: {
//
//            })
            
        }
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.view.frame.size.height -= keyboardSize.height
            self.view.frame.origin.y = self.yCordinateOfView
            self.view.layoutIfNeeded()
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            print(keyboardSize)
            
            self.view.frame.size.height = self.globalHeight
            self.view.frame.origin.y = self.yCordinateOfView
            self.view.layoutIfNeeded()
            
        }
    }
    
    @objc func trackOrderForNormal(){
        
        self.apiCallForGetTrackingTrackingNormalUser(orderId: globalOrderID)
    }
    
    @objc func updateChatForNormalWhenActionTakenByDeliveryWorker(){
        
        self.apiCallForGetChatHistory()
    }
    
 
    @objc func updateChatForNormalWhenActionTakenByProfessionalWorker(){
        
        self.apiCallForGetChatHistory()
    }
    
}


//MARK: - Extension User Defined Methods
extension MessagesVC{
 
    func initialSetup(){
       
        tblViewMessages.tableFooterView = UIView()
        
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height/2
        imgProfile.clipsToBounds = true
        
        let orderId = userOrderInfo.object(forKey: "orderNumber") as? String ?? ""
        self.lblOrderId.text = "Order ID".localized()+" : \(orderId)"
        
        if isComing == "DeliveryWorker" || isComing == "NormalDelivery" || isComing == "ProfessionalWorker" || isComing == "NormalProfessional"{
            
            headerView.isHidden = false
            tableviewTopConstraint.constant = 205
            
            if isComing == "DeliveryWorker" || isComing == "NormalDelivery"{
                
                //set location for delivery flow
                
                let currentToPickupLocation = userOrderInfo.object(forKey: "currentToPicupLocation") as? String ?? ""
                let pickupToDropLocation = userOrderInfo.object(forKey: "pickupToDropLocation") as? String ?? ""
                
                self.lblStartToPickupLocation.text = "\(currentToPickupLocation)KM"
                self.lblPickupToDropoffLocation.text = "\(pickupToDropLocation)KM"
            }
            else{
                
                lblStart.text = "Start".localized()
                lblPickup.text = "DropOff".localized()
                lblDropof.text = "Professional Working".localized()
                lblDelivered.text = "Delivered".localized()
                
                //set location for professional flow
                
                var currentToPickupLocation = ""
                
                if isComing == "ProfessionalWorker"{
                    
                    currentToPickupLocation = userOrderInfo.object(forKey: "currentToDrLocation") as? String ?? ""
                }
                else{
                    
                    currentToPickupLocation = userOrderInfo.object(forKey: "currentToPicupLocation") as? String ?? ""
                }
                
                self.lblStartToPickupLocation.text = "\(currentToPickupLocation)KM"
                
                self.lblPickupToDropoffLocation.text = "0.0 KM"
                
            }
          
            
            if isComing == "DeliveryWorker" || isComing == "ProfessionalWorker"{
                
                self.lblName.text = userOrderInfo.object(forKey: "offerAcceptedByName") as? String ?? ""
                
                self.lblAvgRating.text = "\(userOrderInfo.object(forKey: "AvgRating") as? Double ?? 0.0)"
                
                let imgStr = userOrderInfo.object(forKey: "offerAcceptedByProfilePic") as? String ?? ""
                if imgStr == ""{
                    
                   self.imgProfile.image = UIImage(named: "profileDefault")
                }
                else{
                    
                    let urlStr = URL(string: imgStr)
                    self.imgProfile.setImageWith(urlStr!, placeholderImage: UIImage(named: "profileDefault"))
                }
                                
                self.lblDeliveryCost.text = "Service Cost \(userOrderInfo.object(forKey: "deliveryOffer") as? String ?? "") \(currency)"
                
            }
            else{
                
                self.lblAvgRating.text = "\(userOrderInfo.object(forKey: "AvgRating") as? Double ?? 0.0)"
                
                self.lblName.text = userOrderInfo.object(forKey: "offerAcceptedOfName") as? String ?? ""
                
                let imgStr = userOrderInfo.object(forKey: "offerAcceptedOfProfilePic") as? String ?? ""
                if imgStr == ""{
                    
                   imgProfile.image = UIImage(named: "profileDefault")
                }
                else{
                    
                    let urlStr = URL(string: imgStr)
                    imgProfile.setImageWith(urlStr!, placeholderImage: UIImage(named: "profileDefault"))
                }
                
                self.lblDeliveryCost.text = "Service Cost".localized()+" \(userOrderInfo.object(forKey: "minimumOffer") as? String ?? "") \(currency)"
                
                
            }
            
        }
        else{
            
            headerView.isHidden = true
            tableviewTopConstraint.constant = 0
        }
        
        txtViewMsg.text = "Type here".localized()
        txtViewMsg.delegate = self
        
        CommonClass.sharedInstance.chatScreenIsOpen = true
        
        self.imagePicker.delegate = self
        
        self.apiCallForGetChatHistory()
    }
    
    
    func setscrollPosition(){
        
        if self.chatingArr.count != 0{
            
            let numberOfSections = self.tblViewMessages.numberOfSections
            
            let numberOfRows = self.tblViewMessages.numberOfRows(inSection: numberOfSections-1)
            
            let indexPath = NSIndexPath(row: numberOfRows-1, section: numberOfSections-1)
            
            self.tblViewMessages.scrollToRow(at: indexPath as IndexPath,at: UITableView.ScrollPosition.bottom, animated: true)
            
        }
        
    }
}


//MARK: - Extension TableView Controller
extension MessagesVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatingArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict = chatingArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        let senderId = dict.object(forKey: "senderId") as? String ?? ""
        let messageType = dict.object(forKey: "messageType") as? String ?? ""
        
        let profilePic = dict.object(forKey: "profilePic") as? String ?? ""
        
        let createdTime = dict.object(forKey: "createdAt") as? String ?? ""
        
        if senderId == UserDefaults.standard.value(forKey: "UserID") as? String ?? ""{
            
            if messageType == "Text"{
                
                tblViewMessages.register(UINib(nibName: "RecieverTableViewCellAndXib", bundle: nil), forCellReuseIdentifier: "RecieverTableViewCellAndXib")
                
                let cell = tblViewMessages.dequeueReusableCell(withIdentifier: "RecieverTableViewCellAndXib", for: indexPath) as! RecieverTableViewCellAndXib
                
                let message = dict.object(forKey: "message") as? String ?? ""
                
                cell.lblMessageText.text = message
                
                if profilePic != ""{
                    
                    let urlStr = URL(string: profilePic)
                    cell.imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "profile_default"))
                }
                else{
                    
                    cell.imgUser.image = UIImage(named: "profile_default")
                }
                
                cell.lblTime.text = self.fetchData(dateToConvert: createdTime)
                
                cell.selectionStyle = .none
                return cell
                
            }
            else if messageType == "Location"{
                
                tblViewMessages.register(UINib(nibName: "SenderMediaTableViewCell", bundle: nil), forCellReuseIdentifier: "SenderMediaTableViewCell")
                
                let cell = tblViewMessages.dequeueReusableCell(withIdentifier: "SenderMediaTableViewCell", for: indexPath) as! SenderMediaTableViewCell
                
                if profilePic != ""{
                    
                    let urlStr = URL(string: profilePic)
                    cell.imgSender.setImageWith(urlStr!, placeholderImage: UIImage(named: "profile_default"))
                }
                else{
                    
                    cell.imgSender.image = UIImage(named: "profile_default")
                }
                
                cell.lblTime.text = self.fetchData(dateToConvert: createdTime)
                
                let locationUrl = dict.object(forKey: "message") as? String ?? ""
                
                if locationUrl != ""{
                    
                    let locUrl = URL(string: locationUrl)
                    
                    cell.imgSenderMedia.setImageWith(locUrl!, placeholderImage: UIImage(named: "catImageNew"))
                }
                
                let locationType = dict.object(forKey: "locationType") as? String ?? ""
                if locationType == ""{
                    
                    cell.viewLocationHolder.isHidden = true
                }
                else{
                    
                    cell.viewLocationHolder.isHidden = false
                    cell.lblLocationName.text = "\(locationType) Location".localized()
                }
                
                cell.selectionStyle = .none
                return cell
            }
            else{
                
                tblViewMessages.register(UINib(nibName: "SenderMediaTableViewCell", bundle: nil), forCellReuseIdentifier: "SenderMediaTableViewCell")
                
                let cell = tblViewMessages.dequeueReusableCell(withIdentifier: "SenderMediaTableViewCell", for: indexPath) as! SenderMediaTableViewCell
                
                cell.viewLocationHolder.isHidden = true
                
                if profilePic != ""{
                    
                    let urlStr = URL(string: profilePic)
                    cell.imgSender.setImageWith(urlStr!, placeholderImage: UIImage(named: "profile_default"))
                }
                else{
                    
                    cell.imgSender.image = UIImage(named: "profile_default")
                }
                
                cell.lblTime.text = self.fetchData(dateToConvert: createdTime)
                
                let mediaStr = dict.object(forKey: "media") as? String ?? ""
                if mediaStr != ""{
                    
                    let urlStr = URL(string: mediaStr)
                    cell.imgSenderMedia.setImageWith(urlStr!, placeholderImage: UIImage(named: "catImageNew"))
                }
                
                cell.selectionStyle = .none
                return cell
            }
            
        }
        else{
            
            if messageType == "Text"{
                
                tblViewMessages.register(UINib(nibName: "SenderTableViewCellAndXib", bundle: nil), forCellReuseIdentifier: "SenderTableViewCellAndXib")
                
                let cell = tblViewMessages.dequeueReusableCell(withIdentifier: "SenderTableViewCellAndXib", for: indexPath) as! SenderTableViewCellAndXib
                
                let message = dict.object(forKey: "message") as? String ?? ""
                
                cell.lblMessageText.text = message
                
                if profilePic != ""{
                    
                    let urlStr = URL(string: profilePic)
                    cell.imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "profile_default"))
                }
                else{
                    
                    cell.imgUser.image = UIImage(named: "profile_default")
                }
                
                cell.lblTime.text = self.fetchData(dateToConvert: createdTime)
                
                cell.selectionStyle = .none
                return cell
                
            }
            else if messageType == "Location"{
                
                tblViewMessages.register(UINib(nibName: "ReceiverMediaTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceiverMediaTableViewCell")
                
                let cell = tblViewMessages.dequeueReusableCell(withIdentifier: "ReceiverMediaTableViewCell", for: indexPath) as! ReceiverMediaTableViewCell
                
                if profilePic != ""{
                    
                    let urlStr = URL(string: profilePic)
                    cell.imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "profile_default"))
                }
                else{
                    
                    cell.imgUser.image = UIImage(named: "profile_default")
                }
                
                
                let locationUrl = dict.object(forKey: "message") as? String ?? ""
                
                if locationUrl != ""{
                    
                    let locUrl = URL(string: locationUrl)
                    cell.imgReceiverMedia.setImageWith(locUrl!, placeholderImage: UIImage(named: "catImageNew"))
                }
                
                let locationType = dict.object(forKey: "locationType") as? String ?? ""
                if locationType == ""{
                    
                    cell.viewLocationHolder.isHidden = true
                }
                else{
                    
                    cell.viewLocationHolder.isHidden = false
                    cell.lblLocationName.text = "\(locationType) Location".localized()
                }
                
                cell.lblTime.text = self.fetchData(dateToConvert: createdTime)
                
                cell.selectionStyle = .none
                
                return cell
            }
            else{
                
                tblViewMessages.register(UINib(nibName: "ReceiverMediaTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceiverMediaTableViewCell")
                
                let cell = tblViewMessages.dequeueReusableCell(withIdentifier: "ReceiverMediaTableViewCell", for: indexPath) as! ReceiverMediaTableViewCell
                
                cell.viewLocationHolder.isHidden = true
                
                if profilePic != ""{
                    
                    let urlStr = URL(string: profilePic)
                    cell.imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "profile_default"))
                }
                else{
                    
                    cell.imgUser.image = UIImage(named: "profile_default")
                }
                
                let mediaStr = dict.object(forKey: "media") as? String ?? ""
                if mediaStr != ""{
                    
                    let urlStr = URL(string: mediaStr)
                    cell.imgReceiverMedia.setImageWith(urlStr!, placeholderImage: UIImage(named: "catImageNew"))
                }
                
                cell.lblTime.text = self.fetchData(dateToConvert: createdTime)
                
                cell.selectionStyle = .none
                return cell
                
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableViewAutomaticDimension
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = chatingArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let type = dict.object(forKey: "messageType") as? String ?? ""
        
        if type == "Media"{
            
            let imgStr = dict.object(forKey: "media") as? String ?? ""
            
            let vc = ScreenManager.getLargeImageViewerVC()
            
            vc.imageString = imgStr
            
            self.present(vc, animated: true, completion: nil)
        }
        else if type == "Location"{
            
            let locationURl = dict.object(forKey: "url") as? String ?? ""
            
            guard let url = URL(string: locationURl) else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }
        else{}
        
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


//MARK:- Socket Handling
//MARK:-
extension MessagesVC{
    
    //MARK:- Socket Handling
    
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
            
            if self.forFirstTimeOnly{
                
                self.forFirstTimeOnly = false
                
                self.socket.emit("room join", ["roomId": self.roomID])
                
                //**it is only for tracking purpuse
                
                self.socket.emit("room join", ["roomId": self.roomIdForTracking])
               // self.socket.emit("room join", ["roomId": "5d1a0e06d8a6bc109d07e9665e0346c5aad9456e62935224"])
            }
            
        }
        
        socket.on("room join") { (data, ack) in
            
            print("Room Joined")
            print(data)
            
            let arr = data as NSArray
            
            if arr.count != 0{
                
                let dict = arr.object(at: 0) as? NSDictionary ?? [:]
                
                let status = dict.object(forKey: "status") as? Bool ?? false
                
                if status == false{
                    
                    self.navigationController?.popViewController(animated: true)
                }

            }
        }
        
        
        socket.on("message") { (data, ack) in
            self.imageType = ""
            IJProgressView.shared.hideProgressView()
            print("Message Send Event")
            
            self.txtViewMsg.text = ""
            
            print(data)
            
            let arr = data as NSArray
            
            if arr.count != 0{
                
                let dict = arr.object(at: 0) as? NSDictionary ?? [:]
                
                self.chatingArr.add(dict)
                
                self.tblViewMessages.reloadData()
                
                self.setscrollPosition()
            }
            
        }
        
        
        //******* for upload file using socket
        
        self.socket.on("uploadFileMoreDataReq") { ( dataArray, ack) -> Void in
            IJProgressView.shared.showProgressView(view: self.view)
            print("Put Loader")
            print(dataArray, ack)
            
            let uniqueCode = self.getUniqueCode()
            
            let messageDict =   [["Name" : self.imageName,
                                  "Data" : self.imageData.base64EncodedString(options: .endLineWithLineFeed),
                                  "messageType" : self.imageName.contains(".m4a") ? "Media" : "Media",
                                  "chunkSize" : self.imageData.length,
                                  "room_id" : self.roomID,
                                  "unique_code" : "\(uniqueCode)",
                "sender_id":UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                "receiver_id":self.receiverID,
                "profilePic":UserDefaults.standard.value(forKey: "ProfilePicForChatUse") as? String ?? ""]] as [[String : Any]]
            
            self.socket.emitWithAck("uploadFileChuncks", messageDict).timingOut(after: 0) { data in
                
                IJProgressView.shared.showProgressView(view: self.view)
                print(data)
                
            }
            
            self.socket.on("uploadFileCompleteRes") { ( dataArray, ack) -> Void in
                
                if self.imageType == "Camera"{
                    
                }else{
                    IJProgressView.shared.hideProgressView()
                }
                
                print(dataArray, ack)
                
                let mediaArray = dataArray as NSArray ?? []
                
                print(mediaArray)
                
            }
            
        }
        
        
    }
    
}


//MARK:- Webservices
//MARK:-
extension MessagesVC{
    
    func apiCallForGetChatHistory(){
        
        let param:[String:String] = ["roomId":roomID]
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
        
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetChatHistory as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
             
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    self.chatingArr.removeAllObjects()
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let chatArr = receivedData.object(forKey: "Data1") as? NSArray ?? []
                        
                        self.chatingArr = chatArr.mutableCopy() as! NSMutableArray
                        
                        self.tblViewMessages.reloadData()
                        
                        self.setscrollPosition()
    
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
                    
                    self.navigationController?.popViewController(animated: true)
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
            
        }
    }
    
}


//MARK:- UIText View Delegate
//MARK:-
extension MessagesVC:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if txtViewMsg.text == "Type here".localized(){
            
            txtViewMsg.text = ""
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txtViewMsg.text == ""{
            
            txtViewMsg.text = "Type here".localized()
        }
        
    }
    
}

//MARK:- UIImage Picker Delegate
//MARK:-
extension MessagesVC:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func openImagePicker(){
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        let gallery = UIAlertAction(title: "Gallery".localized(), style: UIAlertAction.Style.default) { (gallery) in
            self.imageType = "Gallery"
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        alert.addAction(gallery)
        
        let camera = UIAlertAction(title: "Camera".localized(), style: UIAlertAction.Style.destructive) { (camera) in
            self.imageType = "Camera"
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        alert.addAction(camera)
        
        let cancel = UIAlertAction(title: "cancel".localized(), style: UIAlertAction.Style.cancel) { (cancel) in
            self.imageType = ""
        }
        
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Image Picker Delegate Function
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //UIImagePickerControllerOriginalImage
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
      
        imageData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
        self.imageName = generateUniqueImageName()
        
        print(imageData.length)
        
        let messageDict = [["Name" : self.imageName,
                            "Size" : self.imageData.length,
                            "room_id" : self.roomID,
                            "sender_id":UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                            "receiver_id":self.receiverID,
                            "profilePic":UserDefaults.standard.value(forKey: "ProfilePicForChatUse") as? String ?? "",
                            "messageType":"Media"]] as [[String : Any]]
        
        self.socket.emitWithAck("uploadFileStart", messageDict).timingOut(after: 0) {data in
            
            print("---->",data)
            IJProgressView.shared.showProgressView(view: self.view)
            
        }
        
        dismiss(animated: true, completion: nil)
        
        tblViewMessages.reloadData()
    }
    
    func generateUniqueImageName() -> String {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        //print("Butterfly_" + formatter.string(from: Date()) + ".jpeg")
        
        return ("sdfdsf" + formatter.string(from: Date()) + ".jpeg")
        
    }
    
    func getUniqueCode() -> String {
        
        let randomNum:UInt32 = arc4random_uniform(10000000)
        
        let uniqueCode = "\(randomNum)\(randomNum)"
        
        print(uniqueCode)
        
        return uniqueCode
    }
    
}


//MARK:- API'S For Tracking
//MARK:-
extension MessagesVC{
    
    func apiCallForGetTrackingTrackingOrderDelivery(orderId:String){
        
        let param:[String:String] = ["orderId":orderId]
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForDeliveryActiveOrderTracking as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let dict = receivedData.object(forKey: "Data") as? NSDictionary ?? [:]
                        
                        self.deliveryTrackingDict = dict
                        
                        if self.isComing == "DeliveryWorker"{
                            
                            self.manageTrackingStatusOfDeliveryWorkerEnhancement(dict: dict)
                        }
                        else{
                            
                            self.manageStatusOfDelivery(dict: dict)
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
                    
                    self.navigationController?.popViewController(animated: true)
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
                
            }
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
    
    
    //************* manage tracking status of Professional worker
    
    func manageStatusOfDelivery(dict:NSDictionary){
        
//        let goStatus = dict.object(forKey: "goStatus") as? String ?? ""
//        if goStatus == "false"{
//
//            btnGo.isHidden = false
//            btnArrived.isHidden = true
//            btnCreateInvoice.isHidden = true
//            btnDone.isHidden = true
//
//            btnGo.setTitleColor(UIColor.green, for: .normal)
//            btnGo.setTitle("GO", for: .normal)
//        }
//        else{
//
//            let invoiceStatus = dict.object(forKey: "invoiceStatus") as? String ?? ""
//
//            if invoiceStatus == "false"{
//
//                btnGo.isHidden = true
//                btnCreateInvoice.isHidden = false
//                btnArrived.isHidden = true
//                btnDone.isHidden = true
//
//                btnCreateInvoice.setTitle("Create invoice", for: .normal)
//            }
//            else{
//
//                btnGo.setTitle("Edit Invoice", for: .normal)
//                btnCreateInvoice.setTitle("Invoice Created", for: .normal)
//
//                let arrivedStatus = dict.object(forKey: "arrivedStatus") as? String ?? ""
//
//                if arrivedStatus == "false"{
//
//                    btnArrived.isHidden = false
//                    btnGo.isHidden = false
//                    btnCreateInvoice.isHidden = false
//                    btnDone.isHidden = true
//                }
//                else{
//
//                    btnArrived.isHidden = true
//                    btnGo.isHidden = false
//                    btnCreateInvoice.isHidden = false
//                    btnDone.isHidden = false
//
//                }
//
//            }
//
//        }
        
        
        //********New Requrement
        
        let goStatus = dict.object(forKey: "goStatus") as? String ?? ""
        if goStatus == "false"{
            
            btnGo.isHidden = false
            btnArrived.isHidden = true
            btnCreateInvoice.isHidden = true
            btnDone.isHidden = true
            
           // btnGo.setTitleColor(UIColor.green, for: .normal)
            btnGo.setTitle("Start", for: .normal)
            btnGo.backgroundColor = UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00)
            btnGo.setTitleColor(UIColor.white, for: .normal)
        }
        else{
            
            let arrivedStatus = dict.object(forKey: "arrivedStatus") as? String ?? ""
            
            if arrivedStatus == "false"{
                
                btnGo.isHidden = true
                btnArrived.isHidden = false
                btnCreateInvoice.isHidden = true
                btnDone.isHidden = true
                
                btnArrived.setTitle("Arrived", for: .normal)
                
            }
            else{
                
                let invoiceStatus = dict.object(forKey: "invoiceStatus") as? String ?? ""
                
                if invoiceStatus == "false"{
                    
                    btnGo.isHidden = true
                    btnArrived.isHidden = true
                    btnCreateInvoice.isHidden = false
                    btnDone.isHidden = false
                    
                    btnCreateInvoice.setTitle("Create invoice", for: .normal)
                }
                else{
                    
                    btnGo.setTitle("Edit Invoice", for: .normal)
                    btnCreateInvoice.setTitle("Invoice Created".localized(), for: .normal)
                    
                    btnGo.isHidden = false
                    btnArrived.isHidden = true
                    btnCreateInvoice.isHidden = false
                    btnDone.isHidden = false
                    
                    btnCreateInvoice.backgroundColor = UIColor.clear
                    btnCreateInvoice.setTitleColor(UIColor.green, for: .normal)
                    
                }
            }
            
        }
        
    }
    
    
    //******* Manage Tracking Status of delivery worker new enhancement
    
    func manageTrackingStatusOfDeliveryWorkerEnhancement(dict:NSDictionary){
        
        //in this scnario we will use btn arived as create invoice and btn create invoice as arrived.
        
        let goStatus = dict.object(forKey: "goStatus") as? String ?? ""
        if goStatus == "false"{
            
            btnGo.isHidden = false
            btnArrived.isHidden = true
            btnCreateInvoice.isHidden = true
            btnDone.isHidden = true
            
            btnGo.setTitle("Start", for: .normal)
            btnGo.backgroundColor = UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00)
            btnGo.setTitleColor(UIColor.white, for: .normal)
        }
        else{
            
            let invoiceStatus = dict.object(forKey: "invoiceStatus") as? String ?? ""
            let arrivedStatus = dict.object(forKey: "arrivedStatus") as? String ?? ""
            
            if arrivedStatus == "false" && invoiceStatus == "false"{
                
                btnGo.isHidden = true
                btnArrived.setTitle("Create Invoice", for: .normal)
                btnCreateInvoice.setTitle("Arrived", for: .normal)
                
                btnArrived.isHidden = false
                btnCreateInvoice.isHidden = false
                btnDone.isHidden = true
                
            }
            else if arrivedStatus == "true" && invoiceStatus == "true"{
                
                btnGo.setTitle("Edit Invoice", for: .normal)
                btnArrived.setTitle("Invoice Created".localized(), for: .normal)
                
                btnGo.isHidden = false
                btnArrived.isHidden = false
                btnCreateInvoice.isHidden = true
                btnDone.isHidden = false
                
                btnArrived.backgroundColor = UIColor.clear
                btnArrived.setTitleColor(UIColor.green, for: .normal)
                
            }
            else if arrivedStatus == "false" && invoiceStatus == "true"{
                
                btnGo.setTitle("Edit Invoice", for: .normal)
                btnArrived.setTitle("Invoice Created".localized(), for: .normal)
                btnGo.isHidden = false
                btnArrived.isHidden = false
                
                btnCreateInvoice.setTitle("Arrived", for: .normal)
                btnCreateInvoice.isHidden = false
                
                btnArrived.backgroundColor = UIColor.clear
                btnArrived.setTitleColor(UIColor.green, for: .normal)
                
            }
            else if arrivedStatus == "true" && invoiceStatus == "false"{
                
                btnGo.isHidden = true
                btnArrived.setTitle("Create Invoice", for: .normal)
                btnArrived.isHidden = false
                
                btnCreateInvoice.isHidden = true
                btnDone.isHidden = false
                
            }
            else{
                
                
            }
        }
    }
    
    
    //******** Api for Arrived delivery side
    
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
                        
                        self.apiCallForGetTrackingTrackingOrderDelivery(orderId: self.globalOrderID)
                        
                        self.apiCallForGetChatHistory()
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
    
    
    //******* Api for go delivery side
    
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
                        
                        self.apiCallForGetTrackingTrackingOrderDelivery(orderId: self.globalOrderID)
                        
                        self.apiCallForGetChatHistory()
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


//MARK:- Normal User Tracking Status
//MARK:-
extension MessagesVC{
    
    func apiCallForGetTrackingTrackingNormalUser(orderId:String){
        
        let param:[String:String] = ["orderId":orderId]
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForNormalActiveOrderTracking as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let dict = receivedData.object(forKey: "Data") as? NSDictionary ?? [:]
                        
                        self.normalWithDeliveryDict = dict
                        
                        if self.isComing == "NormalDelivery"{
                            
                         self.manageTrackingStatusInCaseOfNormalUserRequiredDelivery(dict: dict)
                        }
                        else{
                            
                            self.manageTrackingStatusOfNormal(dict: dict)
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
                    
                    self.navigationController?.popViewController(animated: true)
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
                
            }
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
    
    
    //****** Managing normal user status
    
    func manageTrackingStatusOfNormal(dict:NSDictionary){
        
//        btnCreateInvoice.setTitle("Invoice Created", for: .normal)
//
//        let goStatus = dict.object(forKey: "goStatus") as? String ?? ""
//        if goStatus == "false"{
//
//            btnGo.isHidden = true
//            btnCreateInvoice.isHidden = true
//            btnArrived.isHidden = true
//            btnDone.isHidden = true
//
//            viewTrack.isHidden = true
//
//        }
//        else{
//
//            viewTrack.isHidden = false
//
//            let invoiceStatus = dict.object(forKey: "invoiceStatus") as? String ?? ""
//            if invoiceStatus == "false"{
//
//                btnGo.isHidden = false
//                btnCreateInvoice.isHidden = true
//                btnArrived.isHidden = true
//                btnDone.isHidden = true
//
//                btnGo.setTitle("GO", for: .normal)
//                btnGo.setTitleColor(UIColor.green, for: .normal)
//            }
//            else{
//
//                btnGo.setTitle("Review Invoice", for: .normal)
//                btnGo.setTitleColor(UIColor.purple, for: .normal)
//
//                btnGo.isHidden = false
//                btnCreateInvoice.isHidden = false
//
//                let arrivedStatus = dict.object(forKey: "arrivedStatus") as? String ?? ""
//                if arrivedStatus == "false"{
//
//                    btnArrived.isHidden = true
//                    btnDone.isHidden = true
//                }
//                else{
//
//                   btnArrived.isHidden = false
//
//                    let doneStatus = dict.object(forKey: "workDoneStatus") as? String ?? ""
//                    if doneStatus == "false"{
//
//                        btnDone.isHidden = true
//                    }
//                    else{
//
//                        btnDone.isHidden = false
//                    }
//
//                }
//
//            }
//
//        }
        
        
        //********New Requirement
        
        btnCreateInvoice.setTitle("Invoice Created".localized(), for: .normal)
        
        let goStatus = dict.object(forKey: "goStatus") as? String ?? ""
        if goStatus == "false"{
            
            btnGo.isHidden = true
            btnArrived.isHidden = true
            btnCreateInvoice.isHidden = true
            btnDone.isHidden = true
            
            viewTrack.isHidden = true
        }
        else{
            viewTrack.isHidden = true
           // viewTrack.isHidden = false
            
            let arrivedStatus = dict.object(forKey: "arrivedStatus") as? String ?? ""
            
            if arrivedStatus == "false"{
                
                btnGo.isHidden = false
                btnArrived.isHidden = true
                btnCreateInvoice.isHidden = true
                btnDone.isHidden = true
                
                btnGo.setTitle("Start".localized(), for: .normal)
                btnGo.setTitleColor(UIColor.green, for: .normal)
                
            }
            else{
                
                let invoiceStatus = dict.object(forKey: "invoiceStatus") as? String ?? ""
                if invoiceStatus == "false"{
                    
                    btnGo.isHidden = true
                    btnArrived.isHidden = false
                    btnCreateInvoice.isHidden = true
                    btnDone.isHidden = true
                    
                    btnArrived.backgroundColor = UIColor.clear
                    btnArrived.setTitleColor(UIColor.green, for: .normal)
                    btnArrived.setTitle("Arrived".localized(), for: .normal)
                    
                }
                else{
                    
                    btnGo.isHidden = false
                    btnArrived.isHidden = false
                    btnCreateInvoice.isHidden = false
                    btnDone.isHidden = true
                    
                    btnGo.setTitle("Review Invoice".localized(), for: .normal)
                    btnGo.setTitleColor(UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00), for: .normal)
                    btnArrived.backgroundColor = UIColor.clear
                    btnArrived.setTitleColor(UIColor.green, for: .normal)
                    btnArrived.setTitle("Arrived".localized(), for: .normal)
                    btnCreateInvoice.backgroundColor = UIColor.clear
                    btnCreateInvoice.setTitleColor(UIColor.green, for: .normal)
                }
                
            }
            
        }
        
    }
    
    
    func manageTrackingStatusInCaseOfNormalUserRequiredDelivery(dict:NSDictionary){
        
        let goStatus = dict.object(forKey: "goStatus") as? String ?? ""
        if goStatus == "false"{
            
            btnGo.isHidden = true
            btnArrived.isHidden = true
            btnCreateInvoice.isHidden = true
            btnDone.isHidden = true
            
            viewTrack.isHidden = true
        }
        else{
            
            viewTrack.isHidden = false
            
            let arrivedStatus = dict.object(forKey: "arrivedStatus") as? String ?? ""
            let invoiceStatus = dict.object(forKey: "invoiceStatus") as? String ?? ""
            
            if arrivedStatus == "false" && invoiceStatus == "false"{
                
                btnGo.isHidden = false
                btnArrived.isHidden = true
                btnCreateInvoice.isHidden = true
                btnDone.isHidden = true
                
                btnGo.setTitle("Start", for: .normal)
                btnGo.setTitleColor(UIColor.green, for: .normal)
            }
            else if arrivedStatus == "true" && invoiceStatus == "true"{
                
                btnGo.isHidden = false
                btnArrived.isHidden = false
                btnCreateInvoice.isHidden = false
                btnDone.isHidden = true
                
                btnGo.setTitle("Review Invoice", for: .normal)
                btnGo.setTitleColor(UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00), for: .normal)
                
                btnArrived.setTitle("Invoice Created".localized(), for: .normal)
                btnArrived.backgroundColor = UIColor.clear
                btnArrived.setTitleColor(UIColor.green, for: .normal)
                
                btnCreateInvoice.setTitle("Arrived", for: .normal)
                btnCreateInvoice.backgroundColor = UIColor.clear
                btnCreateInvoice.setTitleColor(UIColor.green, for: .normal)
                
            }
            else if arrivedStatus == "true" && invoiceStatus == "false"{
                
                btnGo.isHidden = true
                btnCreateInvoice.isHidden = false
                btnArrived.isHidden = true
                btnDone.isHidden = true
                
                btnCreateInvoice.setTitle("Arrived", for: .normal)
                btnCreateInvoice.backgroundColor = UIColor.clear
                btnCreateInvoice.setTitleColor(UIColor.green, for: .normal)
                
            }
            else if arrivedStatus == "false" && invoiceStatus == "true"{
                
                btnGo.isHidden = false
                btnArrived.isHidden = false
                btnCreateInvoice.isHidden = true
                btnDone.isHidden = true
                
                btnGo.setTitle("Review Invoice", for: .normal)
                btnGo.setTitleColor(UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00), for: .normal)
                btnArrived.setTitle("Invoice Created".localized(), for: .normal)
                btnArrived.backgroundColor = UIColor.clear
                btnArrived.setTitleColor(UIColor.green, for: .normal)
            }
            
        }
        
    }
    
}



//MARK:- Work Done Flow
//MARK:-
extension MessagesVC{
    
    func tap_workingDone(){
        
        let orderId = userOrderInfo.object(forKey: "_id") as? String ?? ""
        
        let anotherUserId = userOrderInfo.object(forKey: "offerAcceptedById") as? String ?? ""
        
        self.apiCallForWorkDone(orderId: orderId, anotherUserId: anotherUserId)
    }
    
    
    func tap_workingDoneByProfessionalWorker(){
        
        let orderId = userOrderInfo.object(forKey: "_id") as? String ?? ""
        
        let anotherUserId = userOrderInfo.object(forKey: "offerAcceptedById") as? String ?? ""
        
        self.apiCallForWorkDoneByProfessionalWorker(orderId: orderId, anotherUserId: anotherUserId)
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
                        
                        let vc = ScreenManager.getSuccessfullDeliverDeliverySideVC()
                        
                        vc.navObj = self
                        vc.orderId = orderId
                        vc.ratingToUserId = anotherUserId
                        
                        vc.controllerUserType = ""
                        
                        self.present(vc, animated: true, completion: nil)
                        
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
    
    
    ////func api call for work done by professional worker
    
    func apiCallForWorkDoneByProfessionalWorker(orderId:String,anotherUserId:String){
        
        let param:[String:String] = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","orderId":orderId]
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForWorkDoneByProfessionalWorker as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdatePastListProfessionalWorker"), object: nil)
                        
                        let vc = ScreenManager.getSuccessfullDeliverDeliverySideVC()
                        
                        vc.navObj = self
                        vc.orderId = orderId
                        vc.ratingToUserId = anotherUserId
                        
                        vc.controllerUserType = "Professional"
                        
                        self.present(vc, animated: true, completion: nil)
                        
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
    
    
    //Hit api only for get profile picture for three types of users
    
    func apiCallForGetUserType(){
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            if CommonClass.sharedInstance.isConnectedToNetwork(){
                
                let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
                
                IJProgressView.shared.showProgressView(view: self.view)
                
                self.connection.startConnectionWithSting(App.URLs.apiCallForGetUserType as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                    
                    IJProgressView.shared.hideProgressView()
                    
                    print(receivedData)
                    
                    if self.connection.responseCode == 1{
                        
                        let status = receivedData.object(forKey: "status") as? String ?? ""
                        if status == "SUCCESS"{
                            
                            var profilePic = ""
                            
                            if self.isComing == "DeliveryWorker"{
                                
                                profilePic = receivedData.object(forKey: "deliveryProfile") as? String ?? ""
                            }
                            else if self.isComing == "NormalDelivery" || self.isComing == "NormalProfessional"{
                                
                                profilePic = receivedData.object(forKey: "profilePic") as? String ?? ""
                            }
                            else if self.isComing == "ProfessionalWorker"{
                                
                                profilePic = receivedData.object(forKey: "professionalProfile") as? String ?? ""
                                
                            }
                            
                            UserDefaults.standard.set(profilePic, forKey: "ProfilePicForChatUse")
                            
                        }
                        else{
                            
                            let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                            
                            if msg == "Invalid Token"{
                                
                                CommonClass.sharedInstance.redirectToHome()
                            }
                            else{
                                
                               
                            }
                        }
                    }
                    else{
                        
                    }
                }
            }
            else{
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
            }
        }
        
    }
    
}


//MARK:- Chat Additional Feature delegate
//MARK:-
extension MessagesVC:ChatAdditionalFeatureNormalUserDelegate{
    
    func chatAdditionalFeatureOfNormalDelegate(type: String) {
        
        if type == "ShareImage"{
            
            self.txtViewMsg.text = "Type here".localized()
            self.txtViewMsg.resignFirstResponder()
            
            let alert = UIAlertController()
            
            alert.addAction(UIAlertAction(title: "Choose Photo".localized(), style: .default , handler:{ (UIAlertAction)in
                
                self.openImagePicker()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler:{ (UIAlertAction)in
                
            }))
            
            self.present(alert, animated: true, completion: {
                
            })
        }
        else if type == "ShareLocation"{
            
            self.txtViewMsg.text = "Type here".localized()
            self.txtViewMsg.resignFirstResponder()
            
            let vc = ScreenManager.getShareLiveLocationPouupVC()
            
            vc.delegate = self
            
            self.present(vc, animated: true, completion: nil)
            
        }
        else if type == "ContactAdmin"{
            
            let vc = ScreenManager.getCancellationVC()
            vc.controllerPurpuse = "ContactAdmin"
            vc.reportOrder = "Report"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if type == "ChangeDeliveryCaptain"{
            
            let vc = ScreenManager.getChangeDeliveryPersonPouupVC()
            
            vc.nabObj = self
            vc.orderID = self.globalOrderID
            
            vc.controllerUsingFor = self.isComing
            
            self.present(vc, animated: true, completion: nil)
        }
        else if type == "CancelOrder"{
            
            let vc = ScreenManager.getDeleteOfferPopupVC()
            vc.orderID = self.globalOrderID
            self.present(vc, animated: true, completion: nil)
        }
        else{
            
            
        }
    }

}

//MARK:- Chat Additional Feature Delivery Side delegate
//MARK:-
extension MessagesVC:DeliveryChatAdditionalFeatureDelegate{
    
    func additionalChatFeatureDeliveryWorker(type: String) {
        
        if type == "GoodsDelivered"{
            
            if isComing == "DeliveryWorker"{
                
                self.tap_workingDone()
            }
            else{
                
                self.tap_workingDoneByProfessionalWorker()
            }
            
        }
        else if type == "ShareImage"{
            
            self.txtViewMsg.text = "Type here"
            self.txtViewMsg.resignFirstResponder()
            
            let alert = UIAlertController()
            
            alert.addAction(UIAlertAction(title: "Choose Photo", style: .default , handler:{ (UIAlertAction)in
                
                self.openImagePicker()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
                
            }))
            
            self.present(alert, animated: true, completion: {
                
            })
            
        }
        else if type == "IssueBill"{
            
            if isComing == "DeliveryWorker"{
                
                let invoiceStatus = deliveryTrackingDict.object(forKey: "invoiceStatus") as? String ?? ""
                
                let goStatus = deliveryTrackingDict.object(forKey: "goStatus") as? String ?? ""
                
                if invoiceStatus == "false" && goStatus == "true"{
                    
                    let deliveryOffer = userOrderInfo.object(forKey: "deliveryOffer") as? String ?? ""
                    
                    let tax = userOrderInfo.object(forKey: "tax") as? String ?? ""
                    
                    let vc = ScreenManager.getCreateInvoiceVC()
                    
                    vc.orderId = globalOrderID
                    vc.userType = "DeliveryWorker"
                    vc.controllerPurpuse = ""
                    
                    vc.deliveryCost = deliveryOffer
                    vc.tax = tax
                    
                    vc.delegate = self
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                else if invoiceStatus == "false" && goStatus == "false"{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not create invoice right now. First you need to start the order.", controller: self)
                }
                else{
                    
                    // for update invoice
                    
                    let deliveryOffer = userOrderInfo.object(forKey: "deliveryOffer") as? String ?? ""
                    
                    let tax = userOrderInfo.object(forKey: "tax") as? String ?? ""
                    
                    let vc = ScreenManager.getCreateInvoiceVC()
                    
                    vc.orderId = globalOrderID
                    vc.userType = "DeliveryWorker"
                    vc.controllerPurpuse = "Edit"
                    
                    vc.deliveryCost = deliveryOffer
                    vc.tax = tax
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
            else{
                
                //professional worker
                
                let invoiceStatus = deliveryTrackingDict.object(forKey: "invoiceStatus") as? String ?? ""
                
                let goStatus = deliveryTrackingDict.object(forKey: "goStatus") as? String ?? ""
                
                let arrivedStatus = deliveryTrackingDict.object(forKey: "arrivedStatus") as? String ?? ""
                
                if arrivedStatus == "false" && goStatus == "false"{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not create invoice right now. First you need to start the order.", controller: self)
                }
                else if goStatus == "true" && arrivedStatus == "false"{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not create invoice right now. First you need to arrived", controller: self)
                }
                else{
                    
                    if invoiceStatus == "false"{
                        
                        let deliveryOffer = userOrderInfo.object(forKey: "deliveryOffer") as? String ?? ""
                        
                        let tax = userOrderInfo.object(forKey: "tax") as? String ?? ""
                        
                        let vc = ScreenManager.getCreateInvoiceVC()
                        
                        vc.orderId = globalOrderID
                        vc.userType = "DeliveryWorker"
                        vc.controllerPurpuse = ""
                        
                        vc.deliveryCost = deliveryOffer
                        vc.tax = tax
                        
                        vc.delegate = self
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else{
                        
                        // for update invoice
                        
                        let deliveryOffer = userOrderInfo.object(forKey: "deliveryOffer") as? String ?? ""
                        
                        let tax = userOrderInfo.object(forKey: "tax") as? String ?? ""
                        
                        let vc = ScreenManager.getCreateInvoiceVC()
                        
                        vc.orderId = globalOrderID
                        vc.userType = "DeliveryWorker"
                        vc.controllerPurpuse = "Edit"
                        
                        vc.deliveryCost = deliveryOffer
                        vc.tax = tax
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
//                if invoiceStatus == "false" && goStatus == "true"{
//
//                    let deliveryOffer = userOrderInfo.object(forKey: "deliveryOffer") as? String ?? ""
//
//                    let tax = userOrderInfo.object(forKey: "tax") as? String ?? ""
//
//                    let vc = ScreenManager.getCreateInvoiceVC()
//
//                    vc.orderId = globalOrderID
//                    vc.userType = "DeliveryWorker"
//                    vc.controllerPurpuse = ""
//
//                    vc.deliveryCost = deliveryOffer
//                    vc.tax = tax
//
//                    vc.delegate = self
//
//                    self.navigationController?.pushViewController(vc, animated: true)
//
//                }
//                else if invoiceStatus == "false" && goStatus == "false"{
//
//                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "You can not create invoice right now. First you need to start the order.", controller: self)
//                }
//                else{
//
//                    // for update invoice
//
//                    let deliveryOffer = userOrderInfo.object(forKey: "deliveryOffer") as? String ?? ""
//
//                    let tax = userOrderInfo.object(forKey: "tax") as? String ?? ""
//
//                    let vc = ScreenManager.getCreateInvoiceVC()
//
//                    vc.orderId = globalOrderID
//                    vc.userType = "DeliveryWorker"
//                    vc.controllerPurpuse = "Edit"
//
//                    vc.deliveryCost = deliveryOffer
//                    vc.tax = tax
//
//                    self.navigationController?.pushViewController(vc, animated: true)
//
//                }
                
            }
         
        }
        else if type == "ContactAdmin"{
            
            let vc = ScreenManager.getCancellationVC()
            vc.controllerPurpuse = "ContactAdmin"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if type == "WithdrawOffer"{
            
            let vc = ScreenManager.getWithdrawOfferVC()
            
           // vc.orderID = self.globalOrderID
            
            vc.orderID = self.realOrderIdForWithdraw
            
            vc.controllerIsUsingFor = isComing
            
            self.present(vc, animated: true, completion: nil)
            
        }
        else if type == "ShareLocation"{
            
            self.txtViewMsg.text = "Type here"
            self.txtViewMsg.resignFirstResponder()
            
            let vc = ScreenManager.getShareLiveLocationPouupVC()
            
            vc.delegate = self
            
            self.present(vc, animated: true, completion: nil)
        }
        else{
            
            
        }
        
    }
}


//MARK:- Location share delegate
//MARK:-
extension MessagesVC:LocationSharingDelegate{
    
    func locationForShare(locationName: String) {
        
        if locationName != ""{
            
            self.socket.emit("message", ["roomId":self.roomID,"senderId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","receiverId":self.receiverID,"message":"\(locationName)","messageType":"Location","profilePic":UserDefaults.standard.value(forKey: "ProfilePicForChatUse") as? String ?? ""])
        }
    }

}

//MARK:- Create invoice delegate
//MARK:-
extension MessagesVC:CreateInvoiceDelegate{
    
    func invoiceCreated(status: Bool) {
        
        if status == true{
            
            self.apiCallForGetChatHistory()
        }
    }
}



//MARK:- Location Manager Delegate
//MARK:-
extension MessagesVC:CLLocationManagerDelegate{
    
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
            
            self.socket.emit("tracking", ["roomId": self.roomIdForTracking,"lattitude":"\(sourceLat)","longitude":"\(sourceLong)"])
            
            //Send your fetched location to server
            
            print("----------->AppDelegate Region Update")
            
            //Update location with source lat and long when region is being change
            
           // self.locationManager.stopUpdatingLocation()
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
       // locationManager.stopMonitoring(for: region)
        locationManager.startUpdatingLocation()
        
    }
}

