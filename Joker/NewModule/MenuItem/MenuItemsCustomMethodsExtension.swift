//
//  MenuItemsCustomMethodsExtension.swift
//  JustBite
//
//  Created by Aman on 14/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import Foundation
import UIKit

extension MenuItemsVC{
    
    //TODO: Initial Setup
    internal func initialStup(){
        topConstraint.constant = UIScreen.main.bounds.height/2
        CommonClass.sharedInstance.provideCustomCornarRadius(btnRef: self.viewMain, radius: 5)
        lblHeader.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 17)
        registerNib()
    }
    
    
    //TODO: Register Nib method
    fileprivate func registerNib(){
      self.tblAddOns.register(UINib(nibName:  "MenuItemTableViewCell", bundle: nil), forCellReuseIdentifier:  "MenuItemTableViewCell")
    }
    
    

    
}
