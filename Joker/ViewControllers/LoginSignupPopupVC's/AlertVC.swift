//
//  AlertVC.swift
//  Joker
//
//  Created by Apple on 18/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

protocol DeliveryChatAdditionalFeatureDelegate{
    
    func additionalChatFeatureDeliveryWorker(type:String)
}


class AlertVC: UIViewController {

    @IBOutlet weak var okBtn: UIButton!
    
    @IBOutlet weak var btnIssueBil: UIButton!
    
    
    @IBOutlet weak var btnGoodsDelivered: UIButton!
    
    @IBOutlet weak var btnTalkToAdmin: UIButton!
    
    
    
    var delegate:DeliveryChatAdditionalFeatureDelegate?
    
    var controllerUsingFor = ""
    
    var invoiceBool = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // intialise()
        
        if self.controllerUsingFor == "ProfessionalWorker"{
            
            btnGoodsDelivered.setTitle("Service completed", for: .normal)
            btnTalkToAdmin.setTitle("File a complaint", for: .normal)
        }
        
        if invoiceBool{
            
            btnIssueBil.setTitle("Change Bill", for: .normal)
        }
        else{
            
            btnIssueBil.setTitle("Issue Bill", for: .normal)
        }
        
    }

    @IBAction func tap_okBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func tap_issueBill(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
            self.delegate?.additionalChatFeatureDeliveryWorker(type: "IssueBill")
        }
    }
    
    @IBAction func tap_shareImage(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
            self.delegate?.additionalChatFeatureDeliveryWorker(type: "ShareImage")
        }
    }
    
    @IBAction func tap_shareLocation(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
            self.delegate?.additionalChatFeatureDeliveryWorker(type: "ShareLocation")
        }
    }
    
    @IBAction func tap_goodsDelivered(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
            self.delegate?.additionalChatFeatureDeliveryWorker(type: "GoodsDelivered")
        }
    }
    
    @IBAction func tap_withdrawOffer(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
            self.delegate?.additionalChatFeatureDeliveryWorker(type: "WithdrawOffer")
        }
    }
    
    @IBAction func tap_talkToAdmin(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
            self.delegate?.additionalChatFeatureDeliveryWorker(type: "ContactAdmin")
        }
    }
    
    @IBAction func tap_cancelBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
 
    
}


extension AlertVC{
    
    func intialise()
    {
       self.okBtn.backgroundColor = UIColor(red: 187.0/255, green: 101.0/255, blue: 255.0/255, alpha: 1.0)
    }
    
}
