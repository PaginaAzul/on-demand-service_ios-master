//
//  CancellationVC.swift
//  Joker
//
//  Created by Callsoft on 31/01/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import DropDown

class CancellationVC: UIViewController {

    
    @IBOutlet weak var navLbl: UILabel!
    
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var btnReason: UIButton!
    
    
    @IBOutlet weak var txtSelectReason: UITextField!
    
    @IBOutlet weak var btnSubmit: UIButton!
    var reportOrder = String()
    var reportType = ""
    
    var controllerPurpuse = ""
    
    var orderID = ""
    
    var cancellationDropArr = ["No longer need it".localized(),"Captain will be late".localized(),"Other".localized()]
    
    var reportDropArr = ["Inappropriate User".localized(),"Seems like a fake user".localized(),"Other".localized()]
    
    var contactAdminArr = ["Want to submit complain".localized(),"Want to provide feedback".localized(),"Other".localized()]
    
    let connection = webservices()
    let dropDown = DropDown()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtView.delegate = self
        
        if controllerPurpuse == ""{
            
            navLbl.text = "Cancellation".localized()
            txtView.text = "Write reason for cancellation...".localized()
        }
        else if controllerPurpuse == "ContactAdmin"{
            
            if reportOrder == "" {
              navLbl.text = "Contact Admin".localized()
            }else{
                
                let currentLanguage = Localize.currentLanguage()
                
                print("currentLanguage")
                if currentLanguage == "en"{
                    navLbl.text = "Contact Admin".localized()
                }else{
                    navLbl.text = "Report Order".localized()
                }
                
            }
           // navLbl.text = "Contact Admin".localized()
            txtView.text = "Write here Reason...".localized()
        }
        else{
            
            navLbl.text = "Report Order!".localized()
            txtView.text = "Write here Reason...".localized()
        }
        
        txtSelectReason.placeholder = "Select Reason".localized()
        btnSubmit.setTitle("Send".localized(), for: .normal)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            self.txtSelectReason.text = "\(item)"
            
        }
        
    }
    
    
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_submitBtn(_ sender: Any) {
        
        checkValidation()
    }
    
    @IBAction func tap_selectReasonBtn(_ sender: Any) {
        
        dropDown.anchorView = btnReason
        
        if controllerPurpuse == "ContactAdmin"{
            
            dropDown.dataSource = contactAdminArr
        }
        else{
            
            if controllerPurpuse == ""{
                
                dropDown.dataSource = cancellationDropArr
            }
            else{
                
                dropDown.dataSource = reportDropArr
            }
            
        }
        
        dropDown.show()
    }
    
}

extension CancellationVC{
    
    func checkValidation(){
        
        var mess = ""
        
        if txtSelectReason.text == ""{
            
            mess = "Please select the reason"
        }
        else{
            
            mess = ""
        }
        
        
        if mess == ""{
            
            var descTxt = ""
            
            if txtView.text == "" || txtView.text == "Write reason for cancellation...".localized() || txtView.text == "Write here Reason...".localized(){
                
                descTxt = ""
            }
            else{
                
                descTxt = txtView.text!
            }
            
            
            if controllerPurpuse == ""{
                
                //api call for cancellation
                
                self.apiCallForCancellation(description: descTxt)
                
            }
            else if controllerPurpuse == "ContactAdmin"{
                
                // api for contact admin
                
                self.apiCallForContactAdmin(description: descTxt)
            }
            else{
                
                //api call for report
                
                if self.reportType == "NormalUser"{
                    
                    self.apiCallForReportByNormalUser(description: descTxt)
                }
                else{
                    
                    self.apiCallForReport(description: descTxt)
                }
               
            }
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
    }
}


extension CancellationVC:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if self.controllerPurpuse == ""{
            
            if txtView.text == "Write reason for cancellation...".localized(){
                
                txtView.text = ""
            }
        }
        else{
            
            if txtView.text == "Write here Reason...".localized(){
                
                txtView.text = ""
            }
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if self.controllerPurpuse == ""{
            
            if txtView.text == ""{
                
                txtView.text = "Write reason for cancellation...".localized()
            }
        }
        else{
            
            if txtView.text == ""{
                
                txtView.text = "Write here Reason...".localized()
            }
        }
    }
}


extension CancellationVC{
    
    func apiCallForCancellation(description:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","orderId":orderID,"orderCanelReason":txtSelectReason.text!,"orderCancelMessage":description,"langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForCancelOrder as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let alertMsg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        let alertController = UIAlertController(title: "", message: alertMsg.localized() , preferredStyle: .alert)
                        
                        
                        let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default) {
                            UIAlertAction in
                       
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                        alertController.addAction(okAction)
                     
                        self.present(alertController, animated: true, completion: nil)
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
    
    
    func apiCallForReport(description:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","orderId":orderID,"orderIssueReason":txtSelectReason.text!,"orderIssueMessage":description,"langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForReportOrder as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        
                        let alertMsg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        let alertController = UIAlertController(title: "", message: alertMsg.localized() , preferredStyle: .alert)
                        
                        
                        let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                        alertController.addAction(okAction)
                        
                        self.present(alertController, animated: true, completion: nil)
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
    
    
    //////////
    //orderReportByNormalUser
    
    func apiCallForReportByNormalUser(description:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","orderId":orderID,"orderIssueReason":txtSelectReason.text!,"orderIssueMessage":description,"langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.orderReportByNormalUser as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let alertMsg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        
                        let alertController = UIAlertController(title: "", message: alertMsg.localized() , preferredStyle: .alert)
                        
                        
                        let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                        alertController.addAction(okAction)
                        
                        self.present(alertController, animated: true, completion: nil)
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
    
    
    //api for contact admin
    
    func apiCallForContactAdmin(description:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","reason":txtSelectReason.text!,"description":description,"langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForContactToAdmin as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let alertMsg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        let alertController = UIAlertController(title: "", message: alertMsg.localized() , preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                        alertController.addAction(okAction)
                        
                        self.present(alertController, animated: true, completion: nil)
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
                    
                    
                }
            }
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
    
    
}
