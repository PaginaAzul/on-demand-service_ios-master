//
//  ShareReviewMethodsExtension.swift
//  JustBite
//
//  Created by Aman on 16/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import Foundation
import UIKit


extension ShareReviewVC{
    
    //TODO: Initial Setup
    
    internal func initialSetup(){
        update()
    }
    
    //TODO: Update UI
    
    fileprivate func update(){
        hideKeyboardWhenTappedAround()
        
        lblDetails.attributedText = CommonClass.sharedInstance.attributedStringForgotPassword(title: "Share Ratings & Reviews".localized(), subTitle: "Share Ratings as per your experience with\nthe Restaurant food.".localized(), delemit: "\n", sizeTitle: 17, sizeSubtitle: 17, titleColor: AppColor.textColor, SubtitleColor: AppColor.placeHolderColor)
        
        
        
        
        txtView.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 14)!
        txtView.textColor = AppColor.placeHolderColor
        txtView.text = "Write here...".localized()
        txtView.delegate = self
        
        CommonClass.sharedInstance.provideCustomBorder(btnRef: viewText)
        CommonClass.sharedInstance.provideCustomBorder(btnRef: viewText)
        CommonClass.sharedInstance.provideCustomCornarRadius(btnRef: viewText, radius: 10)
        viewText.backgroundColor = AppColor.whiteColor
        
        CommonClass.sharedInstance.setupSubmitBtn(btnRef:self.btnLoginRef, title: "Submit".localized())
        
        
    }
    
 
    
    
    
    
}


extension ShareReviewVC:UITextViewDelegate{
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (txtView.text == "Write here...".localized())
            
        {
            txtView.text = nil
            txtView.textColor = AppColor.textColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtView.text.isEmpty
        {
            txtView.text = "Write here...".localized()
            txtView.textColor = AppColor.placeHolderColor
        }
        textView.resignFirstResponder()
    }
    
    
    
   
    
}
