//
//  ChatAdditionalFeatureVC.swift
//  Joker
//
//  Created by retina on 30/08/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

protocol ChatAdditionalFeatureNormalUserDelegate{
    
    func chatAdditionalFeatureOfNormalDelegate(type:String)
}


class ChatAdditionalFeatureVC: UIViewController {

    
    @IBOutlet weak var btnChangeDeliveryCaptain: UIButton!
    
    @IBOutlet weak var btnShareImage: UIButton!
    
    @IBOutlet weak var btnShareLocation: UIButton!
    
    @IBOutlet weak var btnContactAdmin: UIButton!
    
    @IBOutlet weak var btnCancelOrder: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    
    var delegate: ChatAdditionalFeatureNormalUserDelegate?
    
    var controllerUsingFor = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if controllerUsingFor == "NormalProfessional"{
            
            btnChangeDeliveryCaptain.setTitle("Change Service Provider".localized(), for: .normal)
        }
        
        btnShareImage.setTitle("Share Image".localized(), for: .normal)
        btnShareLocation.setTitle("Share Location".localized(), for: .normal)
        btnContactAdmin.setTitle("Contact Admin".localized(), for: .normal)
        btnCancelOrder.setTitle("Cancel Order".localized(), for: .normal)
        btnCancel.setTitle("Cancel".localized(), for: .normal)
        
    }

    @IBAction func tap_shareImageBtn(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
            self.delegate?.chatAdditionalFeatureOfNormalDelegate(type: "ShareImage")
        }
    }
    
    @IBAction func tap_shareLocationBtn(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
            self.delegate?.chatAdditionalFeatureOfNormalDelegate(type: "ShareLocation")
        }
    }
    
    @IBAction func tap_contactAdmin(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
            self.delegate?.chatAdditionalFeatureOfNormalDelegate(type: "ContactAdmin")
        }
    }
    
    @IBAction func tap_changeDeliveryCaptain(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
            self.delegate?.chatAdditionalFeatureOfNormalDelegate(type: "ChangeDeliveryCaptain")
        }
    }
    
    @IBAction func tap_cancelOrderBtn(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
            self.delegate?.chatAdditionalFeatureOfNormalDelegate(type: "CancelOrder")
        }
    }
    
    @IBAction func tap_cancelBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
