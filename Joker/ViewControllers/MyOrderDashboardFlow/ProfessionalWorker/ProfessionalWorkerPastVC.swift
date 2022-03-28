//
//  ProfessionalWorkerPastVC.swift
//  Joker
//
//  Created by Callsoft on 02/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class ProfessionalWorkerPastVC: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    var ProfessionalWorkerPastArr = NSArray()
    
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblPlaceholder.isHidden = true
        
        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfessionalWorkerPastVC.apiCallForGetPastOrderOfProfessionalPerson), name: NSNotification.Name(rawValue: "NotificationForUpdatePastListProfessionalWorker"), object: nil)
        
        initialSetup()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.apiCallForGetPastOrderOfProfessionalPerson()
    }
    
    
    @objc func tapRateRef(sender:UIButton){
        
        let vc = ScreenManager.getReviewAndRatingVC()
        
        vc.isComing = "PROFESSIONAL"
        
        UserDefaults.standard.set("", forKey: "ISCOMIMG_RATINGPOPUP")
        
        self.navigationController?.pushViewController(vc, animated: true)
      
    }
}



extension ProfessionalWorkerPastVC{
    
    func initialSetup(){
        tableview.tableFooterView = UIView()
    }
}


extension ProfessionalWorkerPastVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ProfessionalWorkerPastArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableview.register(UINib(nibName: "Flow16MyDashBoardPastTableViewCellAndXibs", bundle: nil), forCellReuseIdentifier: "Flow16MyDashBoardPastTableViewCellAndXibs")
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "Flow16MyDashBoardPastTableViewCellAndXibs", for: indexPath) as! Flow16MyDashBoardPastTableViewCellAndXibs
        
//        cell.btnRateRef.tag = indexPath.row
//        cell.btnRateRef.addTarget(self, action: #selector(ProfessionalWorkerPastVC.tapRateRef(sender:)), for: UIControlEvents.touchUpInside)
        
        let dict = ProfessionalWorkerPastArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let orderId = dict.object(forKey: "orderNumber") as? String ?? ""
        let createdAt = dict.object(forKey: "createdAt") as? String ?? ""
        
        let invoiceDate = dict.object(forKey: "invoiceCreatedAt") as? String ?? ""
        
        if invoiceDate != ""{
            
            cell.lblInvoiceDate.text = fetchData(dateToConvert: invoiceDate)
        }
        else{
            
            cell.lblInvoiceDate.text = "No date found"
        }
        
        cell.lblOrderId.attributedText = CommonClass.sharedInstance.setOrderIDText("Order ID",orderId)
        
        cell.lblDateAndTime.text = fetchData(dateToConvert: createdAt)
        
        let offerAmount = dict.object(forKey: "minimumOffer") as? String ?? ""
        let deliveryOffer = dict.object(forKey: "deliveryOffer") as? String ?? ""
        let tax = dict.object(forKey: "tax") as? String ?? ""
        let total = dict.object(forKey: "total") as? String ?? ""
        
        let invoiceAmount = dict.object(forKey: "invoiceSubtoatl") as? Int ?? 0
        
        cell.lblOfferAmount.text = "\(offerAmount) SAR"
        cell.lblDeliveryOffer.text = "\(invoiceAmount) SAR"
        cell.lblTax.text = "\(tax) SAR"
        cell.lblTotal.text = "\(total) SAR"
        
        cell.btnTapAvgRating.tag = indexPath.row
        cell.btnTapAvgRating.addTarget(self, action: #selector(self.tapAvgRatingOfOrder(sender:)), for: UIControlEvents.touchUpInside)
        
        if let ratingDataArr = dict.object(forKey: "ratingData") as? NSArray{
            
            if ratingDataArr.count != 0{
                
                let ratingDict = ratingDataArr.object(at: 0) as? NSDictionary ?? [:]
                let rating = ratingDict.object(forKey: "rate") as? Int ?? 0
                
                cell.lblRating.text = "\(rating)"
                
            }
            else{
                
                cell.lblRating.text = "0"
            }
        }
        
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
    
    
    @objc func tapAvgRatingOfOrder(sender:UIButton){
        
        let dict = ProfessionalWorkerPastArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
      //  let ratingArr = dict.object(forKey: "ratingData") as? NSArray ?? []
        //
    //    if ratingArr.count == 0{
            
            let ratingToId = dict.object(forKey: "offerAcceptedById") as? String ?? ""
            let orderId = dict.object(forKey: "realOrderId") as? String ?? ""
            
            let vc = ScreenManager.getReviewAndRatingVC()
            vc.isComing = "PROFESSIONAL"
            
            vc.ratingPurpuse = "OrderRating"
            
            vc.orderId = orderId
            vc.ratingToUserId = ratingToId
            vc.ratingToTypeUser = "NormalUser"
            vc.ratingByTypeUser = "ProfessionalWorker"
            
            UserDefaults.standard.set("", forKey: "ISCOMIMG_RATINGPOPUP")
            
            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        else{
//
//             CommonClass.sharedInstance.callNativeAlert(title: "", message: "You have already rated for this order", controller: self)
//        }
       
    }
    
}



extension ProfessionalWorkerPastVC{
    
    @objc func apiCallForGetPastOrderOfProfessionalPerson(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","lat":"\(CommonClass.sharedInstance.locationLatCordinate)","long":"\(CommonClass.sharedInstance.locationLongCordinate)"]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetPastOrderProfessionalWorker as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.ProfessionalWorkerPastArr = receivedData.object(forKey: "Data1") as? NSArray ?? []
                        
                        if self.ProfessionalWorkerPastArr.count == 0{
                            
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
