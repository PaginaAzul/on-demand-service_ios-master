//
//  ProfessionalWorkerPendingVC.swift
//  Joker
//
//  Created by Callsoft on 02/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class ProfessionalWorkerPendingVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    @IBOutlet weak var viewPlaceholder: UIView!
    
    
    var pendingRecordArrProfessionalWorker = NSArray()
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
       // self.lblPlaceholder.isHidden = true
        
        self.tableview.isHidden = true
        self.viewPlaceholder.isHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.apiCallForGetPendingRecordOfProfessionalWorker), name: NSNotification.Name(rawValue: "NotificationForUpdatePendingListProfessional"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.apiCallForGetPendingRecordOfProfessionalWorker), name: NSNotification.Name(rawValue: "NotificationForUpdatePendingAndActiveOrderOfProfessionalWorker"), object: nil)
        
        initialSetup()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //self.apiCallForGetPendingRecordOfProfessionalWorker()
    }

}


extension ProfessionalWorkerPendingVC{
    
    func initialSetup(){
        
        tableview.tableFooterView = UIView()
    }
}


extension ProfessionalWorkerPendingVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pendingRecordArrProfessionalWorker.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableview.register(UINib(nibName: "Flow16MyOrderDashboardPendingTableViewCellAndXib", bundle: nil), forCellReuseIdentifier: "Flow16MyOrderDashboardPendingTableViewCellAndXib")
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "Flow16MyOrderDashboardPendingTableViewCellAndXib", for: indexPath) as! Flow16MyOrderDashboardPendingTableViewCellAndXib
        
        cell.btnReportOrder.tag = indexPath.row
        cell.btnCancelOrder.tag = indexPath.row
        
        cell.btnReportOrder.addTarget(self, action: #selector(ProfessionalWorkerPendingVC.tapReportOrderBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.btnCancelOrder.addTarget(self, action: #selector(ProfessionalWorkerPendingVC.tapReportCancelOrder(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.btnContactAdmin.tag = indexPath.row
        cell.btnContactAdmin.addTarget(self, action: #selector(self.tapContactAdminBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.btnViewRating.tag = indexPath.row
        
        cell.btnViewRating.addTarget(self, action: #selector(ProfessionalWorkerPendingVC.tapBtnViewRating(sender:)), for: UIControlEvents.touchUpInside)
        
        let dict = pendingRecordArrProfessionalWorker.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let orderId = dict.object(forKey: "orderNumber") as? String ?? ""
        let createdAt = dict.object(forKey: "createdAt") as? String ?? ""
        
        cell.lblOrderID.attributedText = CommonClass.sharedInstance.setOrderIDText("Order ID",orderId)
        
        cell.lblDateAndTime.text = fetchData(dateToConvert: createdAt)
        
        let imgStr = dict.object(forKey: "profilePic") as? String ?? ""
        
        if imgStr == ""{
            
            cell.imgUser.image = UIImage(named: "placeholderImg")
        }
        else{
            
            let urlStr = URL(string: imgStr)
            cell.imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
        let name = dict.object(forKey: "name") as? String ?? ""
        let avgRating = dict.object(forKey: "AvgRating") as? Double ?? 0.0
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        
        cell.lblUsername.text = name
        cell.lblAvgRating.text = "\(avgRating)"
        
        if totalRating == 0{
            
            cell.btnViewRating.setTitle("(0 "+"Rating".localized()+")", for: .normal)
        }
        else{
            
            cell.btnViewRating.setTitle("\(totalRating) \("Rating view all".localized())", for: .normal)
        }
        
        let location = dict.object(forKey: "currentToDrLocation") as? String ?? ""
        cell.lblMyLocationToDropLocation.text = "\(location) \("KM".localized())"
        
        let offerAmount = dict.object(forKey: "deliveryOffer") as? String ?? ""
        cell.lblOfferAmount.text = "\(offerAmount)  " + "Only".localized()
        
        cell.lblDeliveryMessage.text = dict.object(forKey: "message") as? String ?? ""
        
        cell.lblApproxTime.text = dict.object(forKey: "apprxTime") as? String ?? ""
        
        if cell.lblDeliveryMessage.text == ""{
            
            cell.lblDeliveryMessage.text = "Not Defined"
        }
        
        if cell.lblApproxTime.text == ""{
            
            cell.lblApproxTime.text = "Not Defined"
        }
        
        
        let countryCode = dict.object(forKey: "countryCode") as? String ?? ""
        let phoneNo = dict.object(forKey: "mobileNumber") as? String ?? ""
        
        let pickupLocation = dict.object(forKey: "pickupLocation") as? String ?? ""
        
        cell.lblContactNumber.text = "\(countryCode)\(phoneNo)"
        
        cell.lblOrderDetail.text = "Address Detail : \(pickupLocation)"
        
        let description = dict.object(forKey: "orderDetails") as? String ?? ""
        let selectedTime = dict.object(forKey: "seletTime") as? String ?? ""
        
        cell.lblDescription.text = "\(description)\nAnd order require \(selectedTime)"
        
        let deliveryOffer = dict.object(forKey: "invoiceSubtoatl") as? String ?? ""
        let tax = dict.object(forKey: "tax") as? String ?? ""
        let total = dict.object(forKey: "total") as? String ?? ""
        
        cell.lblDeliveryOffer.text = "\(deliveryOffer)SAR"
        cell.lblTax.text = "\(tax)SAR"
        cell.lblTotal.text = "\(total)SAR"
        
        return cell
        
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
    
   
    @objc func tapMakeNewOffer(sender:UIButton){
        
         let vc = ScreenManager.getMakeNewOfferAlertVC()
        
         vc.isComing = "PROFESSIONAL"
        
         self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    
    @objc func tapReportOrderBtn(sender:UIButton){
        
        let dict = pendingRecordArrProfessionalWorker.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let orderId = dict.object(forKey: "_id") as? String ?? ""
        
        let vc = ScreenManager.getCancellationVC()
        
        vc.controllerPurpuse = "ReportCancel"
        vc.orderID = orderId
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapReportCancelOrder(sender:UIButton){
        
        let dict = pendingRecordArrProfessionalWorker.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let orderId = dict.object(forKey: "_id") as? String ?? ""
        
        let vc = ScreenManager.getCancellationVC()
        
        vc.controllerPurpuse = ""
        vc.orderID = orderId
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapBtnViewRating(sender:UIButton){
        
        let dict = pendingRecordArrProfessionalWorker.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        let id = dict.object(forKey: "orderOwner") as? String ?? ""
        
        if totalRating != 0{
            
            let vc = ScreenManager.getUserDetailVC()
            
            vc.userID = id
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
      
    }
    
    
}




extension ProfessionalWorkerPendingVC{
    
    @objc func apiCallForGetPendingRecordOfProfessionalWorker(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","lat":"\(CommonClass.sharedInstance.locationLatCordinate)","long":"\(CommonClass.sharedInstance.locationLongCordinate)"]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetPendingOrderProfessionalWorker as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.pendingRecordArrProfessionalWorker = receivedData.object(forKey: "Data1") as? NSArray ?? []
                        
                        if self.pendingRecordArrProfessionalWorker.count == 0{
                            
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



//{
//    AvgRating = "3.7";
//    TotalRating = 7;
//    "_id" = 5cd01d95c23fea5b5604ab6a;
//    apprxTime = "30 min";
//    countryCode = "+91";
//    createdAt = "2019-05-06T11:42:13.491Z";
//    currentToPicupLocation = 0;
//    deliveryOffer = 100;
//    gender = Male;
//    goStatus = false;
//    invoiceCreatedAt = "2019-05-06T10:47:31.505Z";
//    invoiceStatus = false;
//    location =             {
//        coordinates =                 (
//            "72.8561644",
//            "19.0176147"
//        );
//        coordinates1 =                 (
//        );
//        type = Point;
//    };
//    makeOfferById = 5cc19ceb152b18709c0dd92a;
//    message = "I am very time punctual";
//    minimumOffer = 300;
//    mobileNumber = 9758024940;
//    name = Abhishek;
//    offerMakeByName = Ravi;
//    orderDetails = "I require a professional worker to complete the work within time";
//    orderNumber = 89014404303;
//    orderOwner = 5cc19c97152b18709c0dd929;
//    pickupLat = "19.0176147";
//    pickupLocation = "256, Rd Number 19, Wadla Village, Wadala, Mumbai, Maharashtra 400031, India ";
//    pickupLong = "72.8561644";
//    profilePic = "https://res.cloudinary.com/boss8055/image/upload/v1556606338/rtipgzhmtpzhv9o0yv56.jpg";
//    realOrderId = 5ccfea4863933f1dc14e0e28;
//    seletTime = "Within 2 hour";
//    service = RequireService;
//    serviceType = ProfessionalWorker;
//    status = Pending;
//    tax = 5;
//    total = 105;
//    updatedAt = "2019-05-06T11:42:13.491Z";
//},
