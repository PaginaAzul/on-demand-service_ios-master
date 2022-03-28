//
//  SettingsVC.swift
//  Joker
//
//  Created by abc on 22/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var tblSetting: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //let settingsArray = ["Normal User Notification".localized(),"About Us".localized(),"Contact Us".localized(),"Terms and Conditions".localized(),"Privacy Policy".localized(),"Logout".localized()]
    
    let settingsArray = ["About Us".localized(),"Contact Us".localized(),"Terms and Conditions".localized(),"Privacy Policy".localized(),"Logout".localized()]
    
    @IBOutlet weak var lblSettings: UILabel!
    
    let connection = webservices()
    var globalNotiStatus = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intialSetUp()
        
        self.apiCallForGetNotificationStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        lblSettings.text = "Settings".localized()
        
    }
    
    
    @IBAction func tap_settingsBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    

}
//MARK: - User Defined Methods Extension
extension SettingsVC{
    func intialSetUp(){
        tblSetting.tableFooterView = UIView()
    }
}
//MARK: - Extension TableView Controller
extension SettingsVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tblSetting.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
        let cell = tblSetting.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        cell.lblSettingName.text = settingsArray[indexPath.row]
        
//        if self.globalNotiStatus{
//
//            cell.switchNotification.isOn = true
//        }
//        else{
//
//            cell.switchNotification.isOn = false
//        }
        
//        if indexPath.row == 0{
//            cell.switchNotification.isHidden = false
//            cell.lblSettingName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//
//            cell.switchNotification.tag = indexPath.row
//            cell.switchNotification.addTarget(self, action: #selector(SettingsVC.switchDirectionChanged(sender:)), for: UIControlEvents.valueChanged)
//
//
//        }else
            if indexPath.row == 4{
            cell.switchNotification.isHidden = true
            cell.lblSettingName.textColor = UIColor.red
        }else{
            cell.switchNotification.isHidden = true
            cell.lblSettingName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4{
            
            if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                
                
                let alert = UIAlertController(title:"PaginAzul" , message: "Are you sure to want to logout?".localized() , preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                    self.apiCallForLogout()
                }
                
                let cancel = UIAlertAction(title: "Cancel".localized(), style: .default, handler: nil)
                
                alert.addAction(cancel)
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
                 
            }
            else{
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please login first.", controller: self)
            }
            
        }
        else if indexPath.row == 0{
            
            let vc = ScreenManager.getAboutUsVC()
            vc.controllerPurpuse = "About"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if indexPath.row == 1{
            
            let vc = ScreenManager.getContactUsVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if indexPath.row == 2{
            
            let vc = ScreenManager.getAboutUsVC()
            vc.controllerPurpuse = "TermsCondition"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if indexPath.row == 3{
            
            let vc = ScreenManager.getAboutUsVC()
            vc.controllerPurpuse = "Privacy"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            
            
        }
        
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @objc func switchDirectionChanged(sender:UISwitch){
        
        if sender.tag == 0{
            
            var switchState = ""
            
            if sender.isOn{
                
                switchState = "true"
            }
            else{
                
                switchState = "false"
            }
            
            print(switchState)
            
            self.apiCallForSetNotificationStatus(switchState: switchState)
            
        }
    }
    
}


extension SettingsVC{
    
    func apiCallForLogout(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param:[String:String] = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForLogout as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let vc = ScreenManager.MainModuleNew_VC()
                        let navController = UINavigationController(rootViewController: vc)
                        navController.navigationBar.isHidden = true
                        self.appDelegate.window?.rootViewController = navController
                        self.appDelegate.window?.makeKeyAndVisible()
                        
                     //   CommonClass.sharedInstance.redirectToHome()
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            
                            let vc = ScreenManager.MainModuleNew_VC()
                            let navController = UINavigationController(rootViewController: vc)
                            navController.navigationBar.isHidden = true
                            self.appDelegate.window?.rootViewController = navController
                            self.appDelegate.window?.makeKeyAndVisible()
                            
                            
                           // CommonClass.sharedInstance.redirectToHome()
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
    
    
    func apiCallForGetNotificationStatus(){
        
        let param:[String:String] = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetNotificationStatus as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        if (receivedData.object(forKey: "response") as? Bool) != nil{
                            
                            self.globalNotiStatus = receivedData.object(forKey: "response") as! Bool
                            
                           self.tblSetting.reloadData()
                            
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
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
             CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    
    func apiCallForSetNotificationStatus(switchState:String){
        
        var sendSwitchState = Bool()
        if switchState == "true"{
            
            sendSwitchState = true
        }
        else{
            
            sendSwitchState = false
        }
        
        let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","normalUserNotification":sendSwitchState] as [String : Any]
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForSetNotificationStatus as NSString, method_type: methodType.post, params: param as! [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        if (receivedData.object(forKey: "response") as? Bool) != nil{
                            
                            self.globalNotiStatus = receivedData.object(forKey: "response") as! Bool
                            
                            self.tblSetting.reloadData()
                            
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
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
             CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
}
