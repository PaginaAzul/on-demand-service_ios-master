//
//  NoramlUserProfessionalPendingVC.swift
//  Joker
//
//  Created by Callsoft on 02/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class NoramlUserProfessionalPendingVC: UIViewController {

    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    @IBOutlet weak var viewPlaceholder: UIView!
    
    
    let connection = webservices()
    var normalUserPendingArr = NSArray()
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
        self.viewPlaceholder.isHidden = true
        self.lblPlaceholder.text = "No data found".localized()
        initialSetup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.apiCallForGetPendingRecordOfNormalUserProfessionalWorker), name: NSNotification.Name(rawValue: "NotificationForUpdatePendingListNormalUserByProfessionalWorker"), object: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        apiCallForGetPendingRecordOfNormalUserProfessionalWorker()
    }

}


extension NoramlUserProfessionalPendingVC{
    
    func initialSetup(){
        
        tableview.tableFooterView = UIView()
    }
}


extension NoramlUserProfessionalPendingVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return normalUserPendingArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableview.register(UINib(nibName: "MyOrderDashBoardProffessionalPendingTableViewCell", bundle: nil), forCellReuseIdentifier: "MyOrderDashBoardProffessionalPendingTableViewCell")
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "MyOrderDashBoardProffessionalPendingTableViewCell", for: indexPath) as! MyOrderDashBoardProffessionalPendingTableViewCell
        
        cell.btnViewAllOffers.tag = indexPath.row
        cell.btnDeleteOrder.tag = indexPath.row
        cell.btnEditOrder.tag = indexPath.row
        
        cell.lblMe.text = "Me".localized()
        cell.lblServiceLocationHeading.text = "Service Location".localized()
        
        cell.btnViewAllOffers.addTarget(self, action: #selector(NoramlUserProfessionalPendingVC.tapViewAllOfferBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.btnDeleteOrder.addTarget(self, action: #selector(NoramlUserProfessionalPendingVC.tapCancelOrderBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.btnEditOrder.addTarget(self, action: #selector(NoramlUserProfessionalPendingVC.tapEditOfferBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        let dict = normalUserPendingArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let orderId = dict.object(forKey: "orderNumber") as? String ?? ""
        cell.lblOrderID.attributedText = CommonClass.sharedInstance.setOrderIDText("Order ID".localized(),orderId)
        
        let createdDate = dict.object(forKey: "createdAt") as? String ?? ""
        cell.lblDateAndTime.text = self.fetchData(dateToConvert: createdDate)
        
        let orderDetail = dict.object(forKey: "orderDetails") as? String ?? ""
        
        let selectTime = dict.object(forKey: "seletTime") as? String ?? ""
        
        let totalOffer = dict.object(forKey: "TotalOffer") as? Int ?? 0
        let pickupLocation = dict.object(forKey: "pickupLocation") as? String ?? ""
        
        var category = ""
        var subCategory = ""
        
        if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
            
            category = dict.object(forKey: "portugueseCategoryName") as? String ?? ""
            subCategory = dict.object(forKey: "portugueseSubCategoryName") as? String ?? ""
        }
        else{
            
            category = dict.object(forKey: "selectCategoryName") as? String ?? ""
            subCategory = dict.object(forKey: "selectSubCategoryName") as? String ?? ""
        }
        
        if subCategory == ""{
            
         //   "Require".localized()+" "+
              cell.lblAddressDetail.attributedText = CommonClass.sharedInstance.attributedStringToDeliveryReEnhancement(title1: "Order Time".localized(), subTitle1: "\(selectTime)".localized()+"\n", delemit: " - ", titleColor1: UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00), SubtitleColor1: UIColor.black, title2: "Order Details".localized(), subTitle2: "\(orderDetail)\n", titleColor2: UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00), SubtitleColor2: UIColor.black, title3: "Dropoff Location".localized(), subTitle3: "\(pickupLocation)\n", titleColor3:#colorLiteral(red: 0.03137254902, green: 0.5725490196, blue: 0.8156862745, alpha: 1), SubtitleColor3: UIColor.black, title4: "Category".localized(), subTitle4: "\(category)\n", titleColor4: UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00), SubtitleColor4: UIColor.black, title5: "", subTitle5: "", titleColor5: UIColor.clear, SubtitleColor5: UIColor.clear)
            
        }
        else{
            
           // "Require".localized()+" "+
            
              cell.lblAddressDetail.attributedText = CommonClass.sharedInstance.attributedStringToDeliveryReEnhancement(title1: "Order Time".localized(), subTitle1: "\(selectTime)".localized()+"\n", delemit: " - ", titleColor1: UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00), SubtitleColor1: UIColor.black, title2: "Order Details".localized(), subTitle2: "\(orderDetail)\n", titleColor2: UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00), SubtitleColor2: UIColor.black, title3: "Dropoff Location".localized(), subTitle3: "\(pickupLocation)\n", titleColor3:#colorLiteral(red: 0.03137254902, green: 0.5725490196, blue: 0.8156862745, alpha: 1), SubtitleColor3: UIColor.black, title4: "Category".localized(), subTitle4: "\(category)\n", titleColor4: UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00), SubtitleColor4: UIColor.black, title5: "Sub-Category".localized(), subTitle5: "\(subCategory)\n", titleColor5: UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00), SubtitleColor5: UIColor.black)
        }
        
        cell.btnViewAllOffers.setTitle("View All Offers".localized()+" (\(totalOffer))", for: .normal)
        
        cell.btnDeleteOrder.setTitle("Cancel Order".localized(), for: .normal)
        
        let currentToPickupLocation = dict.object(forKey: "currentToPicupLocation") as? String ?? ""
        
        cell.lblLocation.text = "\(currentToPickupLocation) \("KM".localized())"
        
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
        
      //  return "\(sendDate) \(sendTime)"
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    @objc func tapViewAllOfferBtn(sender:UIButton){
        
        let dict = normalUserPendingArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let totalOffer = dict.object(forKey: "TotalOffer") as? Int ?? 0
        
        if totalOffer != 0{
            
            let orderId = dict.object(forKey: "_id") as? String ?? ""
            
            let myId = dict.object(forKey: "userId") as? String ?? ""
            
            let vc = ScreenManager.getProffessionalViewAllOffersVC()
            
            vc.orderId = orderId
            vc.userIdOfSelf = myId
            
            if Localize.currentLanguage() == "en"{
                vc.category = dict.object(forKey: "selectCategoryName") as? String ?? ""
            }else{
                vc.category = dict.object(forKey: "portugueseCategoryName") as? String ?? ""
            }
            
            
            vc.controllerName = "ViaPending"
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "No Offer found for this request at this time.".localized(), controller: self)
        }
        
    }
    
    @objc func tapCancelOrderBtn(sender:UIButton){
        
        let dict = normalUserPendingArr.object(at: sender.tag) as? NSDictionary ?? [:]
        let orderId = dict.object(forKey: "_id") as? String ?? ""
        
        let vc = ScreenManager.getCancellationVC()
        
        vc.controllerPurpuse = ""
        vc.orderID = orderId
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapEditOfferBtn(sender:UIButton){
        
        let vc = ScreenManager.getPrfessionalWorkerGoOrderVC()
        
        vc.comingFrom = "ServiceProviderMap"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension NoramlUserProfessionalPendingVC{
    
    @objc func apiCallForGetPendingRecordOfNormalUserProfessionalWorker(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","lat":"\(CommonClass.sharedInstance.locationLatCordinate)","long":"\(CommonClass.sharedInstance.locationLongCordinate)","serviceType":"ProfessionalWorker","langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetNormalUserPendingOrder as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        if let dataDict = receivedData.object(forKey: "Data") as? NSDictionary{
                            
                            self.normalUserPendingArr = dataDict.object(forKey: "docs") as? NSArray ?? []
                            
                            if self.normalUserPendingArr.count == 0{
                                
                                self.tableview.isHidden = true
                                self.viewPlaceholder.isHidden = false
                            }
                            else{
                                
                                self.tableview.isHidden = false
                                self.viewPlaceholder.isHidden = true
                                
                                self.tableview.reloadData()
                                
                                let topIndex = IndexPath(row: 0, section: 0)
                                self.tableview.scrollToRow(at: topIndex, at: .top, animated: true)
                                
                            }
                            
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





