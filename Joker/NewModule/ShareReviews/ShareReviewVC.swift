//
//  ShareReviewVC.swift
//  JustBite
//
//  Created by Aman on 16/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import UIKit
import Cosmos

class ShareReviewVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var viewCosmos: CosmosView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var viewText: UIView!
    @IBOutlet weak var btnLoginRef: UIButton!
    
    var id = String()
    var order_id = String()
    
    //MARK: - Variables
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print(id)
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    
    
    //TODO: View Will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    
    @IBAction func tap_BackBTN(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
