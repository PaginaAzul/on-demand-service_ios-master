//
//  SignupWithPhoneVC.swift
//  Joker
//
//  Created by Dacall soft on 11/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import Firebase


class SignupWithPhoneVC: UIViewController {

    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var txtCountry: UITextField!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var lblSignup: UILabel!
    
    let connection = webservices()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        lblSignup.text = "Sign Up".localized()
        txtPhoneNumber.placeholder = "Enter Mobile Number".localized()
        btnSubmit.setTitle("Send".localized(), for: .normal)
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tap_submitbtn(_ sender: Any) {
        
        checkValidation()
    }
    
    @IBAction func tap_countryBtn(_ sender: Any) {
        
    
    }
    
}


extension SignupWithPhoneVC{
    
    func checkValidation(){
        
        var mess = ""
        
        if txtPhoneNumber.text == ""{
            
            mess = "Enter mobile number".localized()
        }
        else if ((txtPhoneNumber.text?.length ?? 15 > 14) || (txtPhoneNumber.text?.length ?? 7 < 8)){
            
            mess = "Phone number length must be 8 - 14"
        }
        else{
            
            mess = ""
        }
        
        if mess == ""{
            apiCallForCheckNumberExistOrNot()
           // sendOtpUsingFirebase()
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
        
    }
    
    
    func sendOtpUsingFirebase(){
        
        let countryCode = UserDefaults.standard.value(forKey: "CountryCode") as? String ?? ""
        
        var completePhoneNumber = countryCode+txtPhoneNumber.text!
        
       // completePhoneNumber = completePhoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        
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
                vc.phoneNumber = self.txtPhoneNumber.text!
                self.present(vc, animated: true, completion: nil)
                
            }
        }
    }
    
    
    
    func apiCallForCheckNumberExistOrNot(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let countryCode = UserDefaults.standard.value(forKey: "CountryCode") as? String ?? ""
            
            let param:[String:String] = ["mobileNumber":txtPhoneNumber.text!,"countryCode":countryCode,"langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]
            
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
