//
//  UpdatePhoneVC.swift
//  Joker
//
//  Created by Callsoft on 07/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import FirebaseAuth
import FirebaseCore
import Firebase

class UpdatePhoneVC: UIViewController {

    
    @IBOutlet weak var txtMobNo: UITextField!
    
    @IBOutlet weak var txtCountry: UITextField!
    
    @IBOutlet weak var lblNav: UILabel!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    let connection = webservices()
    
    var countryCodeArray = NSMutableArray()
    var arrayFromPlist = NSMutableArray()
    var countryCodeCheck = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtCountry.placeHolderColor = UIColor(red:0.19, green:0.19, blue:0.19, alpha:1.0)
        txtMobNo.placeHolderColor = UIColor(red:0.19, green:0.19, blue:0.19, alpha:1.0)
        
        self.apiCallForGetUserDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        lblNav.text = "Update Phone".localized()
        txtMobNo.placeholder = "Enter Mobile Number".localized()
        btnSubmit.setTitle("Send".localized(), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool){
        
        super.viewDidAppear(true)
        loadPlistDataatLoadTime()
        
//        if countryCodeCheck == false{
//
//            if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String
//            {
//                for i in 0 ..< self.arrayFromPlist.count
//                {
//                    if let dic = self.arrayFromPlist.object(at: i) as? NSDictionary
//                    {
//                        if countryCode == dic.object(forKey: "country_code") as! String
//                        {
//
//                            let countryName = dic.object(forKey: "country_name") as? String ?? ""
//
//                            let plusCCode = dic.object(forKey: "country_dialing_code") as? String ?? ""
//
//                            UserDefaults.standard.set(countryName, forKey: "CountryName")
//
//                            UserDefaults.standard.setValue(plusCCode, forKey: "CountryCode")
//                        }
//                    }
//                }
//            }
//
//            countryCodeCheck = true
//        }
        
    }
    

    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_countryBtn(_ sender: Any) {
        
        showCountryPicker()
    }
    
    
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        
        checkvalidation()
    }
    
}


extension UpdatePhoneVC{
    
    func showCountryPicker(){
        self.view.endEditing(true)
        
        ActionSheetStringPicker.show(withTitle: "", rows: self.countryCodeArray as [AnyObject], initialSelection: 29, doneBlock: { (picker,selectedIndex, origin) -> Void in
            
            let select = selectedIndex
            print(select)
            let dic = self.arrayFromPlist.object(at: select) as? NSDictionary
            
            
            let countryCode = dic?.object(forKey: "country_dialing_code") as? String ?? ""
            
            // self.countryCodeTxtFld.text = dic?.object(forKey: "country_dialing_code") as? String
            //  let countryCode = dic?.object(forKey: "country_code") as? String ?? ""
            
            //  let countryName = dic?.object(forKey: "country_name") as? String ?? ""
            
            self.txtCountry.text = "\(countryCode)"
            
            print(countryCode)
            
            let countryName = dic?.object(forKey: "country_name") as? String ?? ""
            UserDefaults.standard.set(countryName, forKey: "CountryName")
            
            UserDefaults.standard.setValue(countryCode, forKey: "CountryCode")
            
            
        }, cancel: { (picker) -> Void in
            
        }, origin: self.view)
        
    }
    
    func loadPlistDataatLoadTime() {
        
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        let path = documentsDirectory.appendingPathComponent("countryList.plist")
        let fileManager = FileManager.default
        
        if(!fileManager.fileExists(atPath: path)) {
            
            if let bundlePath = Bundle.main.path(forResource: "countryList", ofType: "plist") {
                let rootArray = NSMutableArray(contentsOfFile: bundlePath)
                print("Bundle RecentSearch.plist file is --> \(String(describing: rootArray?.description))")
                do{
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                }
                catch _ {
                    print("Fail to copy")
                }
                print("copy")
            } else {
                print("RecentSearch.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print("RecentSearch.plist already exits at path.")
            
        }
        
        let rootarray = NSMutableArray(contentsOfFile: path)
        print("Loaded RecentSearch.plist file is --> \(String(describing: rootarray?.description))")
        let array = NSMutableArray(contentsOfFile: path)
        print(array)
        if let dict = array {
            
            
            let tempArray = array!
            self.arrayFromPlist = tempArray
            var i = 0
            for index in tempArray{
                
                let dic = tempArray.object(at: i) as? NSDictionary
                i = i+1
                let code = dic?.object(forKey: "country_dialing_code") as? String
                
                let trimSring:String = code!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                let countryName = dic?.object(forKey: "country_name") as? String
                let codeString = trimSring+" "+countryName!
                
                self.countryCodeArray.add(codeString)
                
            }
            
        } else {
            print("WARNING: Couldn't create dictionary from RecentSearch.plist! Default values will be used!")
        }
    }
    
}



extension UpdatePhoneVC{
    
    
    func checkvalidation(){
        
        var mess = ""
        
        if txtCountry.text == ""{
            
            mess = "Country code is required"
        }
        else if txtMobNo.text == ""{
            
            mess = "Enter Mobile Number".localized()
        }
        else if ((txtMobNo.text?.length ?? 15 > 14) || (txtMobNo.text?.length ?? 7 < 8)){
            
            mess = "Phone number length must be 8 - 14"
        }
        else{
            
            mess = ""
        }
        
        if mess == ""{
            
            self.apiCallForCheckNumberExistOrNot()
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
        
    }
    
    
    func apiCallForGetUserDetail(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param:[String:String] = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForUserDetail as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        if let response = receivedData.object(forKey: "response") as? NSDictionary{
                            
                            let countryCode = response.object(forKey: "countryCode") as? String ?? ""
                            let phoneNo = response.object(forKey: "mobileNumber") as? String ?? ""
                            
                            let countryName = response.object(forKey: "country") as? String ?? ""
                            
                            self.txtCountry.text = countryCode
                            self.txtMobNo.text = phoneNo
                            
                            UserDefaults.standard.set(countryName, forKey: "CountryName")
                            
                            UserDefaults.standard.setValue(countryCode, forKey: "CountryCode")
                            
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
    
    
    func apiCallForCheckNumberExistOrNot(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param:[String:String] = ["mobileNumber":txtMobNo.text!,"countryCode":txtCountry.text!]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForCheckMobileNumber as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.sendOtpUsingFirebase()
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToHome()
                        }
                        else{
                            
                            CommonClass.sharedInstance.callNativeAlert(title: "", message: msg.localized(), controller: self)
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
    
    func sendOtpUsingFirebase(){
        
        var completePhoneNumber = txtCountry.text!+txtMobNo.text!
        
        completePhoneNumber = String(completePhoneNumber.filter { !" \n\t\r".contains($0) })
        
        print(completePhoneNumber)
        IJProgressView.shared.showProgressView(view: self.view)
        
        PhoneAuthProvider.provider().verifyPhoneNumber(completePhoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                
                IJProgressView.shared.hideProgressView()
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "\(error)", controller: self)
                
                print(error)
                
              //  CommonClass.sharedInstance.callNativeAlert(title: "", message: "This mobile number is not registred with our system as user".localized() , controller: self)
                return
                
            }else{
                IJProgressView.shared.hideProgressView()
                print(verificationID!)
                UserDefaults.standard.set("\(verificationID!)", forKey: "OtpVerification")
                
                let vc = ScreenManager.getOtpVerifyVC()
                
                vc.navObj = self
                
                vc.phoneNumber = self.txtMobNo.text!
                
                vc.controllerPurpuse = "NumberEditing"
                
                self.present(vc, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    
}
