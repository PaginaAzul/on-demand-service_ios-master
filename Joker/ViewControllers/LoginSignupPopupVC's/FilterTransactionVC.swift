//
//  FilterTransactionVC.swift
//  Joker
//
//  Created by Apple on 23/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class FilterTransactionVC: UIViewController {

    @IBOutlet weak var imgAdded: UIImageView!
    @IBOutlet weak var imgPaid: UIImageView!
    @IBOutlet weak var lblAdded: UILabel!
    @IBOutlet weak var lblPaid: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func tap_AddedPaidBtn(_ sender: UIButton) {
        
        if sender.tag == 1
        {
            lblAdded.textColor = UIColor(red: 190.0/255, green: 113.0/255, blue: 252.0/255, alpha: 1.0)
            lblPaid.textColor = UIColor.black
            imgAdded.image = #imageLiteral(resourceName: "pickupFillImg")
            imgPaid.image = #imageLiteral(resourceName: "unselected")
            
            
        }else{
            
            lblPaid.textColor = UIColor(red: 190.0/255, green: 113.0/255, blue: 252.0/255, alpha: 1.0)
            lblAdded.textColor = UIColor.black
            imgAdded.image = #imageLiteral(resourceName: "unselected")
            imgPaid.image = #imageLiteral(resourceName: "pickupFillImg")
            
        }
        
        
    }
    
    @IBAction func tap_closeBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
