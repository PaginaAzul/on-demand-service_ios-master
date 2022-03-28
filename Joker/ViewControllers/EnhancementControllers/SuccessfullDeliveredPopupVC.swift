//
//  SuccessfullDeliveredPopupVC.swift
//  Joker
//
//  Created by retina on 30/08/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class SuccessfullDeliveredPopupVC: UIViewController {

    @IBOutlet weak var lblContent: UILabel!
    
    @IBOutlet weak var btnRateDeliveryPerson: UIButton!
    
    var controllerPurpuse = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var orderId = ""
    var rateToUserId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if controllerPurpuse == "NormalDelivery"{
            
            self.lblContent.text = "Your order is delivered.\nThanks for using Paginazul App"
            
            btnRateDeliveryPerson.setTitle("Rate Delivery Captain", for: .normal)
           
        }else{
            
            self.lblContent.text = "Your service has completed. Thanks for using Paginazul App".localized()
            
            btnRateDeliveryPerson.setTitle("Rate Professional Captain".localized(), for: .normal)
            
        }
        
    }
    
    @IBAction func tap_rateDeliveryPerson(_ sender: Any) {
        
        UserDefaults.standard.set(true, forKey: "RateThroughPopup")
        
        if controllerPurpuse == "NormalDelivery"{
            
            self.dismiss(animated: false) {
                
//                UserDefaults.standard.set(true, forKey: "EnabledPastTabInitiallyForNormalDelivery")
//
//                let vc = ScreenManager.getMyOrderNoralUserScrollerVC()
//                let navController = UINavigationController(rootViewController: vc)
//                navController.navigationBar.isHidden = true
//                self.appDelegate.window?.rootViewController = navController
//                self.appDelegate.window?.makeKeyAndVisible()
                
                UserDefaults.standard.set(true, forKey: "EnabledPastTabInitiallyForNormalDelivery")
                
                let ratingDataDict = NSMutableDictionary()
                
                ratingDataDict.setValue(self.rateToUserId, forKey: "RatingToUser")
                ratingDataDict.setValue(self.orderId, forKey: "OrderId")
                ratingDataDict.setValue("DeliveryPerson", forKey: "ratingToTypeUser")
                ratingDataDict.setValue("NormalUser", forKey: "ratingByTypeUser")
                ratingDataDict.setValue("normalDeliveryViaPopup", forKey: "isComing")
                ratingDataDict.setValue("OrderRating", forKey: "ratingPurpuse")
                
                let data = NSKeyedArchiver.archivedData(withRootObject: ratingDataDict)
                UserDefaults.standard.set(data, forKey: "RatingDataDict")
                
                let vc = ScreenManager.getReviewAndRatingVC()
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                self.appDelegate.window?.rootViewController = navController
                self.appDelegate.window?.makeKeyAndVisible()
                
            }
        }else{
            
            self.dismiss(animated: false) {
                
//                UserDefaults.standard.set(true, forKey: "EnabledPastTabInitiallyForNormalProfessional")
//
//                let vc = ScreenManager.getNormalUserWithProfessionalWorkerScrollerVC()
//                let navController = UINavigationController(rootViewController: vc)
//                navController.navigationBar.isHidden = true
//                self.appDelegate.window?.rootViewController = navController
//                self.appDelegate.window?.makeKeyAndVisible()
                
                let ratingDataDict = NSMutableDictionary()
                
                ratingDataDict.setValue(self.rateToUserId, forKey: "RatingToUser")
                ratingDataDict.setValue(self.orderId, forKey: "OrderId")
                ratingDataDict.setValue("ProfessionalWorker", forKey: "ratingToTypeUser")
                ratingDataDict.setValue("NormalUser", forKey: "ratingByTypeUser")
                ratingDataDict.setValue("normalPROFESSIONALViaPopup", forKey: "isComing")
                ratingDataDict.setValue("OrderRating", forKey: "ratingPurpuse")
                
                let data = NSKeyedArchiver.archivedData(withRootObject: ratingDataDict)
                UserDefaults.standard.set(data, forKey: "RatingDataDict")
                
                UserDefaults.standard.set(true, forKey: "EnabledPastTabInitiallyForNormalProfessional")
                
                let vc = ScreenManager.getReviewAndRatingVC()
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                self.appDelegate.window?.rootViewController = navController
                self.appDelegate.window?.makeKeyAndVisible()
                
            }
            
        }
        
    }
    
}
