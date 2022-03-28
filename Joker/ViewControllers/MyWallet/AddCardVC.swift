//
//  AddCardVC.swift
//  Joker
//
//  Created by Callsoft on 23/01/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class AddCardVC: UIViewController {

    @IBOutlet weak var txtCardName: UITextField!
    
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtExpiryDate: UITextField!
    
    @IBOutlet weak var txtCVV: UITextField!
    
    var controllerName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtCardName.placeHolderColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        txtCardNumber.placeHolderColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        txtExpiryDate.placeHolderColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        txtCVV.placeHolderColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_saveBtn(_ sender: Any) {
        
        let vc = ScreenManager.getManageCardVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
//          let vc = ScreenManager.getAddNewBanksVC()
//          self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
