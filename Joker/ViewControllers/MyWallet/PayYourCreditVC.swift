//
//  PayYourCreditVC.swift
//  Joker
//
//  Created by Callsoft on 23/01/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class PayYourCreditVC: UIViewController {

    @IBOutlet weak var txtFldEnterAmount: UITextField!
    
    @IBOutlet weak var lblAvailableBalance: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       txtFldEnterAmount.placeHolderColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        
        lblAvailableBalance.attributedText = CommonClass.sharedInstance.setAvailableBalanceText("Available Balance : ", "15.0SAR")
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_saveBtn(_ sender: Any) {
        
        let vc = ScreenManager.getManagedSavedCardsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
