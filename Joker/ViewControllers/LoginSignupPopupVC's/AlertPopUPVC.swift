//
//  AlertPopUPVC.swift
//  Joker
//
//  Created by Apple on 23/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class AlertPopUPVC: UIViewController {

    @IBOutlet weak var registerNowBtn: UIButton!
    @IBOutlet weak var notNowBtn: UIButton!
    
    @IBOutlet weak var lblContent: UILabel!
    
    
    var nabObj = UIViewController()
    var purpuse = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        intialise()
        
        if purpuse == "Professional"{
            
            lblContent.text = "You are Not Registered as a professional worker yet"
        }
        
    }
    
    @IBAction func tap_registerBtn(_ sender: Any) {
        
        if purpuse == "Delivery"{
            
            self.dismiss(animated: false, completion:{
                
                let vc = ScreenManager.getBecomeADeliveryPersonVC()
                self.nabObj.navigationController?.pushViewController(vc, animated: true)
            })
            
        }
        else{
            
            self.dismiss(animated: false, completion:{
                
                let vc = ScreenManager.getBecomeAProfessionalWorkerVC()
                self.nabObj.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }
    
    @IBAction func tap_notNowBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
  

}

extension AlertPopUPVC{
    
    func intialise(){
        
        self.registerNowBtn.backgroundColor = UIColor(red: 190.0/255, green: 113.0/255, blue: 252.0/255, alpha: 1.0)
        self.notNowBtn.backgroundColor = UIColor(red: 190.0/255, green: 113.0/255, blue: 252.0/255, alpha: 1.0)
        
    }
    
}
