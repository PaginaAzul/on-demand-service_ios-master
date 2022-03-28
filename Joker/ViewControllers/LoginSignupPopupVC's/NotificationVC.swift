//
//  NotificationVC.swift
//  Joker
//
//  Created by Apple on 01/02/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    @IBOutlet weak var btnHome: UIButton!
    
    @IBOutlet weak var btnMyOrder: UIButton!
    
    @IBOutlet weak var btnNofication: UIButton!
    
    @IBOutlet weak var btnProfile: UIButton!
    
    @IBOutlet weak var lblNav: UILabel!
    
    @IBOutlet weak var lblTabHome: UILabel!
    @IBOutlet weak var lblTabMyOrder: UILabel!
    @IBOutlet weak var lblTabNoti: UILabel!
    @IBOutlet weak var lblTabProfile: UILabel!
    @IBOutlet weak var lblTabHelp: UILabel!
    
    
    let connection = webservices()
    
    var notificationListArr = NSArray()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
        registerTableCell()
        
        self.lblPlaceholder.isHidden = true
        self.tableView.isHidden = true
        
        self.apiCallForGetNotificationList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        lblNav.text = "Notification".localized()
        
        if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
            
            lblTabHome.text = "Home".localized()
            lblTabMyOrder.text = "My Order".localized()
            //lblTabNoti.text = "Notifications".localized()
            lblTabProfile.text = "Profile".localized()
            lblTabHelp.text = "Help".localized()
            
            /*
            btnHome.setImage(UIImage(named: "HomeUnselectedLang"), for: .normal)
            btnMyOrder.setImage(UIImage(named: "OrderUnselectedLang"), for: .normal)
            btnNofication.setImage(UIImage(named: "NotificationSelectedLang"), for: .normal)
            btnProfile.setImage(UIImage(named: "ProfileUnselectedLang"), for: .normal)
            
           */
        }
        else{
            
            lblTabHome.text = "Home".localized()
            lblTabMyOrder.text = "My Order".localized()
            //lblTabNoti.text = "Notifications".localized()
            lblTabProfile.text = "Profile".localized()
            lblTabHelp.text = "Help".localized()
            
            /*
            btnHome.setImage(UIImage(named: "shopsUnselected"), for: .normal)
            btnMyOrder.setImage(UIImage(named: "myOrderUnselected"), for: .normal)
            btnNofication.setImage(UIImage(named: "notificationsSelected"), for: .normal)
            btnProfile.setImage(UIImage(named: "captainUnselected"), for: .normal)
             */
        }
        
    }
    
    @IBAction func tap_Help(_ sender: Any) {
            let vc = ScreenManager.getContactUsVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        let vc = ScreenManager.getMoreVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tap_shopsBtn(_ sender: Any) {
        
        let vc = ScreenManager.getServiceProviderMapVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func tap_myOrdersBtn(_ sender: Any) {
        
        let vc = ScreenManager.getNormalUserWithProfessionalWorkerScrollerVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
       
    }
    
    @IBAction func tap_notificationsBtn(_ sender: Any) {
        
        
    }
    
    @IBAction func tap_captainBtn(_ sender: Any) {
        
        let vc = ScreenManager.getMapWithServicesSepratedVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
    }
    
}


extension NotificationVC {
    
    func registerTableCell(){
        
        let cellNib = UINib(nibName: "NotificationCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "NotificationCell")
    }
    
}

//MARK:- UITableView datasource delegate
//MARK:-
extension NotificationVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notificationListArr.count
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        let dict = notificationListArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        cell.lbl_Data.text = dict.object(forKey: "notiMessage") as? String ?? ""
        
        let notificationDateAndTime = dict.object(forKey: "createdAt") as? String ?? ""
        if notificationDateAndTime == ""{
            
            cell.lblDateAndTime.text = "No date found"
        }
        else{
            
            cell.lblDateAndTime.text = self.fetchData(dateToConvert: notificationDateAndTime)
        }
        
        cell.selectionStyle = .none
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
    
}

//MARK:- Webservices
//MARK:-
extension NotificationVC{
    
    func apiCallForGetNotificationList(){
        
        let param:[String:String] = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetNotificationList as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let dict = receivedData.object(forKey: "Data") as? NSDictionary ?? [:]
                        
                        self.notificationListArr = dict.object(forKey: "docs") as? NSArray ?? []
                        
                        if self.notificationListArr.count == 0{
                            
                            self.tableView.isHidden = true
                            self.lblPlaceholder.isHidden = false
                        }
                        else{
                            
                            self.tableView.isHidden = false
                            self.lblPlaceholder.isHidden = true
                            
                            self.apiCallForSeenNotification()
                        }
                        
                        self.tableView.reloadData()
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
    
    func apiCallForSeenNotification(){
        
        let param:[String:String] = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForNotificationSeen as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        UIApplication.shared.applicationIconBadgeNumber = 0
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToHome()
                        }
                        else{
                            
                          //  CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
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
