//
//  OfferDetailsPopUPVC.swift
//  Joker
//
//  Created by abc on 21/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class OfferDetailsPopUPVC: UIViewController {
    //MARK: - Outlets
    
    @IBOutlet weak var lblItemsDetails: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    @IBAction func tap_sideMenuBtn(_ sender: Any) {
        
        let vc = ScreenManager.getMoreVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
//MARK: - Extension User Defined Methods
extension OfferDetailsPopUPVC{
    
    //TODO: Initial Setup
    func initialSetup(){
        lblItemsDetails.text = "Dummy Detail"
    }
}
