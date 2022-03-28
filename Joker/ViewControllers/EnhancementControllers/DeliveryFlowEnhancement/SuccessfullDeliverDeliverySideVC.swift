//
//  SuccessfullDeliverDeliverySideVC.swift
//  Joker
//
//  Created by retina on 13/09/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class SuccessfullDeliverDeliverySideVC: UIViewController {

    var navObj = UIViewController()
 
    @IBOutlet weak var lblHeader: UILabel!
    
    @IBOutlet weak var lblContent: UILabel!
    
    var controllerPurpuse = ""
    
    var controllerUserType = ""
    
    var orderId = ""
    var ratingToUserId = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.controllerUserType == ""{
            
            //in case of delivery worker
            
            if controllerPurpuse == "WithdrawOffer"{
                
                lblHeader.text = "Successfull!!"
                lblContent.text = "Your request has been send to the customer. Please wait to get reply from customer"
            }
        }
        else{
            
            //in case of professional worker
            
            if controllerPurpuse == "WithdrawOffer"{
                
                lblHeader.text = "Successfull!!"
                lblContent.text = "Your request has been send to the customer. Please wait to get reply from customer"
            }
            else{
                
                lblHeader.text = "Great!!"
                lblContent.text = "You completed the service successfully."
            }
           
        }
        
    }
    
    @IBAction func tap_okBtn(_ sender: Any) {
        
        if self.controllerUserType == ""{
            
            //using for delivery flow
            
            if controllerPurpuse == "WithdrawOffer"{
                
//                UserDefaults.standard.set(true, forKey: "RootApply")
//
//                let vc = ScreenManager.getDeliveryPersonScrollManagerVC()
//                let navController = UINavigationController(rootViewController: vc)
//                navController.navigationBar.isHidden = true
//                appDelegate.window?.rootViewController = navController
//                appDelegate.window?.makeKeyAndVisible()
                
                self.dismiss(animated: true, completion: nil)
                
            }
            else{
                
                self.dismiss(animated: true) {
                    
                    let vc = ScreenManager.getReviewAndRatingVC()
                    vc.isComing = "DELIVERY"
                    
                    vc.ratingPurpuse = "OrderRating"
                    
                    vc.orderId = self.orderId
                    vc.ratingToUserId = self.ratingToUserId
                    vc.ratingToTypeUser = "NormalUser"
                    vc.ratingByTypeUser = "DeliveryPerson"
                    
                    UserDefaults.standard.set("", forKey: "ISCOMIMG_RATINGPOPUP")
                    
                    self.navObj.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        else{
            
            //using for professional flow
            
            if controllerPurpuse == "WithdrawOffer"{
                
//                UserDefaults.standard.set(true, forKey: "RootApplyForProfessional")
//
//                let vc = ScreenManager.getProfessionalWorkerScrollManagerVC()
//                let navController = UINavigationController(rootViewController: vc)
//                navController.navigationBar.isHidden = true
//                self.appDelegate.window?.rootViewController = navController
//                self.appDelegate.window?.makeKeyAndVisible()
                
                self.dismiss(animated: true, completion: nil)
                
            }
            else{
                
                self.dismiss(animated: true) {
                    
                    let vc = ScreenManager.getReviewAndRatingVC()
                    vc.isComing = "PROFESSIONAL"
                    
                    vc.ratingPurpuse = "OrderRating"
                    
                    vc.orderId = self.orderId
                    vc.ratingToUserId = self.ratingToUserId
                    vc.ratingToTypeUser = "NormalUser"
                    vc.ratingByTypeUser = "ProfessionalWorker"
                    
                    UserDefaults.standard.set("", forKey: "ISCOMIMG_RATINGPOPUP")
                    
                    self.navObj.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }
        
    }
    
    
}
