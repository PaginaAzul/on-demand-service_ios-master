//
//  CommonClass.swift
//  Notari
//
//  Created by Callsoft on 25/09/17.
//  Copyright © 2017 Callsoft. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import CoreLocation


class CommonClass{
    
    static let sharedInstance = CommonClass()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var scrollManagerScreenIsOpen = false
    
    var globalUserID = ""
    
    var locationLatCordinate = Double()
    var locationLongCordinate = Double()
    
    var isUserProfessionalWorker = "false"
    var isUserDeliveryWorker = "false"
    // let animationViewLike = AnimationView(name: "501-like")
    
    var chatScreenIsOpen = false
    
    private init() {}
    
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
        
        
    }
    
    func checkRegexForName(name:String)->Bool{
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
            if regex.firstMatch(in: name, options: [], range: NSMakeRange(0, name.characters.count)) != nil {
                return false
                
            } else {
                return true
            }
        }
        catch {
            return false
        }
    }
    
    
    func redirectToHome(){
        
        UserDefaults.standard.set(false, forKey: "IsUserLogin")
        UserDefaults.standard.removeObject(forKey: "UserAuthorizationToken")
        UserDefaults.standard.removeObject(forKey: "USER_DATA")
        
        
        let vc = ScreenManager.getServiceProviderMapVC()//Old module
        
        // let vc = ScreenManager.MainModuleNew_VC()//New Module
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    func alertWithAction(){
        
        let alertController = UIAlertController(title: "", message: "You are not logged in. Please login/signup before proceeding further.".localized(), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            self.makeRootToLoginSignup()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        commonController.present(alertController, animated: true, completion: nil)
        
    }
    
    func show_Alert_PushToAnotherVC_Action(message: String, title: String) {
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            
            let vc = ScreenManager.MyCartNew_VC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDel.window?.rootViewController = navController
            appDel.window?.makeKeyAndVisible()
        }))
        commonController.present(refreshAlert, animated: true, completion: nil)
        //present(refreshAlert, animated: true, completion: nil)
    }
    
    func makeRootToLoginSignup(){
        
        let vc = ScreenManager.getSignInSignupVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDel.window?.rootViewController = navController
        appDel.window?.makeKeyAndVisible()
        
    }
    
    //    func showLoaderHeart(view: UIView) {
    //        view.isHidden = false
    //        animationViewLike.isHidden = false
    //       // animationViewLike.frame = CGRect(x: 0, y: -10, width: 60, height: 60)
    //        animationViewLike.frame.size.height = 30
    //        animationViewLike.frame.size.width = 30
    //       // animationViewDisLike.center = view.center
    //        animationViewLike.contentMode = .scaleAspectFill
    //        animationViewLike.animationSpeed = 2
    //        animationViewLike.loopMode = .loop
    //        view.addSubview(animationViewLike)
    //        animationViewLike.translatesAutoresizingMaskIntoConstraints = true
    //        animationViewLike.center = CGPoint(x: view.bounds.midX - 1, y: view.bounds.midY + 2)
    //        animationViewLike.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
    //        animationView.play()
    //    }
    
    
    func callNativeAlert(title:String,message:String,controller:UIViewController){
        
        let alert = UIAlertController(title: "", message: message.localized(), preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: nil))
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    //TODO: Set Attributed Text for Time label in tableViewCell
    func setTimeText(_ time:String,_ status:String)->NSMutableAttributedString{
        let myMutableString1 = NSMutableAttributedString()
        let normalText1 = "\(time)\n"
        let myMutableString2 = NSAttributedString(string: "\(normalText1) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :UIColor.black])
        let normalText2 = "\(status)"
        let myMutableString3 = NSAttributedString(string: "\(normalText2) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 9.0)!, .foregroundColor :UIColor.red])
        myMutableString1.append(myMutableString2)
        myMutableString1.append(myMutableString3)
        return myMutableString1
    }
    
    func getDistanceFromCurrentToAll(currentLocationLat:Double,currentLocationLong:Double,latitude:String,longitude:String) -> String{
        
        let lati = latitude.trimmingCharacters(in: .whitespaces)
        let longi = longitude.trimmingCharacters(in: .whitespaces)
        guard currentLocationLat != 0.0 || currentLocationLong != 0.0 || lati == "" || longi == "" else {
            return ""
        }
        let coordinate₀ = CLLocation(latitude: currentLocationLat, longitude: currentLocationLong)
        let coordinate₁ = CLLocation(latitude: Double(lati) ?? 0.0, longitude: Double(longi) ?? 0.0)
        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
        let distanceInKm = distanceInMeters / 1000
        var integerDistance = Int()
        if distanceInKm < 1.0 && distanceInKm > 0.0{
            integerDistance = 1
        }
        else{
            integerDistance = Int(distanceInKm)
        }
        return "\(integerDistance) \("KM".localized())"
        
    }
    
    //TODO: Set Attributed Text for Price label in tableViewCell
    func setPriceText(_ price:String,_ status:String)->NSMutableAttributedString{
        let myMutableString1 = NSMutableAttributedString()
        let normalText1 = "\(price)\n"
        let myMutableString2 = NSAttributedString(string: "\(normalText1) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13.0)!, .foregroundColor :UIColor.red])
        let normalText2 = "\(status)"
        let myMutableString3 = NSAttributedString(string: "\(normalText2) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 9.0)!, .foregroundColor :UIColor.black])
        myMutableString1.append(myMutableString2)
        myMutableString1.append(myMutableString3)
        return myMutableString1
    }
    
    //TODO: Set Attributed Text for Price label in tableViewCell
    func setOfferList(productName:String, shopeName:String, productDetail:String , price:String ,  lastPrice:String)->NSMutableAttributedString{
        
        let myMutableString1 = NSMutableAttributedString()
        let normalText1 = "\(productName)\n"
        
        let myMutableString2 = NSAttributedString(string: "\(normalText1)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 15.0)!, .foregroundColor :UIColor.black])
        
        let normalText2 = "\(shopeName)\n\(productDetail)"
        let myMutableString3 = NSAttributedString(string: "\(normalText2) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 12.0)!, .foregroundColor :UIColor.darkGray])
        
        
        
        myMutableString1.append(myMutableString2)
        myMutableString1.append(myMutableString3)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.alignment = .left
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 2 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        myMutableString1.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString1.length))
        
        return myMutableString1
        
    }
    
    func attributedString(title:String,title1:String,subTitle:String,delemit:String,sizeTitle:CGFloat,sizeSubtitle:CGFloat,titleColor:UIColor,SubtitleColor:UIColor,newText:String) -> NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString()
        
        if newText != ""{
            let myMutableString1 = NSAttributedString(string: "\(title)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 14)!, .foregroundColor :AppColor.textColor])
            
            
            let myMutableString2 = NSAttributedString(string: "\(title1)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13)!, .foregroundColor :UIColor.darkGray])
            
            let myMutableString3 = NSAttributedString(string: "\(subTitle)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 14)!, .foregroundColor :UIColor.black])
            
            myMutableString.append(myMutableString1)
            myMutableString.append(myMutableString2)
            myMutableString.append(myMutableString3)
            
        }else{
            if title1 != "" {
                
                
                let myMutableString1 = NSAttributedString(string: "\(title)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 14)!, .foregroundColor :AppColor.textColor])
                
                
                let myMutableString2 = NSAttributedString(string: "\(title1)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 11)!, .foregroundColor :UIColor.lightGray])
                
                
                let myMutableString3 = NSAttributedString(string: "\(subTitle)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 14)!, .foregroundColor :UIColor.black])
                
                myMutableString.append(myMutableString1)
                myMutableString.append(myMutableString2)
                
                myMutableString.append(myMutableString3)
                
            }else{
                
                let myMutableString1 = NSAttributedString(string: "\(title)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 14)!, .foregroundColor :AppColor.textColor])
                
                
                let myMutableString3 = NSAttributedString(string: "\(subTitle)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 14)!, .foregroundColor :UIColor.darkGray])
                
                myMutableString.append(myMutableString1)
                myMutableString.append(myMutableString3)
            }
        }
        
        
        
        
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 1 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        
        return myMutableString
    }
    
    
    
    func setOrderIDText(_ OrderID:String,_ status:String)->NSMutableAttributedString{
        let myMutableString1 = NSMutableAttributedString()
        let normalText1 = "\(OrderID) :"
        let myMutableString2 = NSAttributedString(string: "\(normalText1) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :UIColor.darkGray])
        let normalText2 = "\(status)"
        let myMutableString3 = NSAttributedString(string: "\(normalText2) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :UIColor.black])
        myMutableString1.append(myMutableString2)
        myMutableString1.append(myMutableString3)
        return myMutableString1
    }
    
    
    func setNoteText(_ NoteTxt:String,_ content:String)->NSMutableAttributedString{
        let myMutableString1 = NSMutableAttributedString()
        let normalText1 = "\(NoteTxt):"
        let myMutableString2 = NSAttributedString(string: "\(normalText1) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 11.0)!, .foregroundColor :UIColor(red:0.77, green:0.47, blue:1.00, alpha:1.0)])
        let normalText2 = "\(content)"
        let myMutableString3 = NSAttributedString(string: "\(normalText2) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 11.0)!, .foregroundColor :UIColor.darkGray])
        myMutableString1.append(myMutableString2)
        myMutableString1.append(myMutableString3)
        return myMutableString1
    }
    
    func setAvailableBalanceText(_ NoteTxt:String,_ content:String)->NSMutableAttributedString{
        let myMutableString1 = NSMutableAttributedString()
        let normalText1 = "\(NoteTxt)"
        let myMutableString2 = NSAttributedString(string: "\(normalText1) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 15.0)!, .foregroundColor :UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)])
        let normalText2 = "\(content)"
        let myMutableString3 = NSAttributedString(string: "\(normalText2) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 15.0)!, .foregroundColor :UIColor(red:0.73, green:0.36, blue:1.00, alpha:1.0)])
        myMutableString1.append(myMutableString2)
        myMutableString1.append(myMutableString3)
        return myMutableString1
    }
    
    
    func setMinimumOrderWithStarText()->NSMutableAttributedString{
        let myMutableString1 = NSMutableAttributedString()
        let normalText1 = "Minimum Offer 10+"
        let myMutableString2 = NSAttributedString(string: "\(normalText1) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :UIColor.darkGray])
        let normalText2 = "*"
        let myMutableString3 = NSAttributedString(string: "\(normalText2) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :UIColor(red:233/256, green:21/256, blue:32/256, alpha:1.0)])
        myMutableString1.append(myMutableString2)
        myMutableString1.append(myMutableString3)
        return myMutableString1
    }
    
    func setStartStatusWithUnderLineText(_ btnTitle:String)->NSMutableAttributedString{
        let myMutableString1 = NSMutableAttributedString()
        let myMutableString2 = NSAttributedString(string: "\(btnTitle) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 15.0)!, .foregroundColor :AppColor.themeColor, .underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        myMutableString1.append(myMutableString2)
        return myMutableString1
    }
    
    func attributedStringToDeliveryNewEnhancement(title1:String,subTitle1:String,delemit:String,titleColor1:UIColor,SubtitleColor1:UIColor,title2:String,subTitle2:String,titleColor2:UIColor,SubtitleColor2:UIColor,title3:String,subTitle3:String,titleColor3:UIColor,SubtitleColor3:UIColor,title4:String,subTitle4:String,titleColor4:UIColor,SubtitleColor4:UIColor) -> NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString()
        
        
        let myMutableString1 = NSAttributedString(string: "\(title1)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 12.0)!, .foregroundColor :titleColor1])
        
        let myMutableString2 = NSAttributedString(string: "\(subTitle1)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 12.0)!, .foregroundColor :SubtitleColor1])
        
        let myMutableString3 = NSAttributedString(string: "\(title2)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 12.0)!, .foregroundColor :titleColor2])
        
        let myMutableString4 = NSAttributedString(string: "\(subTitle2)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 12.0)!, .foregroundColor :SubtitleColor2])
        
        let myMutableString5 = NSAttributedString(string: "\(title3)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 12.0)!, .foregroundColor :titleColor3])
        
        let myMutableString6 = NSAttributedString(string: "\(subTitle3)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 12.0)!, .foregroundColor :SubtitleColor3])
        
        let myMutableString7 = NSAttributedString(string: "\(title4)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 12.0)!, .foregroundColor :titleColor4])
        
        let myMutableString8 = NSAttributedString(string: "\(subTitle4)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 12.0)!, .foregroundColor :SubtitleColor4])
        
        
        myMutableString.append(myMutableString1)
        myMutableString.append(myMutableString2)
        myMutableString.append(myMutableString3)
        myMutableString.append(myMutableString4)
        
        myMutableString.append(myMutableString5)
        myMutableString.append(myMutableString6)
        myMutableString.append(myMutableString7)
        myMutableString.append(myMutableString8)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // ** set LineSpacing property in points **
        paragraphStyle.lineSpacing = 5 // Whatever line spacing you want in points
        
        // ** Apply attribute to string **
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        
        return myMutableString
    }
    
    func openMapButtonAction(_ vc:UIViewController,_ lat: String,_ long: String) {
        
        let appleURL = "http://maps.apple.com/?daddr=\(lat),\(long)"
        let googleURL = "comgooglemaps://?daddr=\(lat),\(long)&directionsmode=driving"
        
        let googleItem = ("Google Map", URL(string:googleURL)!)
        var installedNavigationApps = [("Apple Maps", URL(string:appleURL)!)]
        
        if UIApplication.shared.canOpenURL(googleItem.1) {
            installedNavigationApps.append(googleItem)
        }
        
        let alert = UIAlertController(title: "Selection", message: "Select Navigation App", preferredStyle: .actionSheet)
        for app in installedNavigationApps {
            let button = UIAlertAction(title: app.0, style: .default, handler: { _ in
                UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
            })
            alert.addAction(button)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        vc.present(alert, animated: true)
    }
    
    func updateHomeTableViewCellLabel(title:String,cusineArray:[String],address:String,delemit:String)->NSMutableAttributedString{
        
        
        let myMutableString = NSMutableAttributedString()
        
        print("cusineArray",cusineArray.count , cusineArray)
        
        if title != "" {
            
            if cusineArray.count  == 0{
                
                let myMutableString1 = NSAttributedString(string: "\(title)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 17.0)!, .foregroundColor :AppColor.textColor])
                
                let myMutableString2 = NSAttributedString(string:"\("No Cuisine Available".localized())\n" , attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
                
                let myMutableString3 = NSAttributedString(string: "\(address)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
                
                myMutableString.append(myMutableString1)
                myMutableString.append(myMutableString2)
                myMutableString.append(myMutableString3)
                
            }else if cusineArray[0] == "" && cusineArray.count  == 1{
                
                let myMutableString1 = NSAttributedString(string: "\(title)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 17.0)!, .foregroundColor :AppColor.textColor])
                
                
                //                let myMutableString2 = NSAttributedString(string:"\("No Cuisine Available".localized())\n" , attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
                
                let myMutableString3 = NSAttributedString(string: "\(address)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
                
                myMutableString.append(myMutableString1)
                // myMutableString.append(myMutableString2)
                myMutableString.append(myMutableString3)
            }else{
                
                print("Cuisines Count", cusineArray , cusineArray.count)
                
                let myMutableString1 = NSAttributedString(string: " \(title)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 17.0)!, .foregroundColor :AppColor.textColor])
                
                
                let ineterPunctStr = NSAttributedString(string: " • ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
                
                var newArr = cusineArray
                newArr.insert("", at: 0)
                
                let interPunctJointString = newArr.joined(separator: ineterPunctStr.string)
                
                let myMutableString2 = NSAttributedString(string: "\(interPunctJointString)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
                
                let myMutableString3 = NSAttributedString(string: " \(address)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
                
                
                myMutableString.append(myMutableString1)
                myMutableString.append(myMutableString2)
                myMutableString.append(myMutableString3)
                
            }
            
        }else if cusineArray.count  == 0{
            
            let myMutableString1 = NSAttributedString(string: " \(title)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 17.0)!, .foregroundColor :AppColor.textColor])
            
            
            let myMutableString2 = NSAttributedString(string:"\("No Cuisine Available".localized())\n" , attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
            
            
            let myMutableString3 = NSAttributedString(string: " \(address)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
            
            
            myMutableString.append(myMutableString1)
            myMutableString.append(myMutableString2)
            myMutableString.append(myMutableString3)
            
        }else if cusineArray[0] == "" && cusineArray.count  == 1{
            
            let myMutableString1 = NSAttributedString(string: "\(address)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
            
            myMutableString.append(myMutableString1)
        }else{
            
            let ineterPunctStr = NSAttributedString(string: " • ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
            
            var newArr = cusineArray
            
            newArr.insert("", at: 0)
            
            let interPunctJointString = newArr.joined(separator: ineterPunctStr.string)
            
            let myMutableString2 = NSAttributedString(string: "\(interPunctJointString)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
            
            
            let myMutableString3 = NSAttributedString(string: " \(address)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
            
            myMutableString.append(myMutableString2)
            myMutableString.append(myMutableString3)
            
        }
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.alignment = .left
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 3 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        
        return myMutableString
    }
    
    func updateHomeTableViewCellLabelGrocery(title:String,cusineArray:[String],address:String,delemit:String)->NSMutableAttributedString{
        
        let myMutableString = NSMutableAttributedString()
        
        print("cusineArray",cusineArray.count , cusineArray)
        
        if title != "" {
            
            if cusineArray.count  == 0{
                
                let myMutableString1 = NSAttributedString(string: "\(title)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 17.0)!, .foregroundColor :AppColor.textColor])
                
                let myMutableString3 = NSAttributedString(string: "\(address)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
                
                myMutableString.append(myMutableString1)
                myMutableString.append(myMutableString3)
                
            }else if cusineArray[0] == "" && cusineArray.count  == 1{
                
                let myMutableString1 = NSAttributedString(string: "\(title)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 17.0)!, .foregroundColor :AppColor.textColor])
                
                //                let myMutableString2 = NSAttributedString(string:"\("No Cuisine Available".localized())\n" , attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
                
                let myMutableString3 = NSAttributedString(string: "\(address)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
                
                myMutableString.append(myMutableString1)
                // myMutableString.append(myMutableString2)
                myMutableString.append(myMutableString3)
                
            }else{
                
                print("Cuisines Count", cusineArray , cusineArray.count)
                
                let myMutableString1 = NSAttributedString(string: " \(title)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 17.0)!, .foregroundColor :AppColor.textColor])
                
                
                let ineterPunctStr = NSAttributedString(string: " • ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
                
                var newArr = cusineArray
                newArr.insert("", at: 0)
                
                let interPunctJointString = newArr.joined(separator: ineterPunctStr.string)
                
                let myMutableString2 = NSAttributedString(string: "\(interPunctJointString)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
                
                let myMutableString3 = NSAttributedString(string: " \(address)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
                
                
                myMutableString.append(myMutableString1)
                myMutableString.append(myMutableString2)
                myMutableString.append(myMutableString3)
                
            }
            
        }else if cusineArray.count  == 0{
            
            let myMutableString1 = NSAttributedString(string: " \(title)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 17.0)!, .foregroundColor :AppColor.textColor])
            
            let myMutableString2 = NSAttributedString(string: " \(address)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
            
            myMutableString.append(myMutableString1)
            myMutableString.append(myMutableString2)
            
        }else if cusineArray[0] == "" && cusineArray.count  == 1{
            
            
            let myMutableString1 = NSAttributedString(string: "\(address)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
            
            myMutableString.append(myMutableString1)
        }else{
            
            let ineterPunctStr = NSAttributedString(string: " • ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
            
            var newArr = cusineArray
            
            newArr.insert("", at: 0)
            
            let interPunctJointString = newArr.joined(separator: ineterPunctStr.string)
            
            let myMutableString2 = NSAttributedString(string: "\(interPunctJointString)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
            
            
            let myMutableString3 = NSAttributedString(string: " \(address)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :AppColor.subtitleColor])
            
            myMutableString.append(myMutableString2)
            myMutableString.append(myMutableString3)
            
        }
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.alignment = .left
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 3 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        
        return myMutableString
    }
    
    func attributedStringToDeliveryReEnhancement(title1:String,subTitle1:String,delemit:String,titleColor1:UIColor,SubtitleColor1:UIColor,title2:String,subTitle2:String,titleColor2:UIColor,SubtitleColor2:UIColor,title3:String,subTitle3:String,titleColor3:UIColor,SubtitleColor3:UIColor,title4:String,subTitle4:String,titleColor4:UIColor,SubtitleColor4:UIColor,title5:String,subTitle5:String,titleColor5:UIColor,SubtitleColor5:UIColor) -> NSMutableAttributedString{
        
        let myMutableString = NSMutableAttributedString()
        
        let myMutableString1 = NSAttributedString(string: "\(title1)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 12.0)!, .foregroundColor :titleColor1])
        
        let myMutableString2 = NSAttributedString(string: "\(subTitle1)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 12.0)!, .foregroundColor :SubtitleColor1])
        
        let myMutableString3 = NSAttributedString(string: "\(title2)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 12.0)!, .foregroundColor :titleColor2])
        
        let myMutableString4 = NSAttributedString(string: "\(subTitle2)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 12.0)!, .foregroundColor :SubtitleColor2])
        
        let myMutableString5 = NSAttributedString(string: "\(title3)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 12.0)!, .foregroundColor :titleColor3])
        
        let myMutableString6 = NSAttributedString(string: "\(subTitle3)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 12.0)!, .foregroundColor :SubtitleColor3])
        
        let myMutableString7 = NSAttributedString(string: "\(title4)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 12.0)!, .foregroundColor :titleColor4])
        
        let myMutableString8 = NSAttributedString(string: "\(subTitle4)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 12.0)!, .foregroundColor :SubtitleColor4])
        
        let myMutableString9 = NSAttributedString(string: "\(title5)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 12.0)!, .foregroundColor :titleColor4])
        
        let myMutableString10 = NSAttributedString(string: "\(subTitle5)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 12.0)!, .foregroundColor :SubtitleColor4])
        
        
        myMutableString.append(myMutableString1)
        myMutableString.append(myMutableString2)
        myMutableString.append(myMutableString3)
        myMutableString.append(myMutableString4)
        
        myMutableString.append(myMutableString5)
        myMutableString.append(myMutableString6)
        myMutableString.append(myMutableString7)
        myMutableString.append(myMutableString8)
        
        myMutableString.append(myMutableString9)
        myMutableString.append(myMutableString10)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // ** set LineSpacing property in points **
        paragraphStyle.lineSpacing = 5 // Whatever line spacing you want in points
        
        // ** Apply attribute to string **
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        
        return myMutableString
    }
    func attributedStringOfferNew(title:String,subTitle:String,subTitle2:String,delemit:String,sizeTitle:CGFloat,sizeSubtitle2:CGFloat,sizeSubtitle:CGFloat,titleColor:UIColor,SubtitleColor:UIColor,SubtitleColor2:UIColor) -> NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString()
        
        
        let myMutableString1 = NSAttributedString(string: "\(title)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: sizeTitle)!, .foregroundColor :titleColor])
        
        let myMutableString2 = NSAttributedString(string: "\(subTitle)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: sizeSubtitle)!, .foregroundColor :SubtitleColor])
        
        let myMutableString3 = NSAttributedString(string: "\(subTitle2)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: sizeSubtitle2)!, .foregroundColor :SubtitleColor2])
        
        //let myMutableString4 = NSAttributedString(string: "\(StatusTitle)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: sizeStatus)!, .foregroundColor :statusColor])
        
        
        myMutableString.append(myMutableString1)
        myMutableString.append(myMutableString2)
        myMutableString.append(myMutableString3)
        //myMutableString.append(myMutableString4)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 0 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        
        return myMutableString
    }
    
    func attributedStringOffer(title:String,subTitle:String,subTitle2:String,delemit:String,sizeTitle:CGFloat,sizeSubtitle2:CGFloat,sizeSubtitle:CGFloat,titleColor:UIColor,SubtitleColor:UIColor,SubtitleColor2:UIColor) -> NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString()
        
        
        let myMutableString1 = NSAttributedString(string: "\(title)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: sizeTitle)!, .foregroundColor :titleColor])
        
        let myMutableString2 = NSAttributedString(string: "\(subTitle)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: sizeSubtitle)!, .foregroundColor :SubtitleColor])
        
        let myMutableString3 = NSAttributedString(string: "\(subTitle2)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: sizeSubtitle2)!, .foregroundColor :SubtitleColor2])
        
        myMutableString.append(myMutableString1)
        myMutableString.append(myMutableString2)
        myMutableString.append(myMutableString3)
        
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 5 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        
        return myMutableString
        
    }
    
    func attributedStringOnGing(title:String,subTitle:String,delemit:String,sizeTitle:CGFloat,sizeSubtitle:CGFloat,titleColor:UIColor,SubtitleColor:UIColor) -> NSMutableAttributedString{
        
        let myMutableString = NSMutableAttributedString()
        
        let myMutableString1 = NSAttributedString(string: "\(title)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: sizeTitle)!, .foregroundColor :titleColor])
        
        let myMutableString2 = NSAttributedString(string: "\(subTitle)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: sizeSubtitle)!, .foregroundColor :SubtitleColor])
        
        myMutableString.append(myMutableString1)
        myMutableString.append(myMutableString2)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.alignment = .left
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 3 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        
        return myMutableString
    }
    //TODO: Forgot password header
    
    func attributedStringForgotPassword(title:String,subTitle:String,delemit:String,sizeTitle:CGFloat,sizeSubtitle:CGFloat,titleColor:UIColor,SubtitleColor:UIColor) -> NSMutableAttributedString{
        let myMutableString = NSMutableAttributedString()
        
        
        let myMutableString1 = NSAttributedString(string: "\(title)\(delemit)\(delemit)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: sizeTitle)!, .foregroundColor :titleColor])
        
        
        
        let myMutableString2 = NSAttributedString(string: "\(subTitle)", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: sizeSubtitle)!, .foregroundColor :SubtitleColor])
        
        myMutableString.append(myMutableString1)
        myMutableString.append(myMutableString2)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.alignment = .center
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 3 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        myMutableString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, myMutableString.length))
        
        return myMutableString
    }
    
    //TODO: Setup SUBMIT buttton
    
    func setupSubmitBtn(btnRef:UIButton,title:String){
        btnRef.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 17)!
        btnRef.setTitle(title, for: .normal)
        btnRef.backgroundColor = AppColor.themeColor
        provideCornarRadius(btnRef:btnRef)
        provideShadow(btnRef:btnRef)
    }
    
    
    func provideShadow(btnRef:UIView){
        btnRef.layer.shadowColor = AppColor.placeHolderColor.cgColor
        btnRef.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        btnRef.layer.shadowOpacity = 1.0
        btnRef.layer.shadowRadius = 2.0
        btnRef.layer.masksToBounds = false
    }
    
    func provideShadowFourSide(btnRef:UIView){
        
        btnRef.layer.masksToBounds = false
        btnRef.layer.shadowColor = AppColor.placeHolderColor.cgColor
        btnRef.layer.shadowOffset =  CGSize.zero
        btnRef.layer.shadowOpacity = 0.5
        btnRef.layer.shadowRadius = 4
    }
    
    func provideCornarRadius(btnRef:UIView){
        btnRef.layer.cornerRadius = btnRef.frame.size.height / 2
        
    }
    
    func provideCustomCornarRadius(btnRef:UIView,radius:CGFloat){
        btnRef.layer.cornerRadius = radius
    }
    
    //TODO: Provide custom Corner radius
    func provideCustomBorder(btnRef:UIView){
        btnRef.layer.borderColor = AppColor.placeHolderColor.cgColor
        btnRef.layer.borderWidth = 1
    }
}

struct AppColor {
    
    //MARK: - Constant colors
    public static let textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    public static let textNewColor = #colorLiteral(red: 0.005922678392, green: 0.2903580964, blue: 0.4203877747, alpha: 1)
    public static let placeHolderColor = #colorLiteral(red: 0.6461701989, green: 0.6461701989, blue: 0.6461701989, alpha: 1)
    public static let newGray = #colorLiteral(red: 0.6643554568, green: 0.6643554568, blue: 0.6643554568, alpha: 1)
    public static let themeColor = #colorLiteral(red: 0.03607749939, green: 0.572451055, blue: 0.8170866966, alpha: 1)
    public static let whiteColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    public static let subtitleColor = #colorLiteral(red: 0.3510887921, green: 0.3510887921, blue: 0.3510887921, alpha: 1)
    public static let lightGrayColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    public static let lightGreenColor = #colorLiteral(red: 0.581096828, green: 0.7671839595, blue: 0.4724182487, alpha: 1)
    public static let darkGreenColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    // public static let themeColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
}
