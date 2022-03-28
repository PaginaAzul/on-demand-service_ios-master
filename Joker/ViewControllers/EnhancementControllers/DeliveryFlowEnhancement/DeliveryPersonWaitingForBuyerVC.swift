//
//  DeliveryPersonWaitingForBuyerVC.swift
//  Joker
//
//  Created by retina on 09/09/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class DeliveryPersonWaitingForBuyerVC: UIViewController {

    
    @IBOutlet weak var lblHeaderWaitingTxt: UILabel!
    
    @IBOutlet weak var viewUserInfo: UIView!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var lblAvgRating: UILabel!
    
    @IBOutlet weak var viewForBlur: UIView!
    
    @IBOutlet weak var imgLoader: UIImageView!
    
    @IBOutlet weak var lblSubmitAmountContent: UILabel!
    
    @IBOutlet weak var btnCancelOffer: UIButton!
    
    @IBOutlet weak var viewHeader: UIView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var purpuseForControllerUse = ""
    
    var userName = ""
    var userRating = ""
    var userImg = ""
    var orderID = ""
    var offerAmount = ""
    
    var counter = 120
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        self.rotateView(targetView: imgLoader)
        
        if self.purpuseForControllerUse == ""{
            
            //************** If condition for getting Delivery worker notifications
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.sendOnNextScreenBasedOnRejection), name: NSNotification.Name(rawValue: "OfferRejectedByNormal"), object: nil)
            
            //******************This is for, offer you have made but any other person has submit a better offer
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.sendOnNextScreenBasedOnOtherAcceptance), name: NSNotification.Name(rawValue: "OfferAcceptedByOther"), object: nil)
            
            //******************
            //
             NotificationCenter.default.addObserver(self, selector: #selector(self.offerHasAccepted), name: NSNotification.Name(rawValue: "OfferAcceptedByNormal"), object: nil)
            
            
            //Order cancel by normal delivery
            
             NotificationCenter.default.addObserver(self, selector: #selector(self.tap_back), name: NSNotification.Name(rawValue: "OfferDeletedByNormalDelivery"), object: nil)
            
        }
        else{
            
            //************** else condition for getting Professional worker notifications
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.sendOnNextScreenBasedOnRejection), name: NSNotification.Name(rawValue: "OfferRejectedOfProfessionalByNormal"), object: nil)
            
            //******************This is for, offer you have made but any other professional worker has submit a better offer
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.sendOnNextScreenBasedOnOtherAcceptance), name: NSNotification.Name(rawValue: "OfferAcceptedByOtherProfessionalWorker"), object: nil)
            
            //******************
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.offerHasAcceptedOfProfessionalWorkerByNormalUser), name: NSNotification.Name(rawValue: "OfferAcceptedOfProfessionalByNormal"), object: nil)
            
            //order deleted by normalProfessional
            
              NotificationCenter.default.addObserver(self, selector: #selector(self.tap_back), name: NSNotification.Name(rawValue: "OfferDeletedByNormalProfessional"), object: nil)
            
        }
        
    }
    
    @IBAction func tap_cancelOfferBtn(_ sender: Any) {
        
        let vc = ScreenManager.getOrderCancelFromDeliverySideVC()
        
        vc.orderID = self.orderID
        
        vc.controllerPurpuse = self.purpuseForControllerUse
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tap_backbtn(_ sender: Any) {
        
//        if self.purpuseForControllerUse == ""{
//
//            UserDefaults.standard.set(true, forKey: "RootApply")
//
//            let vc = ScreenManager.getDeliveryPersonScrollManagerVC()
//            let navController = UINavigationController(rootViewController: vc)
//            navController.navigationBar.isHidden = true
//            self.appDelegate.window?.rootViewController = navController
//            self.appDelegate.window?.makeKeyAndVisible()
//        }
//        else{
//
//            UserDefaults.standard.set(true, forKey: "RootApplyForProfessional")
//
//            let vc = ScreenManager.getProfessionalWorkerScrollManagerVC()
//            let navController = UINavigationController(rootViewController: vc)
//            navController.navigationBar.isHidden = true
//            self.appDelegate.window?.rootViewController = navController
//            self.appDelegate.window?.makeKeyAndVisible()
//
//        }
        
        tap_back()
        
    }
    
    
    @objc func tap_back(){
        
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
    
    
    
    private func rotateView(targetView: UIView, duration: Double = 0.9) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(Double.pi))
        }) { finished in
            self.rotateView(targetView: targetView, duration: duration)
        }
    }
    
    @objc func timerAction() {
        
        counter -= 1
        
        if counter == -1{
            
            timer.invalidate()
            
            self.viewForBlur.isHidden = true
            
            self.lblHeaderWaitingTxt.isHidden = true
            
            self.viewUserInfo.isHidden = false
            self.viewHeader.isHidden = false
            
        }
        
    }
    
}


extension DeliveryPersonWaitingForBuyerVC{
    
    func initialSetup(){
        
        viewUserInfo.isHidden = true
        viewHeader.isHidden = true
        
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
        var currency = "SAR"
        lblSubmitAmountContent.text = "Your offer of".localized()+" \(offerAmount) \(currency) "+"is submitted to the buyer. Please wait until he accepts it.".localized()
        
       // "is submitted to the buyer. Please wait until he accepts it."
//        "Your offer of".localized()+" \(offerAmount)"+"SAR is submitted to the buyer. Please wait untill he accepts it.".localized()
        
    }
    
    
    @objc func sendOnNextScreenBasedOnRejection(){
        
        let vc = ScreenManager.getOrderRejectionOrTakenByOtherVC()
      //  vc.navObj = self
        
        vc.userName = self.userName
        vc.userImg = self.userImg
        vc.userRating = self.userRating
        vc.orderID = self.orderID
        vc.offerAmount = self.offerAmount
        
        vc.controllerPurpuse = "Rejection"
        
        vc.purpuseForControllerUse = self.purpuseForControllerUse
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func sendOnNextScreenBasedOnOtherAcceptance(){
        
        let vc = ScreenManager.getOrderRejectionOrTakenByOtherVC()
      //  vc.navObj = self
        
        vc.userName = self.userName
        vc.userImg = self.userImg
        vc.userRating = self.userRating
        vc.orderID = self.orderID
        vc.offerAmount = self.offerAmount
        
        vc.controllerPurpuse = "AcceptByOther"
        
        vc.purpuseForControllerUse = self.purpuseForControllerUse
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @objc func offerHasAccepted(){
        
        UserDefaults.standard.set(true, forKey: "ActiveRedirectionOfDeliveryWorker")
        
        UserDefaults.standard.set(true, forKey: "RootApply")
        
        let vc = ScreenManager.getDeliveryPersonScrollManagerVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    
    @objc func offerHasAcceptedOfProfessionalWorkerByNormalUser(){
        
        UserDefaults.standard.set(true, forKey: "RootApplyForProfessional")
        
        UserDefaults.standard.set(true, forKey: "ActiveRedirectionOfProfessionalWorker")
        
        let vc = ScreenManager.getProfessionalWorkerScrollManagerVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    
    
}



