//
//  MakeNewOfferAlertVC.swift
//  Joker
//
//  Created by Callsoft on 04/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class MakeNewOfferAlertVC: UIViewController {

    var isComing = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func tap_noBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tap_yesBtn(_ sender: Any) {
        
        self.dismiss(animated: true) {
            if self.isComing == "DELIVERY"{
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "YES_TAP_FOR_DELIVERY"), object: nil)
            }else{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "YES_TAP_FOR_PROFESSIONAL"), object: nil)
            }
           
        }
    }
    
    
}
