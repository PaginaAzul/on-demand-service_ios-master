//
//  Add Money.swift
//  Joker
//
//  Created by abc on 24/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class Add_MoneyVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tap_payYourCreditBtn(_ sender: Any) {
        
        let vc = ScreenManager.getPayYourCreditVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_bankTransferBtn(_ sender: Any) {
        
        let vc = ScreenManager.getBankToBankVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
