//
//  WithdrawOfferVC.swift
//  Joker
//
//  Created by retina on 10/09/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class WithdrawOfferVC: UIViewController {

    @IBOutlet weak var btnStoreLocationIsFar: UIButton!
    
    @IBOutlet weak var btnDontWantToDeliver: UIButton!
    
    var reason = ""
    
    let connection = webservices()
    
    var orderID = ""
    
    var controllerIsUsingFor = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if controllerIsUsingFor == "ProfessionalWorker"{
            
            btnStoreLocationIsFar.setTitle("Service location is far", for: .normal)
            btnDontWantToDeliver.setTitle("I don't want to deliver it", for: .normal)
        }
        
    }
    
    @IBAction func tap_cancelBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tap_okBtn(_ sender: Any) {
        
        if reason == ""{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please select the reason", controller: self)
        }
        else{
            
            self.apiCallForCancellation()
        }
    }
    
    @IBAction func tap_storeLocationIsfar(_ sender: Any) {
        
        btnStoreLocationIsFar.backgroundColor = UIColor(red:0.79, green:0.56, blue:0.98, alpha:1.0)
        
        btnDontWantToDeliver.backgroundColor = UIColor.white
        
        if controllerIsUsingFor == "ProfessionalWorker"{
            
            reason = "Service location is far"
        }
        else{
            
            reason = "Store location is far"
        }
       
    }
    
    @IBAction func tap_iDonWantToDeliver(_ sender: Any) {
        
        btnDontWantToDeliver.backgroundColor = UIColor(red:0.79, green:0.56, blue:0.98, alpha:1.0)
        
        btnStoreLocationIsFar.backgroundColor = UIColor.white
        
        if controllerIsUsingFor == "ProfessionalWorker"{
            
            reason = "I don't want to serve it"
        }
        else{
            
            reason = "I don't want to deliver it"
        }
        
       
    }
    
}

extension WithdrawOfferVC{
    
    func apiCallForCancellation(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","orderId":orderID,"orderCanelReason":reason,"orderCancelMessage":""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForWithdrawRequestByCaptain as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        weak var pvc = self.presentingViewController
                        
                        self.dismiss(animated: false, completion:{
                            
                            let vc = ScreenManager.getSuccessfullDeliverDeliverySideVC()
                            
                            vc.controllerPurpuse = "WithdrawOffer"
                            
                            vc.controllerUserType = self.controllerIsUsingFor
                            
                            pvc?.present(vc, animated: true, completion: nil)
                            
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
