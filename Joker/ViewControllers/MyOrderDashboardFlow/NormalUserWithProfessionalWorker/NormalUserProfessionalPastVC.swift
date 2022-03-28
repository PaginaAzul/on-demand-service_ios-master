//
//  NormalUserProfessionalPastVC.swift
//  Joker
//
//  Created by Callsoft on 02/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class NormalUserProfessionalPastVC: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    var normalUserPastArr = NSArray()
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblPlaceholder.isHidden = true
         lblPlaceholder.text = "No data found".localized()
       // self.lblPlaceholder.isHidden = false
      //  self.lblPlaceholder.text = "Under development"
        
        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callPending), name: NSNotification.Name(rawValue: "RatingByProfessional"), object: nil)
      
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.apiCallForNormalUserPastOrder()
    }

    @objc func callPending(){
        self.apiCallForNormalUserPastOrder()
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

extension NormalUserProfessionalPastVC{
    
    func initialSetup(){
        tableview.tableFooterView = UIView()
    }
}


extension NormalUserProfessionalPastVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return normalUserPastArr.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableview.register(UINib(nibName: "MyDashboardDeliveryWorkerPastCellAndXib", bundle: nil), forCellReuseIdentifier: "MyDashboardDeliveryWorkerPastCellAndXib")
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "MyDashboardDeliveryWorkerPastCellAndXib", for: indexPath) as! MyDashboardDeliveryWorkerPastCellAndXib
        
        let dict = normalUserPastArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let orderId = dict.object(forKey: "orderNumber") as? String ?? ""
        cell.lblOrderID.attributedText = CommonClass.sharedInstance.setOrderIDText("Order ID".localized(),orderId)
        
        let createdDate = dict.object(forKey: "createdAt") as? String ?? ""
    
         cell.lblDateAndTime.text = self.fetchData(dateToConvert: createdDate)
        
        
        
        print("Invoice Details --->", "\(self.fetchData(dateToConvert: createdDate))" )
        
        
        
        
        
        let offerAmount =  dict.object(forKey: "deliveryOffer") as? String ?? ""
        
        let currency = dict.object(forKey: "currency") as? String ?? ""
        
        let minmumOffer = dict.object(forKey: "minimumOffer") as? String ?? ""
        cell.lblOfferAmount.text = "\(minmumOffer) \(currency)"
        
        let invoiceDate = dict.object(forKey: "invoiceCreatedAt") as? String ?? ""
        
        if invoiceDate != ""{
            
//            let newDateT = "\(fetchData(dateToConvert: invoiceDate))"
//            var locaMonth =  newDateT.substring(with: 3..<6)
//
//            //if "\(self.fetchData(dateToConvert: createdDate))".contains(locaMonth) {
//            var newM = locaMonth.localized()
//
//            //   "\(sendDate)".replacingOccurrences(of: newM, with: sendDate)
//
//
//            print("====",newDateT.replacingOccurrences(of: locaMonth, with: newM))
//
//            let converTedDate = newDateT.replacingOccurrences(of: locaMonth, with: newM)
            
            cell.lblInvoiceDate.text = self.fetchData(dateToConvert: createdDate)
        }
        else{
            
            cell.lblInvoiceDate.text = "No date found".localized()
        }
       
        var category = ""
        var subcategory = ""
        
        if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
            
            category = dict.object(forKey: "portugueseCategoryName") as? String ?? ""
            subcategory = dict.object(forKey: "portugueseSubCategoryName") as? String ?? ""
        }
        else{
            
            category = dict.object(forKey: "selectCategoryName") as? String ?? ""
            subcategory = dict.object(forKey: "selectSubCategoryName") as? String ?? ""
        }
        
        let location = dict.object(forKey: "pickupLocation") as? String ?? ""
        let orderDetail = dict.object(forKey: "orderDetails") as? String ?? ""
        
        cell.lblCategory.text = category
        cell.lblSubcategory.text = subcategory
        cell.lblOrderLocation.text = location
        cell.lblOrderDetails.text = orderDetail
        cell.btnAvgRating.tag = indexPath.row
        
        if let ratingDataArr = dict.object(forKey: "ratingData") as? NSArray{
            
           
            
            if ratingDataArr.count != 0{
                
                for index in 0..<ratingDataArr.count {
                    if indexPath.row == index {
                        let ratingDict = ratingDataArr.object(at: ratingDataArr.count - 1) as? NSDictionary ?? [:]
                        let rateValue = ratingDict.object(forKey: "rate") as? Int ?? 0
                        
                        cell.lblAvgRating.text = "\(rateValue)"
                    }
                }
                
                
            }
            else{
                
                cell.lblAvgRating.text = "5"
//                cell.btnAvgRating.addTarget(self, action: #selector(self.tapAvgRating(sender:)), for: UIControlEvents.touchUpInside)

            }
        }
        
        
        
        let tax =  dict.object(forKey: "tax") as? String ?? ""
        let total =  dict.object(forKey: "total") as? String ?? ""
        
        let invoiceAmount = dict.object(forKey: "invoiceSubtoatl") as? String ?? "0"
        
        if "\(invoiceAmount)" == "0"{
            cell.lblDeliveryOffer.isHidden = true
        }else{
            cell.lblDeliveryOffer.isHidden = false
        }
        
        cell.lblDeliveryOffer.text = "\(invoiceAmount) \(currency)"
       
        cell.lblTax.text = "\(tax) \(currency)"
        cell.lblTotal.text = "\(total) \(currency)"
        
        cell.lblCategoryHeading.text = "Category".localized()
        cell.lblSubcategoryHeading.text = "Sub-Category".localized()
        cell.lblTax5Percent.text = "Tax 5%".localized()
        cell.lblTotalHeading.text = "Total".localized()
        cell.lblInvoiceDetailHeading.text = "Invoice Details".localized()
        cell.lblOrderDetailHeading.text = "Order Details".localized()
        
        cell.lblOrderLocationHeading.text = "Order Location".localized()
        
        if "\(invoiceAmount)" == "0"{
         cell.lblProfessionalOfferHeading.isHidden = true
        }else{
             cell.lblProfessionalOfferHeading.isHidden = false
        }
        
        cell.lblOfferAmountHeading.text = "Offer Amount".localized()
        cell.lblProfessionalOfferHeading.text = "Additional Cost".localized()
        cell.lblCaptainReviewAndRate.text = "Review & Rate".localized()
        cell.lblNote.text = "Note: Payment after completion of the service".localized()
        
        return cell
    }
    
    func fetchData(dateToConvert:String) -> String{
        
        
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
       // dateFormatter.locale =  Locale(identifier: Locale.current.languageCode!)
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
    
    
    @objc func tapAvgRating(sender:UIButton){
        
        let dict = normalUserPastArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        //let ratingArr = dict.object(forKey: "ratingData") as? NSArray ?? []
        
       // if ratingArr.count == 0{
            
            let ratingToId = dict.object(forKey: "offerAcceptedOfId") as? String ?? ""
            let orderId = dict.object(forKey: "offerId") as? String ?? ""
            
            let vc = ScreenManager.getReviewAndRatingVC()
            vc.isComing = "normalPROFESSIONAL"
            
            vc.screenName = "past"
            
            vc.ratingPurpuse = "OrderRating"
            
            vc.orderId = orderId
            vc.ratingToUserId = ratingToId
            vc.ratingToTypeUser = "ProfessionalWorker"
            vc.ratingByTypeUser = "NormalUser"
            
            UserDefaults.standard.set("", forKey: "ISCOMIMG_RATINGPOPUP")
            
            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        else{
//
//             CommonClass.sharedInstance.callNativeAlert(title: "", message: "You have already rated for this order", controller: self)
//        }
        
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
}


extension NormalUserProfessionalPastVC{
    
    func apiCallForNormalUserPastOrder(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","lat":"\(CommonClass.sharedInstance.locationLatCordinate)","long":"\(CommonClass.sharedInstance.locationLongCordinate)","serviceType":"ProfessionalWorker","langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForFetchPastOrderOfNormalUser as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.normalUserPastArr = receivedData.object(forKey: "Data1") as? NSArray ?? []
                        
                        if self.normalUserPastArr.count == 0{
                            
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
