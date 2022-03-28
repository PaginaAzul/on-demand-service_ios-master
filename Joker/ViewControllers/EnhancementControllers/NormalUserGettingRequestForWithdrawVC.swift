//
//  NormalUserGettingRequestForWithdrawVC.swift
//  Joker
//
//  Created by retina on 10/01/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit

class NormalUserGettingRequestForWithdrawVC: UIViewController {

    
    @IBOutlet weak var lblContent: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnOk: UIButton!
    
    
    var controllerPurpuse = ""
    
    var orderId = ""
    var nabObj = UIViewController()
    let connection = webservices()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.controllerPurpuse == "NormalProfessional"{
            
            self.lblContent.text = "Your professional captain ask for change captain?".localized()
        }
        else{
            
            self.lblContent.text = "Your delivery captain ask for change captain?"
        }
       
        btnOk.setTitle("OK".localized(), for: .normal)
        btnCancel.setTitle("Cancel".localized(), for: .normal)
    }

    @IBAction func tap_cancelBtn(_ sender: Any) {
        
        apiCallForRejectRequest()
    }
    
    @IBAction func tap_okBtn(_ sender: Any) {
        
        apiCallForAcceptRequest()
    }
    
}


extension NormalUserGettingRequestForWithdrawVC{
    
    func apiCallForRejectRequest(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","orderId":self.orderId]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForRejectWithdrawRequest as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.dismiss(animated: true, completion: nil)
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
    
    
    
    func apiCallForAcceptRequest(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","orderId":self.orderId,"langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForAcceptWithdrawRequest as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.dismiss(animated: true, completion: {
                            
                            if self.controllerPurpuse == "NormalProfessional"{
                                
                                //mention the seprator type
                                
                                UserDefaults.standard.setValue("RequestingProfessional", forKey: "SepratorType")
                            }
                            else{
                                
                                UserDefaults.standard.setValue("RequestingDelivery", forKey: "SepratorType")
                            }
                            
                            let vc = ScreenManager.getNormalUserWaitingForOfferVC()
                            
                            vc.orderID = self.orderId
                            
                            self.nabObj.navigationController?.pushViewController(vc, animated: false)
                            
                        })
                        
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
