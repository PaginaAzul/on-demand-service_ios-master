//
//  DeliveryProfessionalSignupPopupVC.swift
//  Joker
//
//  Created by Dacall soft on 27/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class DeliveryProfessionalSignupPopupVC: UIViewController {

    var nabObj = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func tap_closeBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tap_deliveryPerson(_ sender: Any) {
        
        self.dismiss(animated: false, completion:{
            
            let vc = ScreenManager.getBecomeADeliveryPersonVC()
            self.nabObj.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    
    @IBAction func tap_professionalWorker(_ sender: Any) {
        
        self.dismiss(animated: false, completion:{
            
            let vc = ScreenManager.getBecomeAProfessionalWorkerVC()
            self.nabObj.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    
}
