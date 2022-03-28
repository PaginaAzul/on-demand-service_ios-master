//
//  NormalUserWaitingForOfferVC.swift
//  Joker
//
//  Created by retina on 30/08/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class NormalUserWaitingForOfferVC: UIViewController {

    
    @IBOutlet weak var loaderImg: UIImageView!
    
    @IBOutlet weak var lblWaitingForOffer: UILabel!
    
    @IBOutlet weak var lblContent: UILabel!
    
    @IBOutlet weak var btnTryAgain: UIButton!
    
    @IBOutlet weak var btnCancelOffer: UIButton!
    
    @IBOutlet weak var imgCancelOffer: UIImageView!
    
    @IBOutlet weak var lblNav: UILabel!
    
    
    
    var previousTxt = "Your offer is submitted. One of the delivery person will submit an offer to you soon."
    
    var afterTimerTxt = "No Delivery Captain is available at this time. Please try again later."
    
    var counter = 120
    var timer = Timer()
    
    var orderID = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let connection = webservices()
    var category = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("category At NormalUserWaitingForOfferVC",category)
        
        lblWaitingForOffer.text = "waiting for offers...".localized();
        
        if UserDefaults.standard.value(forKey: "SepratorType") as? String ?? "" == "RequestingDelivery"{

             previousTxt = "Your offer is submitted. One of the delivery person will submit an offer to you soon."

             afterTimerTxt = "No Delivery Captain is available at this time. Please try again later."
        }
        else{

            //case requesting professional , we are using same controller for both request

            previousTxt = "Your order is submitted. Our professional captain will submit an offer to you soon.".localized()

            afterTimerTxt = "No Professional is currently available. Please try again later or call 923283618".localized()

        }

        initialSetup()

        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)

        self.rotateView(targetView: loaderImg)

        btnTryAgain.setTitle("Try Again".localized(), for: .normal)
        lblNav.text = "Offers".localized()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
                
        if UserDefaults.standard.value(forKey: "SepratorType") as? String ?? "" == "RequestingDelivery"{
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.apiCallForViewAllOffer), name: NSNotification.Name(rawValue: "NotificationForUpdatePendingListNormalUserByDelivery"), object: nil)
        }
        else{
            
            //register this notification when we are getting professional offer.
            NotificationCenter.default.addObserver(self, selector: #selector(self.apiCallForViewAllOffer), name: NSNotification.Name(rawValue: "NotificationForUpdatePendingListNormalUserByProfessionalWorker"), object: nil)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if UserDefaults.standard.value(forKey: "SepratorType") as? String ?? "" == "RequestingDelivery"{
            
            NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "NotificationForUpdatePendingListNormalUserByDelivery"), object: nil)
        }
        else{
            
             NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "NotificationForUpdatePendingListNormalUserByProfessionalWorker"), object: nil)
        }
    }
    
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        if UserDefaults.standard.value(forKey: "SepratorType") as? String ?? "" == "RequestingDelivery"{
            
            let vc = ScreenManager.getMyOrderNoralUserScrollerVC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navController
            appDelegate.window?.makeKeyAndVisible()
        }
        else{
            
            let vc = ScreenManager.getNormalUserWithProfessionalWorkerScrollerVC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navController
            appDelegate.window?.makeKeyAndVisible()
        }
        
    }
    
    
    @IBAction func tap_cancelOfferbtn(_ sender: Any) {
        
        let vc = ScreenManager.getDeleteOfferPopupVC()
        vc.orderID = orderID
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tap_tryAgainBtn(_ sender: Any) {
        
        initialSetup()

        counter = 120
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        //call api for view all offer
        
        self.apiCallForViewAllOffer()
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
            
            laterSetup()
        }
       
    }
    
    
}


extension NormalUserWaitingForOfferVC{
    
    func initialSetup(){
        
        lblContent.text = previousTxt
        imgCancelOffer.isHidden = true
        btnTryAgain.isHidden = true
        
        loaderImg.isHidden = false
        lblWaitingForOffer.isHidden = false
        
        btnCancelOffer.setTitle("Cancel Order".localized(), for: .normal)
    }
    
    func laterSetup(){
        
        lblContent.text = afterTimerTxt
        imgCancelOffer.isHidden = false
        btnTryAgain.isHidden = false
        
        lblWaitingForOffer.isHidden = true
        loaderImg.isHidden = true
        
        btnCancelOffer.setTitle("Cancel".localized(), for: .normal)
    }
    
}


//MARK:- Webservices
//MARK:-
extension NormalUserWaitingForOfferVC{
    
    @objc func apiCallForViewAllOffer(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","lat":"\(CommonClass.sharedInstance.locationLatCordinate)","long":"\(CommonClass.sharedInstance.locationLongCordinate)","orderId":orderID]
            
         //   IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetViewAllOffered as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
               // IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let viewAllOfferArr = receivedData.object(forKey: "Data1") as? NSArray ?? []
                        
                        if viewAllOfferArr.count == 0{
                            
                           
                        }
                        else{
                            
                            self.timer.invalidate()

                            let vc1 = ScreenManager.getViewAllOffersPopupVC()

                            vc1.viewAllOfferArr = viewAllOfferArr
                            vc1.orderId = self.orderID
                            vc1.category = self.category
                           self.navigationController?.pushViewController(vc1, animated: true)
                            
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
