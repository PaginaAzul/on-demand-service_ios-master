//
//  TermsAndConditionsPopUPVC.swift
//  Joker
//
//  Created by Apple on 22/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class TermsAndConditionsPopUPVC: UIViewController {

    @IBOutlet weak var lblTermsAndCond: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var checkBoxBtn: UIButton!
    
    @IBOutlet weak var lblTermsLeadingConstraint: NSLayoutConstraint!
    
    var navObj = UIViewController()
    
    var userType = ""
    
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.value(forKey: "AuthenticationPurpuse") as? String ?? "" == "Signin"{
            
            lblTermsLeadingConstraint.constant = 10
            checkBoxBtn.isHidden = true
        }
        else{
            
            checkBoxBtn.isHidden = false
        }
        
        initialise()
        
    }
   
    @IBAction func tap_checkBoxBtn(_ sender: Any) {
        
    }
    
    @IBAction func tap_okBtn(_ sender: Any) {
        
//        weak var pvc = self.presentingViewController
//        self.dismiss(animated: false, completion:{
//
//            let vc = ScreenManager.getPopupVC()
//            vc.navObj = self.navObj
//            vc.controllerName = "OfferSubmitted"
//            pvc?.present(vc, animated: true, completion: nil)
//
//        })
        
        if userType == "Delivery"{
            
            let requestId = UserDefaults.standard.value(forKey: "RequestDeliveryID") as? String ?? ""
            
            self.apiCallForSubmitOrderSuccessFully(orderId: requestId)
        }
        else{
            
            let requestId = UserDefaults.standard.value(forKey: "RequestDeliveryID") as? String ?? ""
            
            self.apiCallForSubmitOrderSuccessFully(orderId: requestId)
            
        }
    }
    
    @IBAction func tap_cancelBtn(_ sender: Any) {
        
        UserDefaults.standard.set("", forKey: "RequestDeliveryID")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


extension TermsAndConditionsPopUPVC{
    
    func initialise()
    {
        headerView.backgroundColor = UIColor(red: 190.0/255, green: 113.0/255, blue: 252.0/255, alpha: 1.0)
        
        let normalText1  = "I agree to the "
        let normalText2 = "Terms & Conditions "
        let myMutableString1 = NSMutableAttributedString()
        let myMutableString2 = NSAttributedString(string: "\(normalText1) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :UIColor.black])
        
        
        let myMutableString4 = NSAttributedString(string: "\(normalText2) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :UIColor(red: 88.0/255, green: 189.0/255, blue: 218.0/255, alpha: 1.0)] )
        
        
        
        myMutableString1.append(myMutableString2)
        myMutableString1.append(myMutableString4)
        lblTermsAndCond.attributedText = myMutableString1
        
    }
    
}


extension TermsAndConditionsPopUPVC{
    
    func apiCallForSubmitOrderSuccessFully(orderId:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param:[String:String] = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","orderId":orderId]
            
            print(param)
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForSubmitOrder as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        UserDefaults.standard.removeObject(forKey: "RequestDeliveryID")
                        
                        weak var pvc = self.presentingViewController
                        self.dismiss(animated: false, completion:{
                        
                            let vc = ScreenManager.getPopupVC()
                            vc.navObj = self.navObj
                            vc.controllerName = "OfferSubmitted"
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
