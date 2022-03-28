//
//  ContactAdminVC.swift
//  Joker
//
//  Created by abc on 22/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class ContactAdminVC: UIViewController {

    
    @IBOutlet weak var lblNav: UILabel!
    
    @IBOutlet weak var btnCustomerServiceAdmin: UIButton!
    
    @IBOutlet weak var btnCaptainAssistantAdmin: UIButton!
    
    @IBOutlet weak var btnBankAccountAdmin: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tap_customerServiceAdmin(_ sender: Any) {
        
        let vc = ScreenManager.getCancellationVC()
        
        vc.controllerPurpuse = "ContactAdmin"
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_captainAssistantAdmin(_ sender: Any) {
        
        let vc = ScreenManager.getCancellationVC()
        
        vc.controllerPurpuse = "ContactAdmin"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_bankAccountAdmin(_ sender: Any) {
        
        let vc = ScreenManager.getCancellationVC()
        
        vc.controllerPurpuse = "ContactAdmin"
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
