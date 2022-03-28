//
//  InstructionVC.swift
//  Joker
//
//  Created by Callsoft on 15/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class InstructionVC: UIViewController {

    
    @IBOutlet weak var lblHeader: UILabel!
    
    @IBOutlet weak var lblContent: UILabel!
        
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let data = UserDefaults.standard.value(forKey: "WalkInArr") as! NSData
        let walkInDataArr = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! NSArray
        
        for i in 0..<walkInDataArr.count{
            
            let dict = walkInDataArr.object(at: i) as? NSDictionary ?? [:]
            let type = dict.object(forKey: "Type") as? String ?? ""
            
            if type == "Marketing"{
                
                lblContent.text = dict.object(forKey: "description") as? String ?? ""
                
                break
            }
        }
    }
    
    @IBAction func tap_closeBtn(_ sender: Any) {
        
        let vc = ScreenManager.getServiceProviderMapVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
        
    }

}
