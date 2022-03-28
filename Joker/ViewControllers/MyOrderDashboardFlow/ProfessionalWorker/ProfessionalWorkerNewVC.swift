//
//  ProfessionalWorkerNewVC.swift
//  Joker
//
//  Created by Callsoft on 02/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class ProfessionalWorkerNewVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    let connection = webservices()
    
    var newDataArrProfessionalWorker = NSArray()
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
        self.lblPlaceholder.isHidden = true
        
        initialSetup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.apiCallForGetNewOrderOfProfessionalWorker), name: NSNotification.Name(rawValue: "RefreshNewOrderScreenForProfessionalCaptain"), object: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        apiCallForGetNewOrderOfProfessionalWorker()
    }

}



extension ProfessionalWorkerNewVC{
  
    func initialSetup(){
        
        tableview.tableFooterView = UIView()
    }
}


extension ProfessionalWorkerNewVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newDataArrProfessionalWorker.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableview.register(UINib(nibName: "Flow16MyDashBoardNewTableViewCellAndXib", bundle: nil), forCellReuseIdentifier: "Flow16MyDashBoardNewTableViewCellAndXib")
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "Flow16MyDashBoardNewTableViewCellAndXib", for: indexPath) as! Flow16MyDashBoardNewTableViewCellAndXib
        
       // cell.txtFieldNew.attributedPlaceholder = CommonClass.sharedInstance.setMinimumOrderWithStarText()
        
        cell.btnViewRating.tag = indexPath.row
        cell.btnViewRating.addTarget(self, action: #selector(ProfessionalWorkerNewVC.tapBtnViewRating(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.btnMakeAnOffer.tag = indexPath.row
        cell.btnMakeAnOffer.addTarget(self, action: #selector(self.tapBtnMakeOffer(sender:)), for: UIControlEvents.touchUpInside)
        
        let dict = newDataArrProfessionalWorker.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let orderId = dict.object(forKey: "orderNumber") as? String ?? ""
        let createdDate = dict.object(forKey: "createdAt") as? String ?? ""
        
        cell.lblOrderId.attributedText = CommonClass.sharedInstance.setOrderIDText("Order ID",orderId)
        
        cell.lblDateAndTime.text = self.fetchData(dateToConvert: createdDate)
        
        let name = dict.object(forKey: "name") as? String ?? ""
      //  let countryCode = dict.object(forKey: "countryCode") as? String ?? ""
      //  let phoneNo = dict.object(forKey: "mobileNumber") as? String ?? ""
        let imgStr = dict.object(forKey: "profilePic") as? String ?? ""
        
        cell.lblUsername.text = name
       // cell.lblContactNo.text = "\(countryCode)\(phoneNo)"
        
        if imgStr == ""{
            
            cell.imgUser.image = UIImage(named: "placeholderImg")
        }
        else{
            
            let urlStr = URL(string: imgStr)
            cell.imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
        let avgRating = dict.object(forKey: "AvgRating") as? Double ?? 0.0
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        
        cell.lblAvgRating.text = "\(avgRating)"
        
        if totalRating == 0{
            
            cell.btnViewRating.setTitle("(0 "+"Rating".localized()+")", for: .normal)
        }
        else{
            
            cell.btnViewRating.setTitle("\(totalRating) \("Rating view all".localized())", for: .normal)
        }
        
        let description = dict.object(forKey: "orderDetails") as? String ?? ""
        let selectedTime = dict.object(forKey: "seletTime") as? String ?? ""
        
       // cell.lblDescription.text = "\(description)\nAnd order require \(selectedTime)"
        
        let pickuplocation = dict.object(forKey: "pickupLocation") as? String ?? ""
        let currentToPickupLocation = dict.object(forKey: "currentToDrLocation") as? String ?? ""
        
        cell.lblMyLocationToDropLocation.text = "\(currentToPickupLocation) \("KM".localized())"
        
      //  cell.lblOrderDetail.text = "Address Detail : \(pickuplocation)"
        
//        cell.txtFieldNew.text = ""
//        cell.txtMsg.text = ""
//        cell.txtApproxTime.text = ""
        
          cell.lblOrderDetail.attributedText = CommonClass.sharedInstance.attributedStringToDeliveryNewEnhancement(title1: "Service Location", subTitle1: "\(pickuplocation)\n\n", delemit: " - ", titleColor1: #colorLiteral(red: 0.7970424294, green: 0.5491735935, blue: 0.9914678931, alpha: 1), SubtitleColor1: UIColor.black, title2: "Order Details", subTitle2: "Require \(selectedTime)\n\n", titleColor2: #colorLiteral(red: 0.7970424294, green: 0.5491735935, blue: 0.9914678931, alpha: 1), SubtitleColor2: UIColor.black, title3: "Message", subTitle3: "\(description)\n\n", titleColor3: #colorLiteral(red: 0.7970424294, green: 0.5491735935, blue: 0.9914678931, alpha: 1), SubtitleColor3: UIColor.black, title4: "", subTitle4: "", titleColor4: UIColor.clear, SubtitleColor4: UIColor.clear)
        
        
        return cell
    }
    
    
    func fetchData(dateToConvert:String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
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
    
    
    @objc func tapBtnViewRating(sender:UIButton){
        
        let dict = newDataArrProfessionalWorker.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        let id = dict.object(forKey: "userId") as? String ?? ""
        
        if totalRating != 0{
            
            let vc = ScreenManager.getUserDetailVC()
            
            vc.userID = id
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
      
    }
    
    
    @objc func tapBtnMakeOffer(sender:UIButton){
        

        let dict = self.newDataArrProfessionalWorker.object(at: sender.tag) as? NSDictionary ?? [:]
        
        self.checkOrderIsAvailableOrNot(passDict: dict)
        
//        let vc = ScreenManager.getDeliveryDetailOnMapVC()
//
//        vc.dataDict = dict
//
//        vc.controllerInfoForm = "ProfessionalFlow"
//
//        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
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



extension ProfessionalWorkerNewVC{
    
    @objc func apiCallForGetNewOrderOfProfessionalWorker(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","lat":"\(CommonClass.sharedInstance.locationLatCordinate)","long":"\(CommonClass.sharedInstance.locationLongCordinate)"]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetNewOrderProfessionalWorker as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.newDataArrProfessionalWorker = receivedData.object(forKey: "Data1") as? NSArray ?? []
                        
                        if self.newDataArrProfessionalWorker.count == 0{
                            
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
                    else{
                        
                        self.tableview.isHidden = true
                        self.lblPlaceholder.isHidden = false
                        
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
    
    
    func apiCallToCreateOffer(offerAmount:String,deliveryTime:String,msg:String,orderId:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["orderId":orderId,"userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","minimumOffer":offerAmount,"message":msg,"apprxTime":deliveryTime]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForMakeAOfferByProfessionalWorker as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdatePendingListProfessional"), object: nil)
                        
                        self.apiCallForGetNewOrderOfProfessionalWorker()
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
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
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
                        
                        vc.controllerInfoForm = "ProfessionalFlow"
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToHome()
                        }
                        else{
                            
                            CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                            
                            self.apiCallForGetNewOrderOfProfessionalWorker()
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

