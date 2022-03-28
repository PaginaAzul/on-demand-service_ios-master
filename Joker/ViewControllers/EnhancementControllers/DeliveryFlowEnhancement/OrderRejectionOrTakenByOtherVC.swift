//
//  OrderRejectionOrTakenByOtherVC.swift
//  Joker
//
//  Created by retina on 09/09/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class OrderRejectionOrTakenByOtherVC: UIViewController {

    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var lblAvgRating: UILabel!
    
    @IBOutlet weak var lblContentChanger: UILabel!
    
    @IBOutlet weak var viewForRejection: UIView!
    
    @IBOutlet weak var btnChangeOffer: UIButton!
    
    @IBOutlet weak var btnCancelOfferForRejection: UIButton!
    
    @IBOutlet weak var btnViewNewOrders: UIButton!
    
    var controllerPurpuse = ""
    var navObj = UIViewController()
    
    var userName = ""
    var userRating = ""
    var userImg = ""
    var orderID = ""
    var offerAmount = ""
    
    var purpuseForControllerUse = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reloadComponentBasedOnScreen()
        
        if self.purpuseForControllerUse == ""{
            
            //delivery
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.notificationForScreenDismissle), name: NSNotification.Name(rawValue: "OfferDeletedByNormalDelivery"), object: nil)
            
        }
        else{
            
            //professional
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.notificationForScreenDismissle), name: NSNotification.Name(rawValue: "OfferDeletedByNormalProfessional"), object: nil)
        }
        
    }
    
    
    @IBAction func tap_backbtn(_ sender: Any) {
        
        if purpuseForControllerUse == ""{
            
            //delivery worker flow
            
            for controller in self.navigationController!.viewControllers as Array {
                
                if controller is DeliveryPersonScrollManagerVC{
                    self.navigationController?.popToViewController(controller, animated: true)
                    
                    break
                }
            }
        }
        else{
            
            //professional worker flow
            
            for controller in self.navigationController!.viewControllers as Array {
                
                if controller is ProfessionalWorkerScrollManagerVC{
                    self.navigationController?.popToViewController(controller, animated: true)
                    
                    break
                }
            }
            
        }
        
    }
    
    @IBAction func tap_viewNewOrdersBtn(_ sender: Any) {
        
        if purpuseForControllerUse == ""{
            
            for controller in self.navigationController!.viewControllers as Array {
                
                if controller is DeliveryPersonScrollManagerVC{
                    
                    self.navigationController?.popToViewController(controller, animated: true)
                    
                    break
                }
            }
        }
        else{
            
            for controller in self.navigationController!.viewControllers as Array {
                
                if controller is ProfessionalWorkerScrollManagerVC{
                    
                    self.navigationController?.popToViewController(controller, animated: true)
                    
                    break
                }
            }
        }
       
    }
    
    @IBAction func tap_changeOfferBtn(_ sender: Any) {
        
        if purpuseForControllerUse == ""{
            
            for controller in self.navigationController!.viewControllers as Array {
                
                if controller is SubmitOfferAsDeliveryVC{
                    self.navigationController?.popToViewController(controller, animated: true)
                    
                    break
                }
            }
        }
        else{
            
            for controller in self.navigationController!.viewControllers as Array {
                
                if controller is SubmitOfferAsProfessionalWorkerVC{
                    self.navigationController?.popToViewController(controller, animated: true)
                    
                    break
                }
            }
        }
      
    }
    
    @IBAction func tap_cancelOfferBtn(_ sender: Any) {
        
        let vc = ScreenManager.getOrderCancelFromDeliverySideVC()
        
        vc.orderID = self.orderID
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func reloadComponentBasedOnScreen(){
        
        lblUsername.text = userName
        lblAvgRating.text = userRating
        
        imgUser.layer.cornerRadius = imgUser.frame.size.height/2
        imgUser.clipsToBounds = true
        
        if userImg == ""{
            
            imgUser.image = UIImage(named: "placeholderImg")
        }
        else{
            
            let urlStr = URL(string: userImg)
            imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
        
        if controllerPurpuse == "Rejection"{
            
            lblContentChanger.text = "Sorry, This order has been rejected by the normal user."
            
            btnViewNewOrders.isHidden = true
            
            viewForRejection.isHidden = false
            
        }
        else{
            
            if purpuseForControllerUse == ""{
                
                lblContentChanger.text = "Sorry, This order has been taken by other delivery person."
            }
            else{
                
                lblContentChanger.text = "Sorry, This order has been taken by other professional person."
            }
            
            btnViewNewOrders.isHidden = false
            
            viewForRejection.isHidden = true
        }
    }
    
    
    @objc func notificationForScreenDismissle(){
        
        if self.purpuseForControllerUse == ""{
            
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
    
    
}
