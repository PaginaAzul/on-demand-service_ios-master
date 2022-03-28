//
//  OrderPlacedPopUp_VC.swift
//  Joker
//
//  Created by cst on 23/10/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit

class OrderPlacedPopUp_VC: UIViewController {

    @IBOutlet weak var lblOrderPlaced:UILabel!
    @IBOutlet weak var lblOrderPlaceText:UILabel!
    @IBOutlet weak var btnOK:UIButton!
    @IBOutlet weak var btnBackToHome: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var icComingFromOffer = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myMutableString1 = NSMutableAttributedString()
        
        let normalText1 = "Order Placed!".localized()
        
        let myMutableString2 = NSAttributedString(string: "\(normalText1) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!, .foregroundColor :AppColor.textColor])
        
        myMutableString1.append(myMutableString2)
        
        lblOrderPlaced.attributedText = myMutableString1
        
        let myMutableString11 = NSMutableAttributedString()
        
        let normalText2 = "You order has been placed successfully.\n Please make the payment by cash".localized()
        
        
        let myMutableString12 = NSAttributedString(string: "\(normalText2) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 14.0)!, .foregroundColor :AppColor.placeHolderColor])
        
        myMutableString11.append(myMutableString12)
        
        lblOrderPlaceText.attributedText = myMutableString11
        
        var btnOKText = NSAttributedString()
        
        if icComingFromOffer == true {
            btnBackToHome.isHidden = false
            btnOKText = NSAttributedString(string: "Shop More Offer".localized(), attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 15.0)!, .foregroundColor :UIColor.white])
        }else{
            btnOKText = NSAttributedString(string: "Ok".localized(), attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 15.0)!, .foregroundColor :UIColor.white])
            btnBackToHome.isHidden = true
        }
        
       
        
        btnOK.setAttributedTitle(btnOKText, for: .normal)
    }
    

    @IBAction func btnOKTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            
            let value =  UserDefaults.standard.value(forKey: "Shop") as? Bool ?? false
            if value == true {
                let vc = ScreenManager.OfferListNew_VC()
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                self.appDelegate.window?.rootViewController = navController
                self.appDelegate.window?.makeKeyAndVisible()
            }else{
                let vc = ScreenManager.HomeScreenNew_VC()
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                self.appDelegate.window?.rootViewController = navController
                self.appDelegate.window?.makeKeyAndVisible()
            }
            
            
            
        }
        
    }

    @IBAction func btnGotoHome(_ sender: UIButton) {
        
        let vc = ScreenManager.MainModuleNew_VC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        self.appDelegate.window?.rootViewController = navController
        self.appDelegate.window?.makeKeyAndVisible()
        
    }
    
    
    
}
