//
//  RangeFilterVC.swift
//  Joker
//
//  Created by Apple on 23/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class RangeFilterVC: UIViewController {

    @IBOutlet weak var imgOne: UIImageView!
    @IBOutlet weak var imgTwo: UIImageView!
    @IBOutlet weak var imgThree: UIImageView!
    
    @IBOutlet weak var lblRangeOne: UILabel!
    @IBOutlet weak var lblRangeTwo: UILabel!
    @IBOutlet weak var lblRangeThree: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func tap_rangeBtn(_ sender: UIButton) {
        
        if sender.tag == 1{
            lblRangeOne.textColor = UIColor(red: 190.0/255, green: 113.0/255, blue: 252.0/255, alpha: 1.0)
            lblRangeTwo.textColor = UIColor.black
            lblRangeThree.textColor = UIColor.black

            imgOne.image = #imageLiteral(resourceName: "pickupFillImg")
            imgTwo.image = #imageLiteral(resourceName: "unselected")
            imgThree.image = #imageLiteral(resourceName: "unselected")
            
            
        }else if sender.tag == 2{
            
            lblRangeTwo.textColor = UIColor(red: 190.0/255, green: 113.0/255, blue: 252.0/255, alpha: 1.0)
            lblRangeOne.textColor = UIColor.black
            lblRangeThree.textColor = UIColor.black


            imgOne.image = #imageLiteral(resourceName: "unselected")
            imgTwo.image = #imageLiteral(resourceName: "pickupFillImg")
            imgThree.image = #imageLiteral(resourceName: "unselected")
            
        }
        
        else{
            
            lblRangeThree.textColor = UIColor(red: 190.0/255, green: 113.0/255, blue: 252.0/255, alpha: 1.0)
            lblRangeTwo.textColor = UIColor.black
            lblRangeOne.textColor = UIColor.black
            
            imgOne.image = #imageLiteral(resourceName: "unselected")
            imgTwo.image = #imageLiteral(resourceName: "unselected")
            imgThree.image = #imageLiteral(resourceName: "pickupFillImg")
        }
        
    }
    
    @IBAction func tap_crossBtn(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
