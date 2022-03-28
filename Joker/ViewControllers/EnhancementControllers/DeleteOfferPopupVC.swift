//
//  DeleteOfferPopupVC.swift
//  Joker
//
//  Created by retina on 30/08/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class DeleteOfferPopupVC: UIViewController {

    
    @IBOutlet weak var viewDropdown: UIView!
    
    @IBOutlet weak var txtMsg: UITextView!
    
    @IBOutlet weak var txtSelectReason: UITextField!
    
    @IBOutlet weak var viewTxtHolder: UIView!
    
    //really?small
    @IBOutlet weak var lblDoYouWantToDeleteThisOffer: UILabel!
    
    @IBOutlet weak var btnNoLongerNeedIt: UIButton!
    
    @IBOutlet weak var btnCaptainWillBeLate: UIButton!
    
    @IBOutlet weak var btnOther: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnOk: UIButton!
    
    
    
    var counterCheck = 0
    
    let connection = webservices()
    
    var orderID = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewDropdown.isHidden = true
       
        self.txtMsg.text = "Message".localized()
        self.txtMsg.delegate = self
        
        btnNoLongerNeedIt.setTitle("No longer need it".localized(), for: .normal)
        btnCaptainWillBeLate.setTitle("Captain will be late".localized(), for: .normal)
        btnOther.setTitle("Other".localized(), for: .normal)
        btnCancel.setTitle("Cancel".localized(), for: .normal)
        btnOk.setTitle("OK".localized(), for: .normal)
        
        lblDoYouWantToDeleteThisOffer.text = "Do you really want to delete this offer?".localized()
        
        txtSelectReason.placeholder = "Select Reason".localized()
    }
    
    @IBAction func tap_cancelBtn(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tap_okBtn(_ sender: Any) {
        
        checkValidation()
    }
    
    @IBAction func tap_selectReasonBtn(_ sender: Any) {
        
        if counterCheck == 0{
            
            self.viewTxtHolder.isHidden = true
            self.viewDropdown.isHidden = false
            self.counterCheck = 1
        }
        else{
            
            self.counterCheck = 0
            self.viewTxtHolder.isHidden = false
            self.viewDropdown.isHidden = true
        }
    }
    
    @IBAction func btnNoLonger(_ sender: Any) {
        
        self.counterCheck = 0
        self.viewTxtHolder.isHidden = false
        self.viewDropdown.isHidden = true
        
        self.txtSelectReason.text = "No longer need it".localized()
    }
    
    @IBAction func btnCaptainLate(_ sender: Any) {
        
        self.counterCheck = 0
        self.viewTxtHolder.isHidden = false
        self.viewDropdown.isHidden = true
        
        self.txtSelectReason.text = "Captain will be late".localized()
    }
    
    @IBAction func btnOther(_ sender: Any) {
        
        self.counterCheck = 0
        self.viewTxtHolder.isHidden = false
        self.viewDropdown.isHidden = true
        
        self.txtSelectReason.text = "Other".localized()
    }
    
    
}


extension DeleteOfferPopupVC:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if txtMsg.text == "Message".localized(){
            
            txtMsg.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txtMsg.text == ""{
            
            txtMsg.text = "Message".localized()
        }
    }
}


extension DeleteOfferPopupVC{
    
    func checkValidation(){
        
        if txtSelectReason.text == ""{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please select reason".localized(), controller: self)
        }
        else{
            
            var txt = ""
            
            if txtMsg.text == "Message".localized(){
                
                txt = ""
            }
            
            self.apiCallForCancellation(description: txt)
            
        }
    }
    
    
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
                        
                        let alertController = UIAlertController(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            
                            let vc = ScreenManager.getServiceProviderMapVC()
                            let navController = UINavigationController(rootViewController: vc)
                            navController.navigationBar.isHidden = true
                            self.appDelegate.window?.rootViewController = navController
                            self.appDelegate.window?.makeKeyAndVisible()
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
    
}
