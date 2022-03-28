//
//  SSBadgeButton.swift
//  Joker
//
//  Created by User on 21/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit

class SSBadgeButton: UIButton {

    var badgeLabel = UILabel()
        
        var badge: String? {
            didSet {
                addBadgeToButon(badge: badge)
            }
        }

        public var badgeBackgroundColor = UIColor.red {
            didSet {
                badgeLabel.backgroundColor = badgeBackgroundColor
            }
        }
        
        public var badgeTextColor = UIColor.white {
            didSet {
                badgeLabel.textColor = badgeTextColor
            }
        }
        
        public var badgeFont = UIFont.systemFont(ofSize: 12.0) {
            didSet {
                badgeLabel.font = badgeFont
            }
        }
        
        public var badgeEdgeInsets: UIEdgeInsets? {
            didSet {
                addBadgeToButon(badge: badge)
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addBadgeToButon(badge: nil)
        }
    
    func removeHide(){
        badgeLabel.textColor = .clear
        badgeLabel.backgroundColor = .clear

    }
    
        func addBadgeToButon(badge: String?) {
            badgeLabel.text = badge
            badgeLabel.textColor = badgeTextColor
            badgeLabel.backgroundColor = badgeBackgroundColor
            badgeLabel.font = badgeFont
            badgeLabel.sizeToFit()
            badgeLabel.textAlignment = .center
            let badgeSize = badgeLabel.frame.size
            
            let height = max(18, Double(badgeSize.height) + 5.0)
            let width = max(height, Double(badgeSize.width) + 10.0)
            
            var vertical: Double?, horizontal: Double?
            if let badgeInset = self.badgeEdgeInsets {
                vertical = Double(badgeInset.top) - Double(badgeInset.bottom)
                horizontal = Double(badgeInset.left) - Double(badgeInset.right)
                
                let x = (Double(bounds.size.width) - 10 + horizontal!)
                let y = -(Double(badgeSize.height) / 2) - 10 + vertical!
                badgeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
            } else {
                let x = self.frame.width - CGFloat((width / 2.0))
                let y = CGFloat(-(height / 2.0))
                badgeLabel.frame = CGRect(x: x, y: y, width: CGFloat(width), height: CGFloat(height))
            }
            
            badgeLabel.layer.cornerRadius = badgeLabel.frame.height/2
            badgeLabel.layer.masksToBounds = true
            addSubview(badgeLabel)
            badgeLabel.isHidden = badge != nil ? false : true
            
            badgeLabel.isUserInteractionEnabled = false
            self.isUserInteractionEnabled = false
        }
        
    
    
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.addBadgeToButon(badge: nil)
            fatalError("init(coder:) has not been implemented")
        }

}

func setBage(_ btnCart:UIButton , _ badge:String){
    
    let notificationButton = SSBadgeButton()
   
    
    if badge == "0" {
        
        
        notificationButton.removeHide()
       // notificationButton.removeFromSuperview()
        notificationButton.badgeLabel = UILabel()
        notificationButton.backgroundColor = .clear
        notificationButton.badgeLabel.backgroundColor = .clear
        notificationButton.badgeLabel.textColor = .clear
//        for view:notificationButton? in btnCart.subviews {
//                if view.isKindOfClass(notificationButton) {
//                    view.doClassThing()
//                }
//            }
        
        
        btnCart.subviews.forEach ({
            if $0 is UIButton {
                $0.removeFromSuperview()
            }
        })
        
    }else{
        
        
        btnCart.subviews.forEach ({
            if $0 is UIButton {
                $0.removeFromSuperview()
            }
        })
        
        notificationButton.frame = CGRect(x: btnCart.frame.width/2 - 22, y: btnCart.frame.height/2 - 22, width: 44, height: 44)
        notificationButton.setImage(UIImage(named: "Notification")?.withRenderingMode(.alwaysTemplate), for: .normal)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 12)
        notificationButton.badge = badge
        
        notificationButton.isHidden = false
        btnCart.addSubview(notificationButton)

    }
   
   
}
