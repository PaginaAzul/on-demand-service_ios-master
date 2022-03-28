//
//  MarketingLoremAlert.swift
//  Joker
//
//  Created by Apple on 23/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class MarketingLoremAlert: UIViewController {

    @IBOutlet weak var headerView: UIView!
    
    
    @IBOutlet weak var lblHeader: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var nabObj = UIViewController()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var controllerPurpuse = ""
    var userType = ""
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialise()
        
    }

    @IBAction func tap_closeBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tap_agreeBtn(_ sender: Any) {
        
//        let vc = ScreenManager.getServiceProviderMapVC()
//        let navController = UINavigationController(rootViewController: vc)
//        navController.navigationBar.isHidden = true
//        appDelegate.window?.rootViewController = navController
//        appDelegate.window?.makeKeyAndVisible()
        
        
        if controllerPurpuse == ""{
            
            weak var pvc = self.presentingViewController
            self.dismiss(animated: false, completion:{
                
                let vc = ScreenManager.getInstructionsVC()
                // self.present(vc, animated: true, completion: nil)
                pvc?.present(vc, animated: true, completion: nil)
                
            })
        }
        else{
            
//            weak var pvc = self.presentingViewController
//            self.dismiss(animated: false, completion:{
//
//                let vc = ScreenManager.getPopupVC()
//                vc.navObj = self.nabObj
//                vc.controllerName = "OfferSubmitted"
//                pvc?.present(vc, animated: true, completion: nil)
//
//            })
            
            if userType == "Delivery"{
                
                let requestId = UserDefaults.standard.value(forKey: "RequestDeliveryID") as? String ?? ""
                
                self.apiCallForSubmitOrderSuccessFully(orderId: requestId)
            }
            else{
                
                let requestId = UserDefaults.standard.value(forKey: "RequestDeliveryID") as? String ?? ""
                
                self.apiCallForSubmitOrderSuccessFully(orderId: requestId)
            }
            
        }
        
    }
    
    @IBAction func tap_disagreeBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MarketingLoremAlert {
    
    func initialise()
    {
        headerView.backgroundColor = UIColor(red: 190.0/255, green: 113.0/255, blue: 252.0/255, alpha: 1.0)
        
        
        let data = UserDefaults.standard.value(forKey: "WalkInArr") as! NSData
        let walkInDataArr = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! NSArray
        
        for i in 0..<walkInDataArr.count{
            
            let dict = walkInDataArr.object(at: i) as? NSDictionary ?? [:]
            let type = dict.object(forKey: "Type") as? String ?? ""
            
            if type == "Instruction"{
                
                lblTitle.text = dict.object(forKey: "description") as? String ?? ""
                
                break
            }
        }
        
    }
    
}


//MARK:- Webservices
//MARK:-
extension MarketingLoremAlert{
    
    func apiCallForSubmitOrderSuccessFully(orderId:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param:[String:String] = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","orderId":orderId]
            
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
                            vc.navObj = self.nabObj
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
