//
//  ClearCartPOPUP.swift
//  Joker
//
//  Created by call soft on 10/06/21.
//  Copyright © 2021 Callsoft. All rights reserved.
//

import UIKit

class ClearCartPOPUP: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var btnOkay: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    
    //MARK:- Variables
    var message = String()
    var navObj = UIViewController()
    var productID = String()
    
    //MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMessage.text = message
    }
    
    // MARK: - IBAction
    @IBAction func btnActionOk(_ sender: Any) {
        self.dismiss(animated: true) {
            let vc = ScreenManager.MyCartNew_VC()
            vc.toclearCart = "clearCart"
            vc.productID = self.productID
            self.navObj.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }

}
