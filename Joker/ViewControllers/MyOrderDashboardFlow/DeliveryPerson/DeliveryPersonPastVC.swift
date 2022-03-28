//
//  DeliveryPersonPastVC.swift
//  Joker
//
//  Created by Callsoft on 02/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import Cosmos

class DeliveryPersonPastVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    var deliveryPersonPastArr = NSArray()
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    NotificationCenter.default.addObserver(self, selector: #selector(DeliveryPersonPastVC.apiCallForGetPastOrderOfDeliveryPerson), name: NSNotification.Name(rawValue: "NotificationForUpdatePastListDelivery"), object: nil)
        
        self.lblPlaceholder.isHidden = true
        
        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
        initialSetup()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.apiCallForGetPastOrderOfDeliveryPerson()
        
    }
    

    @objc func btnRateAction(sender:UIButton){
        
//        let vc = ScreenManager.getReviewAndRatingVC()
//        vc.isComing = "DELIVERY"
//
//        UserDefaults.standard.set("", forKey: "ISCOMIMG_RATINGPOPUP")
//
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let dict = deliveryPersonPastArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
      //  let ratingArr = dict.object(forKey: "ratingData") as? NSArray ?? []
        
      //  if ratingArr.count == 0{
            
            let ratingToId = dict.object(forKey: "offerAcceptedById") as? String ?? ""
            let orderId = dict.object(forKey: "realOrderId") as? String ?? ""
            
            let vc = ScreenManager.getReviewAndRatingVC()
            vc.isComing = "DELIVERY"
            
            vc.ratingPurpuse = "OrderRating"
            
            vc.orderId = orderId
            vc.ratingToUserId = ratingToId
            vc.ratingToTypeUser = "NormalUser"
            vc.ratingByTypeUser = "DeliveryPerson"
            
            UserDefaults.standard.set("", forKey: "ISCOMIMG_RATINGPOPUP")
            
            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        else{
//
//             CommonClass.sharedInstance.callNativeAlert(title: "", message: "You have already rated for this order", controller: self)
//        }
            
    }
}


//MARK: - Extension User Defined Methods
extension DeliveryPersonPastVC{
    
    func initialSetup(){
        
        tableview.tableFooterView = UIView()
    }
}

//MARK: - Extension TableView Controller
extension DeliveryPersonPastVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return deliveryPersonPastArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableview.register(UINib(nibName: "DeliveryWorkerPastTableViewCell", bundle: nil), forCellReuseIdentifier: "DeliveryWorkerPastTableViewCell")
        let cell = tableview.dequeueReusableCell(withIdentifier: "DeliveryWorkerPastTableViewCell", for: indexPath) as! DeliveryWorkerPastTableViewCell
        
        let dict = deliveryPersonPastArr.object(at: indexPath.row) as? NSDictionary ?? [:]

        let orderId = dict.object(forKey: "orderNumber") as? String ?? ""
        cell.lblOrderID.attributedText = CommonClass.sharedInstance.setOrderIDText("Order ID",orderId)

        let createdDate = dict.object(forKey: "createdAt") as? String ?? ""
        cell.lblDateAndTime.text = self.fetchData(dateToConvert: createdDate)

        let invoiceCreatedDate = dict.object(forKey: "invoiceCreatedAt") as? String ?? ""
        
        if invoiceCreatedDate != ""{
            
            cell.lblInvoiceDate.text = self.fetchData(dateToConvert: invoiceCreatedDate)
        }
        else{
            
            cell.lblInvoiceDate.text = "No date found"
        }
        
        cell.lblDeliveryOffer.text = "\(dict.object(forKey: "deliveryOffer") as? String ?? "") SAR"
        
        cell.lblTotal.text = "\(dict.object(forKey: "total") as? String ?? "") SAR"
        cell.lblTax.text = "\(dict.object(forKey: "tax") as? String ?? "") SAR"
        
        let invoiceAmount = dict.object(forKey: "invoiceSubtoatl") as? Int ?? 0
        
        cell.lblInvoiceAmount.text = "\(invoiceAmount) SAR"
        
        let ratingData = dict.object(forKey: "ratingData") as? NSArray ?? []
        
        if ratingData.count == 0{
            
            cell.lblAvgRating.text = "0"
        }
        else{
            
            let ratingDict = ratingData.object(at: 0) as? NSDictionary ?? [:]
            let rateValue = ratingDict.object(forKey: "rate") as? Int ?? 0
            
            cell.lblAvgRating.text = "\(rateValue)"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 247
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 247
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


extension DeliveryPersonPastVC{
    
    @objc func apiCallForGetPastOrderOfDeliveryPerson(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","lat":"\(CommonClass.sharedInstance.locationLatCordinate)","long":"\(CommonClass.sharedInstance.locationLongCordinate)"]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetPastOrderDeliveryPerson as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.deliveryPersonPastArr = receivedData.object(forKey: "Data1") as? NSArray ?? []
                        
                        if self.deliveryPersonPastArr.count == 0{
                            
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
