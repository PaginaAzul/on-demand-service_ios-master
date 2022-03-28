//
//  PopUpVC.swift
//  Joker
//
//  Created by Apple on 18/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

protocol BackToRating{
    
    func statusChange(status:String)
}

protocol AcceptOfferRefreshDelegate {
    
    func changeAcceptOfferScreenStatus(status:String)
}


class PopUpVC: UIViewController {

    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var lblContent_PopUp: UILabel!
    
    var controllerName = ""
    var isComing = String()
    var navObj = UIViewController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var userName = ""
    
    var delegate:BackToRating?
    
    var acceptOfferDelegate:AcceptOfferRefreshDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if controllerName == ""{
            
            intialise()
        }
        else if controllerName == "Accept Offer"{
            
            lblContent_PopUp.text = "Offer Accept Successfully!".localized()
        }
        else if controllerName == "RatingReview"{
            
            lblContent_PopUp.text = "Rating & Reviews Successfully Submitted!".localized()
        }
        else if controllerName == "OfferSubmitted"{
            
            lblContent_PopUp.text = "Offer Submit Successfully".localized()
        }
        else{
            
            lblContent_PopUp.text = "Money Added Successfully"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func tap_OkBtn(_ sender: UIButton) {
        
        if controllerName == ""{
            
            UserDefaults.standard.set(true, forKey: "IsUserLogin")
            
            if UserDefaults.standard.value(forKey: "UserType") as? String ?? "" == "DeliveryWorker"{
                
                
                self.dismiss(animated: false) {
                    
                    if UserDefaults.standard.bool(forKey: "SpecificRootToService"){
                        
                        //login via more tab so we can not redirect directly on goorder so we are making root to service provider
                        
                        UserDefaults.standard.set(false, forKey: "SpecificRootToService")
                        
                        let vc = ScreenManager.getServiceProviderMapVC()
                        let navController = UINavigationController(rootViewController: vc)
                        navController.navigationBar.isHidden = true
                        self.appDelegate.window?.rootViewController = navController
                        self.appDelegate.window?.makeKeyAndVisible()
                        
                    }
                    else{
                        
                        let vc = ScreenManager.getDeliveryPersonGoOrderVC()
                        let navController = UINavigationController(rootViewController: vc)
                        navController.navigationBar.isHidden = true
                        self.appDelegate.window?.rootViewController = navController
                        self.appDelegate.window?.makeKeyAndVisible()
                    }
                    
                }
                
            }
            else{
                
                if UserDefaults.standard.bool(forKey: "SpecificRootToService"){
                    
                    //login via more tab so we can not redirect directly on goorder so we are making root to service provider
                    
                    self.dismiss(animated: false) {
                        
                        UserDefaults.standard.set(false, forKey: "SpecificRootToService")
                        
                        
                       // let vc = ScreenManager.getServiceProviderMapVC() //Old Module
                        let vc = ScreenManager.MainModuleNew_VC() //New Module
                        let navController = UINavigationController(rootViewController: vc)
                        navController.navigationBar.isHidden = true
                        self.appDelegate.window?.rootViewController = navController
                        self.appDelegate.window?.makeKeyAndVisible()
                        
                    }
                    
                }
                else{
                    
                    self.dismiss(animated: false) {
                        
                        let vc = ScreenManager.MainModuleNew_VC()
                        let navController = UINavigationController(rootViewController: vc)
                        navController.navigationBar.isHidden = true
                        self.appDelegate.window?.rootViewController = navController
                        self.appDelegate.window?.makeKeyAndVisible()
                    }
                    
                }
              
            }
        }
        else if controllerName == "OfferSubmitted"{
            
          //  weak var pvc = self.presentingViewController
            self.dismiss(animated: false, completion:{
                
                if UserDefaults.standard.value(forKey: "UserRedirection") as? String ?? "" == "DeliveryFlow"{
                    
                    UserDefaults.standard.set(false, forKey: "NewRedirectionDelivery")
                    
                    let vc = ScreenManager.getMyOrderNoralUserScrollerVC()
                    
                    vc.controllerPurpuse = "Push"
                    
                    vc.redirectStatus = "Seprated"
                    
                    self.navObj.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    
                    UserDefaults.standard.set(false, forKey: "NewRedirectionProfessional")
                    
                    let vc = ScreenManager.getNormalUserWithProfessionalWorkerScrollerVC()
                    
                    vc.controllerPurpuse = "Push"
                    
                    vc.redirectStatus = "Seprated"
                    
                    self.navObj.navigationController?.pushViewController(vc, animated: true)
                    
                }
              
            })
        }else if controllerName == "RatingReview"{

            if self.isComing == "DELIVERY"{
                
                  UserDefaults.standard.set("TRUE_DELIVERY", forKey: "ISCOMIMG_RATINGPOPUP")
            }
            else{
                
                 UserDefaults.standard.set("TRUE_PROFESSIONAL", forKey: "ISCOMIMG_RATINGPOPUP")
            }
            
            self.delegate?.statusChange(status: "Yes")
            self.dismiss(animated: true, completion: nil)
            
        }else if controllerName == "Accept Offer"{
            
            
            self.acceptOfferDelegate?.changeAcceptOfferScreenStatus(status: "Yes")
            self.dismiss(animated: true, completion: nil)
        }
        else{
            
        
            self.dismiss(animated: true, completion: nil)
        }
       
    }
    

}

extension PopUpVC{
    
    func intialise()
    {
        okBtn.backgroundColor = UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00)
        
        okBtn.setTitle("OK".localized(), for: .normal)
        
        self.lblContent_PopUp.text = "Hello, Welcome to Paginazul Family!".localized()
        
//        let normalText1  = "Hello \(userName) Welcome to "
//        let normalColouredText2 = "Paginazul"
//        let normalText3 = " Family! "
//        let myMutableString1 = NSMutableAttributedString()
//        let myMutableString2 = NSAttributedString(string: "\(normalText1) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 17.0)!, .foregroundColor :UIColor.black])
//
//
//        let myMutableString4 = NSAttributedString(string: "\(normalColouredText2) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 17.0)!, .foregroundColor :UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00)] )
//
//        let myMutableString5 = NSAttributedString(string: "\(normalText3) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 17.0)!, .foregroundColor :UIColor.black])
//
//
//        myMutableString1.append(myMutableString2)
//        myMutableString1.append(myMutableString4)
//        myMutableString1.append(myMutableString5)
//        self.lblContent_PopUp.attributedText = myMutableString1
    }
    
}
