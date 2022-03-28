//
//  ChangeLanguageVC.swift
//  Joker
//
//  Created by abc on 18/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class ChangeLanguageVC: UIViewController {
    
    @IBOutlet weak var englishBtn: UIButton!
    
    @IBOutlet weak var arabicBtn: UIButton!
    
    @IBOutlet weak var lblNav: UILabel!
    
    @IBOutlet weak var btnUpdateLanguage: UIButton!
    
    @IBOutlet weak var lblEnglish: UILabel!
    
    @IBOutlet weak var lblPortuese: UILabel!
    
    var selectedLanguage = ""
    let connection = webservices()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
            
            arabicBtn.setImage(UIImage(named: "selected"), for: .normal)
            englishBtn.setImage(UIImage(named: "unselected"), for: .normal)
            selectedLanguage = "Portuguese"
        }
        else{
            
            arabicBtn.setImage(UIImage(named: "unselected"), for: .normal)
            englishBtn.setImage(UIImage(named: "selected"), for: .normal)
            selectedLanguage = "English"
        }
        
        localization()
        
        //apiCallForGetUserDetail()
    }
    
    func localization(){
        
        lblEnglish.text = "English".localized()
        lblPortuese.text = "Portuguese".localized()
        
        
        
        lblNav.text = "Change Language".localized()
        btnUpdateLanguage.setTitle("Update Language".localized(), for: .normal)
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tap_updateLnguageBtn(_ sender: Any) {
        
        self.apiCallForUpdateLanguage()
    }
    
    
    @IBAction func tap_arabicBtn(_ sender: Any) {
        
        arabicBtn.setImage(UIImage(named: "selected"), for: .normal)
        englishBtn.setImage(UIImage(named: "unselected"), for: .normal)
        selectedLanguage = "Portuguese"
        
    }
    @IBAction func tap_englishBtn(_ sender: Any) {
        
        arabicBtn.setImage(UIImage(named: "unselected"), for: .normal)
        englishBtn.setImage(UIImage(named: "selected"), for: .normal)
        selectedLanguage = "English"
    }
    
}


extension ChangeLanguageVC{
    
    
    func apiCallForGetUserDetail(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param:[String:String] = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForUserDetail as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        if let response = receivedData.object(forKey: "response") as? NSDictionary{
                            
                            let appLanguage = response.object(forKey: "appLanguage") as? String ?? ""
                            
                            if appLanguage == "English"{
                                
                                self.arabicBtn.setImage(UIImage(named: "unselected"), for: .normal)
                                self.englishBtn.setImage(UIImage(named: "selected"), for: .normal)
                                
                                self.selectedLanguage = "English"
                            }
                            else{
                                
                                self.arabicBtn.setImage(UIImage(named: "selected"), for: .normal)
                                self.englishBtn.setImage(UIImage(named: "unselected"), for: .normal)
                                self.selectedLanguage = "Portuguese"
                            }
                        }
                        
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToHome()
                        }
                        else{
                            
                            CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                        }
                    }
                }
                else{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
    
    
    func apiCallForUpdateLanguage(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param:[String:String] = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","appLanguage":selectedLanguage]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForChangeLanguage as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        if self.selectedLanguage == "English"{
                            
                            UserDefaults.standard.set("en", forKey: "LANGUAGE")
                            Localize.setCurrentLanguage(language: "en")
                        }
                        else{
                            
                            UserDefaults.standard.set("ar", forKey: "LANGUAGE")
                            Localize.setCurrentLanguage(language: "pt-PT")
                        }
                        
                       self.navigationController?.popViewController(animated: true)
                        
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToHome()
                        }
                        else{
                            
                            CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                        }
                    }
                }
                else{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
    
}
