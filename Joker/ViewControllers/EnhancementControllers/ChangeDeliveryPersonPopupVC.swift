//
//  ChangeDeliveryPersonPopupVC.swift
//  Joker
//
//  Created by retina on 30/08/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit


class ChangeDeliveryPersonPopupVC: UIViewController {
    
    
    @IBOutlet weak var lblContent: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnOk: UIButton!
    
    
    var nabObj = UIViewController()
    var orderID = ""
    
    let connection = webservices()
    
    var controllerUsingFor = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if controllerUsingFor == "NormalProfessional"{
            
            lblContent.text = "Do you really want to change professional captain?".localized()
        }
        else{
            
            
        }
        
        btnCancel.setTitle("Cancel".localized(), for: .normal)
        btnOk.setTitle("OK".localized(), for: .normal)
    }
    
    @IBAction func tap_cancelBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tap_OkBtn(_ sender: Any) {
        
        apiCallForChangeDeliveryPerson()
    }
    
}


//MARK:- Webservices
//MARK:-
extension ChangeDeliveryPersonPopupVC{
    
    func apiCallForChangeDeliveryPerson(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","orderId":self.orderID,"langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForChangeDeliveryPerson as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.dismiss(animated: true, completion: {
                            
                            if self.controllerUsingFor == "NormalProfessional"{
                                
                                //mention the seprator type
                                
                                UserDefaults.standard.setValue("RequestingProfessional", forKey: "SepratorType")
                            }
                            else{
                                
                                UserDefaults.standard.setValue("RequestingDelivery", forKey: "SepratorType")
                            }
                            
                            let vc = ScreenManager.getNormalUserWaitingForOfferVC()
                            
                            vc.orderID = self.orderID
                            
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
