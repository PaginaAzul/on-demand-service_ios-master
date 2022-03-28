//
//  InstructionPopupVC.swift
//  Joker
//
//  Created by retina on 30/08/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit


protocol InstructionDismissDelegate{
    
    func instructionDismissle(status:String)
}

class InstructionPopupVC: UIViewController {

    @IBOutlet weak var lblInstructionTxt: UILabel!
    
    @IBOutlet weak var lblInstructionHeading: UILabel!
    
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var okBtn: UIButton!
    
    var nabObj = UIViewController()

    let connection = webservices()
    
    var controllerPurpuse = ""
    
    var delegate:InstructionDismissDelegate?
    var attachmentArr = NSMutableArray()
    var normalUserPendingArr = NSArray()
    var category = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        if controllerPurpuse == ""{
            
            
        }
        else{
            
            backBtn.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        lblInstructionHeading.text = "Instructions".localized()
        lblInstructionTxt.text = "Paginazul collects, uses, maintains information collected from users (each, a User)".localized()
        backBtn.setTitle("Back".localized(), for: .normal)
        okBtn.setTitle("OK".localized(), for: .normal)
    }
    
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tap_okBtn(_ sender: Any) {
        
        if controllerPurpuse == ""{
           
                      if UserDefaults.standard.value(forKey: "attachmentArrOrder") != nil {
                          
                          if let arrayValue = UserDefaults.standard.value(forKey: "attachmentArrOrder"){
                            self.attachmentArr = arrayValue as? NSMutableArray ?? NSMutableArray()
                          }
                      }
            
            self.apiCallForRequestOrder(param: UserDefaults.standard.value(forKey: "paramOrder") as! [String : String])
            
//            let requestId = UserDefaults.standard.value(forKey: "RequestDeliveryID") as? String ?? ""
//
//            self.apiCallForSubmitOrderSuccessFully(orderId: requestId)
            
        }
        else{
            
            self.dismiss(animated: true, completion: {
               
                  self.delegate?.instructionDismissle(status: "yes")
            })
            
        }
      
    }
    

}


//MARK:- Webservices
//MARK:-
extension InstructionPopupVC{
    
    func apiCallForSubmitOrderSuccessFully(orderId:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param:[String:String] = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","orderId":orderId,"langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForSubmitOrder as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        UserDefaults.standard.removeObject(forKey: "RequestDeliveryID")
                    
                        self.dismiss(animated: false, completion:{
                            
                           let dict = receivedData.object(forKey: "response") as? NSDictionary
                            
                            
                            print("CATEGORY", dict?.object(forKey: "portugueseCategoryName") as? String ?? "")
                            
                            let vc = ScreenManager.getNormalUserWaitingForOfferVC()
                            
                            if Localize.currentLanguage() == "en"{
                                vc.category = dict?.object(forKey: "selectCategoryName") as? String ?? ""
                                self.category = dict?.object(forKey: "selectCategoryName") as? String ?? ""
                            }else{
                                vc.category = dict?.object(forKey: "portugueseCategoryName") as? String ?? ""
                                self.category = dict?.object(forKey: "portugueseCategoryName") as? String ?? ""
                            }
                            
                            vc.orderID = orderId
                            
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
    
    
    func apiCallForRequestOrder(param:[String:String]){

        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            
           
            
          //  attachmentArr = UserDefaults.standard.value(forKey: "attachmentArrOrder") as? NSMutableArray
            
            self.connection.startConnectionWithArray(getUrlString: App.URLs.apiCallForRequestOrder as NSString, fileArr: attachmentArr , ArrayParam: "orderImages[]", method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        if let dataDict = receivedData.object(forKey: "Data") as? NSDictionary{
                            
                            let requestId = dataDict.object(forKey: "_id") as? String ?? ""
                            
                            UserDefaults.standard.set(requestId, forKey: "RequestDeliveryID")
                            
                            let requestId1 = UserDefaults.standard.value(forKey: "RequestDeliveryID") as? String ?? ""
                            
                            self.apiCallForSubmitOrderSuccessFully(orderId: requestId1)
                            
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
    
}
