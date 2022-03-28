//
//  SubMenuListingCustomMethodExtension.swift
//  JustBite
//
//  Created by Aman on 14/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import Foundation
import UIKit

extension SubMenuListingVC{
    //TODO: Initial Setup
    internal func initialStup(){
        
        self.tblAddOns.tableFooterView = UIView()
        self.tblAddOns.backgroundColor = AppColor.whiteColor
        
        self.tblAddOns.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: -30, right: 0);
        
        self.tblAddOns.delegate = self
        self.tblAddOns.dataSource = self
        
        CommonClass.sharedInstance.provideCustomCornarRadius(btnRef: self.viewMain, radius: 5)
        lblHeader.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 15)
        
        let myMutableString1 = NSMutableAttributedString()
        
        let normalText1 = "Total"
        
        let myMutableString2 = NSAttributedString(string: "\(normalText1)  ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13.0)!, .foregroundColor :AppColor.textNewColor])
        
        let normalText2 = "USD 7.00"
        
        let myMutableString3 = NSAttributedString(string: "\(normalText2) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!, .foregroundColor :UIColor.white ])
        
        myMutableString1.append(myMutableString2)
        myMutableString1.append(myMutableString3)
        
        btnTotal.attributedText = myMutableString1
        
        viewFooter.backgroundColor = AppColor.themeColor
        CommonClass.sharedInstance.provideCornarRadius(btnRef: viewFooter)
        CommonClass.sharedInstance.provideShadow(btnRef: viewFooter)
        registerNib()
        
    }
    
    
    //TODO: Register Nib method
    fileprivate func registerNib(){
        self.tblAddOns.register(UINib(nibName:  "ChooseYorTasteTableViewCell", bundle: nil), forCellReuseIdentifier:  "ChooseYorTasteTableViewCell")
       
    }
    
    

    
    
    internal func assignValueForSum(){
        
//        var sum = Int()
//        var adOnArry = [String]()
//        for item in customizeDataModelArray{
//                for addOnItem in item.addons{
//                    if addOnItem.isSelected{
//                       sum += addOnItem.price
//                        adOnArry.append(String(addOnItem.id))
//                    }
//                }
//
//        }
//        btnTotal.attributedText = GlobalCustomMethods.shared.attributedString(title: "Total", subTitle: "AED \(sum)", delemit: "   ", sizeTitle: 14, sizeSubtitle: 17, titleColor: AppColor.textColor, SubtitleColor: AppColor.whiteColor)
        
    }
    
    
   
    
    
}

