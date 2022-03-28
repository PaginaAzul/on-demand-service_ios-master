//
//  OrderCancelFromDeliverySideVC.swift
//  Joker
//
//  Created by retina on 09/09/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class OrderCancelFromDeliverySideVC: UIViewController {

    @IBOutlet weak var txtSelectReason: UITextField!
    
    @IBOutlet weak var viewReasonListing: UIView!
    
    @IBOutlet weak var popupHeightConstraint: NSLayoutConstraint!
    
    var sendTxtInApi = ""
    let connection = webservices()
    var orderID = ""
    var navObj = UIViewController()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var controllerPurpuse = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    @IBAction func btnSelectReason(_ sender: Any) {
        
        viewReasonListing.isHidden = false
        popupHeightConstraint.constant = 365
    }
    
    @IBAction func tap_deliveryLocationFarBtn(_ sender: Any) {
        
        setTxtAndManageHeight(txt: "Delivery Location is far away")
    }
    
    @IBAction func tap_iwillNotAbleBtn(_ sender: Any) {
        
        setTxtAndManageHeight(txt: "I will not able to deliver this order on time")
    }
    
    @IBAction func tap_buyerNotReplyingBtn(_ sender: Any) {
        
        setTxtAndManageHeight(txt: "Buyer is not replying")
    }
    
    @IBAction func tap_otherBtn(_ sender: Any) {
        
        setTxtAndManageHeight(txt: "Other")
    }
    
    @IBAction func tap_cancelBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tap_okBtn(_ sender: Any) {
        
        self.checkValidation()
    }
    
}

extension OrderCancelFromDeliverySideVC{
    
    func initialSetup(){
        
        viewReasonListing.isHidden = true
        popupHeightConstraint.constant = 200
    }
    
    func setTxtAndManageHeight(txt:String){
        
        txtSelectReason.text = txt
        
        self.sendTxtInApi = txt
        
        viewReasonListing.isHidden = true
        popupHeightConstraint.constant = 200
        
    }
}


extension OrderCancelFromDeliverySideVC{
    
    func checkValidation(){
        
        if txtSelectReason.text == ""{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please select the reason", controller: self)
        }
        else{
            
            self.apiCallForCancellation()
        }
    }
    
    
    func apiCallForCancellation(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","orderId":orderID,"orderCanelReason":txtSelectReason.text!,"orderCancelMessage":""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForOrderCancelByDelivery as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let alertController = UIAlertController(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", preferredStyle: .alert)
                        
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            
                            if self.controllerPurpuse == ""{
                                
                                UserDefaults.standard.set(true, forKey: "RootApply")
                                
                                let vc = ScreenManager.getDeliveryPersonScrollManagerVC()
                                let navController = UINavigationController(rootViewController: vc)
                                navController.navigationBar.isHidden = true
                                self.appDelegate.window?.rootViewController = navController
                                self.appDelegate.window?.makeKeyAndVisible()
                                
                            }
                            else{
                                
                                UserDefaults.standard.set(true, forKey: "RootApplyForProfessional")
                                
                                let vc = ScreenManager.getProfessionalWorkerScrollManagerVC()
                                let navController = UINavigationController(rootViewController: vc)
                                navController.navigationBar.isHidden = true
                                self.appDelegate.window?.rootViewController = navController
                                self.appDelegate.window?.makeKeyAndVisible()
                            }
                            
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
