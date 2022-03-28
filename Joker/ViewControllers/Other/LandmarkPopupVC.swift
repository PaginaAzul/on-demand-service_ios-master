//
//  LandmarkPopupVC.swift
//  Joker
//
//  Created by Dacall soft on 04/04/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//


protocol PopToMapDelegate {
    
    func redirectionStatus(status:String)
}


import UIKit

class LandmarkPopupVC: UIViewController {

    
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var txtLocation: UITextField!
    
    @IBOutlet weak var lblSaveLocationAs: UILabel!
    
    @IBOutlet weak var btnHome: UIButton!
    
    @IBOutlet weak var btnOffice: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    
    var delegate:PopToMapDelegate?
    
    var latCordinate = Double()
    var longCordinate = Double()
    var addressStr = ""
    var buildingAndApartmentStr = ""
    
    
    var controllerPurpuse = ""
    var editableAddressId = ""
    var landmarkTitle = ""
    
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblLocation.text = addressStr
        
        if controllerPurpuse == "Edit"{
            
            self.txtLocation.text = landmarkTitle
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        lblSaveLocationAs.text = "Save Location As".localized()
        txtLocation.placeholder = "Save Location Manually".localized()
        btnHome.setTitle("Home".localized(), for: .normal)
        btnOffice.setTitle("Office".localized(), for: .normal)
        btnSave.setTitle("Save".localized(), for: .normal)
        btnCancel.setTitle("Cancel".localized(), for: .normal)
    }
    
    
    @IBAction func tap_cancelBtn(_ sender: Any) {
        
        let addressDict:NSDictionary = ["address":addressStr,"buildingAndApart":buildingAndApartmentStr,"lat":latCordinate,"long":longCordinate]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdateSavedAddress"), object: nil, userInfo: addressDict as? [AnyHashable : Any])
        
        self.delegate?.redirectionStatus(status: "Yes")
        self.dismiss(animated: true, completion: nil)
        
       // self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tap_saveBtn(_ sender: Any) {
        
        checkValidation()
    }
    
    @IBAction func tap_homeBtn(_ sender: Any) {
        
        txtLocation.text = "Home".localized()
    }
    
    @IBAction func tap_officeBtn(_ sender: Any) {
        
        txtLocation.text = "Office".localized()
    }
    
}

extension LandmarkPopupVC{
    
    func checkValidation(){
        
        var mess = ""
        
        if txtLocation.text == ""{
            
            mess = "Please fill manually or select the location title"
        }
        else{
            
            mess = ""
        }
        
        
        if mess == ""{
            
            
            if controllerPurpuse == ""{
                
                if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                    
                    self.apiCallForAddNewAddress()
                    
                }
                else{
                    
                    let addressDict:NSDictionary = ["address":addressStr,"buildingAndApart":buildingAndApartmentStr,"lat":latCordinate,"long":longCordinate]
                    
                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdateSavedAddress"), object: nil, userInfo: addressDict as? [AnyHashable : Any])
                    
                    self.delegate?.redirectionStatus(status: "Yes")
                    self.dismiss(animated: true, completion: nil)
                    
                }
               
            }
            else{
                
                self.apiCallForUpdateAddress()
            }
           
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
    }
    
    
    
    func apiCallForAddNewAddress(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","address":addressStr,"buildingAndApart":buildingAndApartmentStr,"landmark":txtLocation.text!,"lat":"\(latCordinate)","long":"\(longCordinate)","langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForAddNewAddress as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let dataArr = receivedData.object(forKey: "Data") as? NSArray ?? []
                        
                        let count = dataArr.count
                        
                        let dict = dataArr.object(at: count - 1) as? NSDictionary ?? [:]
                        
                     //   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdateSavedAddress"), object: dict)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdateSavedAddress"), object: nil, userInfo: dict as? [AnyHashable : Any])
                      
                        
                        
                        let alertController = UIAlertController(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            
                            self.delegate?.redirectionStatus(status: "Yes")
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
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
    
    
    
    func apiCallForUpdateAddress(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","addressId":editableAddressId,"address":addressStr,"buildingAndApart":buildingAndApartmentStr,"landmark":txtLocation.text!,"lat":"\(latCordinate)","long":"\(longCordinate)","langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForUpdateAddress as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let alertController = UIAlertController(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            
                            self.delegate?.redirectionStatus(status: "Yes")
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        
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
