//
//  AddNewBanksVC.swift
//  Joker
//
//  Created by Callsoft on 23/01/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class AddNewBanksVC: UIViewController {

    
    @IBOutlet weak var txtBankName: UITextField!
    
    @IBOutlet weak var txtAccountHolderName: UITextField!
    
    @IBOutlet weak var txtBankAccountNumber: UITextField!
    
    @IBOutlet weak var txtHolderAccountNumber: UITextField!
    
    @IBOutlet weak var txtIbanNumber: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtBankName.placeHolderColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        txtAccountHolderName.placeHolderColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        txtBankAccountNumber.placeHolderColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        txtHolderAccountNumber.placeHolderColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        txtIbanNumber.placeHolderColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.0)
        
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_saveBtn(_ sender: Any) {
        
    }
    
}
