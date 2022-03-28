//
//  SubmitOfferAsProfessionalWorkerVC.swift
//  Joker
//
//  Created by retina on 17/12/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//


///// Code is same for both controller , SubmitOfferAsProfessionalWorkerVC and SubmitOfferAsDeliveryVC but for more flexibility we made two different controller and after offer submission we are redirecting on common controller for waiting screen



import UIKit

class SubmitOfferAsProfessionalWorkerVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    let connection = webservices()
    
    var dict = NSDictionary()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
        tableview.tableFooterView = UIView()
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension SubmitOfferAsProfessionalWorkerVC:UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableview.register(UINib(nibName: "DeliveryPersonNewDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DeliveryPersonNewDetailTableViewCell")
        let cell = tableview.dequeueReusableCell(withIdentifier: "DeliveryPersonNewDetailTableViewCell", for: indexPath) as! DeliveryPersonNewDetailTableViewCell
        
        cell.viewTrackUsingForDelivery.isHidden = true
        cell.viewTrackUsingForProfessional.isHidden = false
        
        let orderId = dict.object(forKey: "orderNumber") as? String ?? ""
        
        cell.lblOrderId.attributedText = CommonClass.sharedInstance.setOrderIDText("Order ID","\(orderId)")
        
        cell.lblAvgRating.text = "\(dict.object(forKey: "AvgRating") as? Double ?? 0.0)"
        
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        
        if totalRating == 0{
            
            cell.btnViewRating.setTitle("(0 "+"Rating".localized()+")", for: .normal)
        }
        else{
            
            cell.btnViewRating.setTitle("(\(totalRating) Rating view all)", for: .normal)
        }
        
       // let dropLocation = dict.object(forKey: "dropOffLocation") as? String ?? ""
        let pickupLocation = dict.object(forKey: "pickupLocation") as? String ?? ""
        
        let desc = dict.object(forKey: "orderDetails") as? String ?? ""
        let time = dict.object(forKey: "seletTime") as? String ?? ""
        
        cell.lblAddress.attributedText = CommonClass.sharedInstance.attributedStringToDeliveryNewEnhancement(title1: "Service Location", subTitle1: "\(pickupLocation)\n", delemit: " - ", titleColor1: #colorLiteral(red: 0.7970424294, green: 0.5491735935, blue: 0.9914678931, alpha: 1), SubtitleColor1: UIColor.black, title2: "Order Time", subTitle2: "Require \(time)\n", titleColor2: #colorLiteral(red: 0.7970424294, green: 0.5491735935, blue: 0.9914678931, alpha: 1), SubtitleColor2: UIColor.black, title3: "Order Details", subTitle3: "\(desc)", titleColor3: #colorLiteral(red: 0.7970424294, green: 0.5491735935, blue: 0.9914678931, alpha: 1), SubtitleColor3: UIColor.black, title4: "", subTitle4: "", titleColor4: UIColor.clear, SubtitleColor4: UIColor.clear)
        
        cell.lblUsername.text = "\(dict.object(forKey: "name") as? String ?? "")"
        
        let imgStr = dict.object(forKey: "profilePic") as? String ?? ""
        
        if imgStr == ""{
            
            cell.imgUser.image = UIImage(named: "placeholderImg")
        }
        else{
            
            let urlStr = URL(string: imgStr)
            cell.imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
      //  let meToPickupDistance = "\(dict.object(forKey: "currentToPicupLocation") as? String ?? "")KM"
     //   let pickupToDropLocation = "\(dict.object(forKey: "pickupToDropLocation") as? String ?? "")KM"
        
       // cell.lblMeToPickupLocation.text = meToPickupDistance
        
        cell.lblServiceDistance.text = "\(dict.object(forKey: "currentToDrLocation") as? String ?? "")KM"
        
        //cell.lblMeToDropLocation.text = pickupToDropLocation
        
        let createdDate = dict.object(forKey: "createdAt") as? String ?? ""
        
        cell.lblDateTime.text = self.fetchData(dateToConvert: createdDate)
        
        cell.txtFieldNew.attributedPlaceholder = CommonClass.sharedInstance.setMinimumOrderWithStarText()
        
        cell.txtFieldNew.text = ""
        cell.txtFldMsg.text = ""
        cell.txtFldDeliveryTime.text = ""
        
        cell.btnViewRating.tag = indexPath.row
        cell.btnViewRating.addTarget(self, action: #selector(DeliveryPersonNewVC.tapBtnViewRating(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.btnMakeOffer.tag = indexPath.row
        cell.btnMakeOffer.addTarget(self, action: #selector(self.tapBtnMakeOffer(sender:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    
    @objc func tapBtnViewRating(sender:UIButton){
        
        let totalRating = dict.object(forKey: "TotalRating") as? Int ?? 0
        
        let id = dict.object(forKey: "userId") as? String ?? ""
        
        if totalRating != 0{
            
            let vc = ScreenManager.getUserDetailVC()
            
            vc.userID = id
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    
    @objc func tapBtnMakeOffer(sender:UIButton){
        
        let index = IndexPath(row: sender.tag, section: 0)
        let cell: DeliveryPersonNewDetailTableViewCell = self.tableview.cellForRow(at: index) as! DeliveryPersonNewDetailTableViewCell
        
        let offerAmountTxt = cell.txtFieldNew.text!
        let msgTxt = cell.txtFldMsg.text!
        let deliveryTimeTxt = cell.txtFldDeliveryTime.text!
        
        let orderId = dict.object(forKey: "_id") as? String ?? ""
        
        checkValdation(offerAmount: offerAmountTxt, DeliveryTime: deliveryTimeTxt, msg: msgTxt, OrderId: orderId)
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
        
        
        print("====","\(sendDate)".replacingOccurrences(of: locaMonth, with: newM))
        
        let converTedDate = "\(sendDate)".replacingOccurrences(of: locaMonth, with: newM)
        return "\(converTedDate) \(sendTime)"
    }
    
    
    func checkValdation(offerAmount:String,DeliveryTime:String,msg:String,OrderId:String){
        
        print(offerAmount)
        print(DeliveryTime)
        print(msg)
        
        var mess = ""
        
        if offerAmount == ""{
            
            mess = "Please enter offer amount"
        }
        else{
            
            mess = ""
        }
        
        if mess == ""{
            
            //creating and updating offer
            
            let offerId = UserDefaults.standard.value(forKey: "OfferIDToUpdate") as? String ?? ""
            
            if offerId == ""{
                
                self.apiCallToCreateOffer(offerAmount: offerAmount, deliveryTime: DeliveryTime, msg: msg, orderId: OrderId)
            }
            else{
                
                //updating existing offer
                
                self.apiCallToUpdateOffer(offerAmount: offerAmount, deliveryTime: DeliveryTime, msg: msg, orderId: OrderId)
            }
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
        
    }
    
}



extension SubmitOfferAsProfessionalWorkerVC{
    
    
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
                        
                        // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdatePendingListDelivery"), object: nil)
                        
                        //                        CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
                        
                        
                        let dict = receivedData.object(forKey: "Data") as? NSDictionary ?? [:]
                        
                        let offerId = dict.object(forKey: "_id") as? String ?? ""
                        
                        UserDefaults.standard.set("\(offerId)", forKey: "OfferIDToUpdate")
                        
                        self.manageRedirectionOnController(orderId: orderId, offerAmount: offerAmount)
                        
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
                    
                    // CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    
    func manageRedirectionOnController(orderId:String,offerAmount:String){
        
        let avgRating = "\(dict.object(forKey: "AvgRating") as? Double ?? 0.0)"
        let name = dict.object(forKey: "name") as? String ?? ""
        let imgStr = dict.object(forKey: "profilePic") as? String ?? ""
        
        let vc = ScreenManager.getDeliveryPersonWaitingForBuyerVC()
        
        vc.purpuseForControllerUse = "ProfessionalWorker"
        
        vc.orderID = orderId
        vc.offerAmount = offerAmount
        vc.userName = name
        vc.userRating = avgRating
        vc.userImg = imgStr
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    ////api for update offer
    
    
    func apiCallToUpdateOffer(offerAmount:String,deliveryTime:String,msg:String,orderId:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["offerId":UserDefaults.standard.value(forKey: "OfferIDToUpdate") as? String ?? "","userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","minimumOffer":offerAmount,"message":msg,"apprxTime":deliveryTime]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForUpdateOffer as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.manageRedirectionOnController(orderId: orderId, offerAmount: offerAmount)
                        
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
                    
                    // CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    
}
