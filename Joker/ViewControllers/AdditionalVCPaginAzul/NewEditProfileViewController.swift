//
//  NewEditProfileViewController.swift
//  Joker
//
//  Created by retina on 19/06/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit
import DropDown

class NewEditProfileViewController: UIViewController {

    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtCountryCode: UITextField!
    
    @IBOutlet weak var txtAppLang: UITextField!
    
    @IBOutlet weak var txtSpeakLang: UITextField!
    
    @IBOutlet weak var lblNav: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    var globalNameStatus = "true"
    
    let connection = webservices()

    var speakLangArr = ["English","Portuguese"]
    var appLangArr = ["English".localized(),"Portuguese".localized()]
    
    let validation:Validation = Validation.validationManager() as! Validation
    let dropDown = DropDown()
    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    var imageName = ""
    var dropdownTag = 0
    var userDataDict = NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtCountryCode.isUserInteractionEnabled = false
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        updateElement()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            if self.dropdownTag == 0{
                
               // self.txtGender.text = "\(item)"
            }
            else if self.dropdownTag == 1{
                
                self.txtAppLang.text = "\(item)"
                
                
            }
            else{
                
                self.txtSpeakLang.text = "\(item)"
            }
            
        }
        
        
        localization()
    }
    
    
    func localization(){
        
        lblNav.text = "My Profile".localized()
        btnEdit.setTitle("Edit".localized(), for: .normal)
        txtName.placeholder = "Name".localized()
        txtEmail.placeholder = "Email".localized()
        txtAppLang.placeholder = "Select App Language".localized()
        txtSpeakLang.placeholder = "Select Speak Language".localized()
        btnSave.setTitle("Save".localized(), for: .normal)
    }
    
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tap_cameraBtn(_ sender: Any) {
        
        showImagePicker()
    }
    
    @IBAction func tap_saveBtn(_ sender: Any) {
        
        checkValidation()
    }
    
    @IBAction func btnSpeakLang(_ sender: Any) {
        
        dropdownTag = 2
        dropDown.dataSource = speakLangArr
        dropDown.anchorView = txtSpeakLang
        dropDown.show()

    }
    
    @IBAction func btnAppLang(_ sender: Any) {
        
        dropdownTag = 1
        dropDown.dataSource = appLangArr
        dropDown.anchorView = txtAppLang
        dropDown.show()
    }
   
    @IBAction func tap_editBtn(_ sender: Any) {
        
        let vc = ScreenManager.getUpdatePhoneVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension NewEditProfileViewController{
    
    func updateElement(){
        
        if userDataDict.count != 0{
            
            let countryName = userDataDict.object(forKey: "country") as? String ?? ""
            let countryCode = userDataDict.object(forKey: "countryCode") as? String ?? ""
        
            let email = userDataDict.object(forKey: "email") as? String ?? ""
            let appLanguage = userDataDict.object(forKey: "appLanguage") as? String ?? ""
            let speakLanguage = userDataDict.object(forKey: "speakLanguage") as? String ?? ""
            let name = userDataDict.object(forKey: "name") as? String ?? ""
            
            self.globalNameStatus = userDataDict.object(forKey: "userName") as? String ?? ""
            
            if self.globalNameStatus == "true"{
                
                self.txtName.text = name
            }
            else{
                
                self.txtName.text = name
            }
            
            let mobile = userDataDict.object(forKey: "mobileNumber") as? String ?? ""
            
            txtCountryCode.text = "\(countryCode) - \(mobile)"
    
            txtEmail.text = email
            let appLang = appLanguage
            txtAppLang.text = appLang.localized()
            txtSpeakLang.text = "English"
            
            imgUser.layer.cornerRadius = imgUser.frame.size.width/2
            imgUser.clipsToBounds = true
            
            let imgStr = userDataDict.object(forKey: "profilePic") as? String ?? ""
            
            let imgUrl = URL(string: imgStr)
            
            if imgUrl != nil{
                
                imgUser.setImageWith(imgUrl!, placeholderImage: UIImage(named:"newPlace"))
                
                if let data = try? Data(contentsOf: imgUrl!)
                {
                    self.imageData = data as NSData
                }
                
            }
            
        }
        
    }
}


extension NewEditProfileViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func camera(){
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func photoLibrary() {
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showImagePicker(){
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            
            actionSheet.addAction(UIAlertAction(title: "Camera".localized(), style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
                
                self.camera()
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Gallery".localized(), style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
                
                self.photoLibrary()
                
            }))
            
        }else {
            
            actionSheet.addAction(UIAlertAction(title: "Gallery".localized(), style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
                
                self.photoLibrary()
                
            }))
            
        }
        
        actionSheet.addAction(UIAlertAction(title:"Cancel".localized(), style: UIAlertActionStyle.cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            
            let popup = UIPopoverController(contentViewController: actionSheet)
            
            popup.present(from: CGRect(), in: self.view!, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
            
        }else{
            
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        imgUser.image = chosenImage
        imageData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
        imageName = "user_image.jpg"
        
        dismiss(animated: true, completion: nil)
    }
}


extension NewEditProfileViewController{
    
    func checkValidation(){
        
        var mess = ""
        
        if txtName.text == "" && self.globalNameStatus == "false"{
            
            mess = "Please enter name"
        }
        else if txtName.text == "" && self.globalNameStatus == "true"{
            
            mess = "Please enter user name"
        }
        else if txtEmail.text == ""{
            
            mess = "Please enter email"
        }
        else if !validation.validateEmail(txtEmail.text!){
            
            mess = "Please enter valid email address"
        }
        else if txtAppLang.text == ""{
            
            mess = "Please select app language"
        }
//        else if txtSpeakLang.text == ""{
//
//            mess = "Please select speak language"
//        }
        else{
            
            mess = ""
        }
        
        if mess == ""{
            
            self.apiCallForEditProfile()
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
    }
    
    
    func apiCallForEditProfile(){
        
        var sendName = ""
        
        if self.globalNameStatus == "true"{
            
            sendName = txtName.text!
        }
        else{
            
            sendName = txtName.text!
        }
        
        var lang = String()
        for i in 0..<appLangArr.count {
            
            if txtAppLang.text! == appLangArr[i] {
                lang = speakLangArr[i]
                break;
            }else{
                lang = txtAppLang.text!
            }
            
        }

        if lang == "Portuguese".localized(){
            UserDefaults.standard.set("ar", forKey: "LANGUAGE")
        }else{
            UserDefaults.standard.set("en", forKey: "LANGUAGE")
        }
            
        let param:[String:String] = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","name":sendName,"gender":"Male","dob":"12/08/1993","country":UserDefaults.standard.value(forKey: "CountryName") as? String ?? "","email":txtEmail.text!,"appLanguage":lang,"speakLanguage":txtSpeakLang.text!,"langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]
        print("param",param)
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithProfileData(imageData: imageData, fileName: "UserProfile.png", imageparm: "profilePic", getUrlString: App.URLs.apiCallForUpdateProfile as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                      //  CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
                        
                        if self.txtAppLang.text == "English".localized(){
                            
                            UserDefaults.standard.set("en", forKey: "LANGUAGE")
                            Localize.setCurrentLanguage(language: "en")
                        }
                        else{
                            
                            UserDefaults.standard.set("ar", forKey: "LANGUAGE")
                            Localize.setCurrentLanguage(language: "pt-PT")
                        }
                        
                        let alertController = UIAlertController(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            
                           self.navigationController?.popViewController(animated: true)
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
