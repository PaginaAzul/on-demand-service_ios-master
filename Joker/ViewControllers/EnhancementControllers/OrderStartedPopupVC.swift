//
//  OrderStartedPopupVC.swift
//  Joker
//
//  Created by retina on 30/08/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

protocol OrderStartDelegate{
    
    func orderStarted(status:String)
}

class OrderStartedPopupVC: UIViewController {

    
    @IBOutlet weak var lblContent: UILabel!
    
    @IBOutlet weak var lblGreat: UILabel!
    
    @IBOutlet weak var btnOk: UIButton!
    
    
    var delegate:OrderStartDelegate?
    
    var controllerPurpuse = ""
    
    let connection = webservices()
    
    var parameterName = ""
    var orderID = ""
    
    var subControllerPurpuse = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if controllerPurpuse == "Delivery"{
            
            parameterName = "offerId"
        }
        else{
            
            parameterName = "orderId"
        }
        
        self.apiCallForUpdatePopupStatus()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        btnOk.setTitle("OK".localized(), for: .normal)
        lblGreat.text = "Great!".localized()
        
        if subControllerPurpuse == "ProfessionalWorker"{
            
            lblContent.text = "Your order has started! We wish you the best experience, However, if anything happens, remember that you have 'withdraw from service' Check the menu below"
        }
        else if subControllerPurpuse == "NormalProfessional" || subControllerPurpuse == "NormalDelivery"{
            
             lblContent.text = "Your order has started! We wish you the best experience, However, if anything happens, remember that you have 'change courier' Check the menu below".localized()
        }
        else if subControllerPurpuse == "DeliveryWorker"{
            
            lblContent.text = "Your order has started! We wish you the best experience, However, if anything happens, remember that you have 'withdraw from order' Check the menu below"
        }
    }
    
    
    @IBAction func tap_okBtn(_ sender: Any) {
        
        self.delegate?.orderStarted(status: "yes")
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension OrderStartedPopupVC{
    
    func apiCallForUpdatePopupStatus(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["\(parameterName)":orderID]
            
            print(param)
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForUpdatePopupStatus as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                       
                        
                    }
                    else{
                        
                    }
                }
                else{
                    
                    // CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
}
