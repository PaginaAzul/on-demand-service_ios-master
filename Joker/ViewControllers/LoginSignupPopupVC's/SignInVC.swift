//
//  SignInVC.swift
//  Joker
//
//  Created by Apple on 18/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import FirebaseAuth
import FirebaseCore
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var mobileNoTxtField: UITextField!
    
    @IBOutlet weak var countryCodeTxtFld: UITextField!
    
    @IBOutlet weak var lblNav: UILabel!
    
    var countryCodeArray = NSMutableArray()
    var arrayFromPlist = NSMutableArray()
    
    var countryCodeCheck = false
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intialise()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        submitBtn.setTitle("Send".localized(), for: .normal)
        mobileNoTxtField.placeholder = "Enter Mobile Number".localized()
        lblNav.text = "SignIn".localized()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool){
        
        super.viewDidAppear(true)
        loadPlistDataatLoadTime()
        
        if countryCodeCheck == false{
            
            if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String
            {
                for i in 0 ..< self.arrayFromPlist.count
                {
                    if let dic = self.arrayFromPlist.object(at: i) as? NSDictionary
                    {
                        if countryCode == dic.object(forKey: "country_code") as! String
                        {
                            
                            let countryName = dic.object(forKey: "country_name") as? String ?? ""
                            
                            let plusCCode = dic.object(forKey: "country_dialing_code") as? String ?? ""
                            
                            countryCodeTxtFld.text = "\(plusCCode)"
                            
                            print(countryCode)
                            //US,,IN,,CA
                            
                            // UserDefaults.standard.set("\(countryCode)", forKey: "CountryName")
                            
                            UserDefaults.standard.set(countryName, forKey: "CountryName")
                            
                            UserDefaults.standard.setValue(plusCCode, forKey: "CountryCode")
                        }
                    }
                }
            }
            
            countryCodeCheck = true
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func tap_SubmitBtn(_ sender: UIButton) {
        
        UserDefaults.standard.set("Signin", forKey: "AuthenticationPurpuse")
        
        //        let vc = ScreenManager.getOtpVerifyVC()
        //
        //        vc.navObj = self
        //
        //        self.present(vc, animated: true, completion: nil)
        
        
        
        
        //Real - Uncomment After module has been completed!!
        checkvalidation()
        
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_countryCodeBtn(_ sender: Any) {
        
        showCountryPicker()
    }
    
    
}


extension SignInVC{
    
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
            
            self.countryCodeTxtFld.text = "\(countryCode)"
            
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



extension SignInVC{
    
    func intialise()
    {
        headerView.backgroundColor = UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00)
        
        mobileNoTxtField.placeHolderColor = UIColor(red: 30.0/255, green: 30.0/255, blue: 30.0/255, alpha: 1.0)
    }
    
    func pushToPopupVC(){
        
        let vc = ScreenManager.getPopupVC()
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func checkvalidation(){
        
        var mess = ""
        
        if countryCodeTxtFld.text == ""{
            
            mess = "Select Your Country"
        }
        else if mobileNoTxtField.text == ""{
            
            mess = "Enter mobile number".localized()
        }
        else if ((mobileNoTxtField.text?.length ?? 15 > 14) || (mobileNoTxtField.text?.length ?? 7 < 8)){
            
            mess = "Phone number length must be 8 - 14"
        }
        else{
            
            mess = ""
        }
        
        
        if mess == ""{
            
            // sendOtpUsingFirebase()
            
            //uncomment the firebase line for real device for simulator we are doing login the user without otp in testing mode
            
            //self.apiCallForLogin()
            
            apiCallForCheckNumberExistOrNot()
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
            
        }
        
    }
    
    
    func sendOtpUsingFirebase(){
        
        let countryCode = UserDefaults.standard.value(forKey: "CountryCode") as? String ?? ""
        
        var completePhoneNumber = countryCode+mobileNoTxtField.text!
        
        completePhoneNumber = String(completePhoneNumber.filter { !" \n\t\r".contains($0) })
        
        print(completePhoneNumber)
        IJProgressView.shared.showProgressView(view: self.view)
        
        PhoneAuthProvider.provider().verifyPhoneNumber(completePhoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                
                IJProgressView.shared.hideProgressView()
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: "\(error)", controller: self)
                
                // CommonClass.sharedInstance.callNativeAlert(title: "", message: "This mobile number is not registred with our system as user".localized() , controller: self)
                
                print(error)
                
                return
                
            }else{
                IJProgressView.shared.hideProgressView()
                print(verificationID!)
                UserDefaults.standard.set("\(verificationID!)", forKey: "OtpVerification")
                
                let vc = ScreenManager.getOtpVerifyVC()
                
                vc.navObj = self
                
                vc.phoneNumber = self.mobileNoTxtField.text!
                
                self.present(vc, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
}


extension SignInVC:DismissAndPushDelegate{
    
    func getControllerStatus(status: String) {
        
        if status == "Yes"{
            
            self.pushToPopupVC()
        }
    }
}

//setting for simulator remove at time of live or send build
//
extension SignInVC{
    
    func apiCallForLogin(){
        
        let countryCode = UserDefaults.standard.value(forKey: "CountryCode") as? String ?? ""
        
        let deviceToken = UserDefaults.standard.value(forKey: "DeviceToken") as? String ?? ""
        
        let param:[String:String] = ["countryCode":countryCode,"mobileNumber":mobileNoTxtField.text!,"deviceType":"iOS","deviceToken":deviceToken,"userType":"User"]
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForSignIn as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        UserDefaults.standard.set(true, forKey: "IsUserLogin")
                        
                        let responseData = receivedData.object(forKey: "response") as? NSDictionary ?? [:]
                        
                        let nameOfUser = responseData.object(forKey: "name") as? String ?? ""
                        
                        let userToken = responseData.object(forKey: "jwtToken") as? String ?? ""
                        UserDefaults.standard.set(userToken, forKey: "UserAuthorizationToken")
                        
                        let userID = responseData.object(forKey: "_id") as? String ?? ""
                        UserDefaults.standard.set(userID, forKey: "UserID")
                        
                        let data = NSKeyedArchiver.archivedData(withRootObject: responseData)
                        UserDefaults.standard.set(data, forKey: "USER_DATA")
                        
                        //                        weak var pvc = self.presentingViewController
                        //                        self.dismiss(animated: false, completion:{
                        //
                        //                            let vc = ScreenManager.getPopupVC()
                        //                            vc.controllerName = ""
                        //                            vc.userName = nameOfUser
                        //
                        //                            pvc?.present(vc, animated: true, completion: nil)
                        //
                        //                        })
                        
                        let vc = ScreenManager.getPopupVC()
                        vc.controllerName = ""
                        vc.userName = nameOfUser
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                    else{
                        
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
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
            
            let param:[String:String] = ["mobileNumber":mobileNoTxtField.text!,"countryCode":countryCodeTxtFld.text!,"langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.checkNumberForSignin as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    
                    if status == "SUCCESS"{
                        
                        /*
                         if self.mobileNoTxtField.text! == "9872336814" || self.mobileNoTxtField.text! == "8868882528" {
                         
                         IJProgressView.shared.hideProgressView()
                         
                         let vc = ScreenManager.getOtpVerifyVC()
                         
                         vc.navObj = self
                         
                         vc.phoneNumber = self.mobileNoTxtField.text!
                         
                         self.present(vc, animated: true, completion: nil)
                         
                         }else{
                         self.sendOtpUsingFirebase()
                         }
                         */
                        
                        self.sendOtpUsingFirebase()
                        
                        
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: msg.localized(), controller: self)
                        
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


//prince - 8077796487
