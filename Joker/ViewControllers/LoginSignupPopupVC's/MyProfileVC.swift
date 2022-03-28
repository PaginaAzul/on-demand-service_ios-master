//
//  MyProfileVC.swift
//  Joker
//
//  Created by Callsoft on 30/01/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import DropDown


class MyProfileVC: UIViewController {

    
    @IBOutlet weak var lblMyId: UILabel!
    
    @IBOutlet weak var imgUserProfile: UIImageView!
    
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var txtFullName: UITextField!
    
    @IBOutlet weak var txtGender: UITextField!
    
    @IBOutlet weak var txtDob: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPhoneNo: UITextField!
    
    @IBOutlet weak var txtCountry: UITextField!
    
    @IBOutlet weak var txtAppLanguage: UITextField!
    
    @IBOutlet weak var txtSpeakLanguage: UITextField!
    
    @IBOutlet weak var viewGender: UIView!
    
    @IBOutlet weak var viewAppLanguage: UIView!
    
    @IBOutlet weak var viewSpeakLanguage: UIView!
    
    
    var countryCodeArray = NSMutableArray()
    var arrayFromPlist = NSMutableArray()
    var countryCodeCheck = false
    let connection = webservices()
    
    var genderArr = ["Male","Female"]
    var speakLangArr = ["English","Portuguese"]
    var appLangArr = ["English","Portuguese"]
    
    let validation:Validation = Validation.validationManager() as! Validation
    let dropDown = DropDown()
    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    var imageName = ""
    var dropdownTag = 0
    var userDataDict = NSDictionary()
    
    var globalNameStatus = "true"
    
    var signupAsDeliveryPerson = ""
    var signupAsProfessionalPerson = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtGender.text = "Male"
        txtDob.text = "12/08/1993"
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        self.apiCallForGetUserDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            if self.dropdownTag == 0{
                
                self.txtGender.text = "\(item)"
            } else if self.dropdownTag == 1{
                
                self.txtAppLanguage.text = "\(item)"
            }else{
                
                self.txtSpeakLanguage.text = "\(item)"
            }
            
        }
      
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(true)
        
        loadPlistDataatLoadTime()
        
    }
   
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_captainProfile(_ sender: Any) {
        
//        let vc = ScreenManager.getMyCaptionScrollManagerVC()
//        self.navigationController?.pushViewController(vc, animated: true)
        
        
        if self.signupAsDeliveryPerson == "false" && self.signupAsProfessionalPerson == "false"{
            
            let vc = ScreenManager.getDeliveryProfessionalSignupPopupVC()
            vc.nabObj = self
            self.present(vc, animated: true, completion: nil)
            
        } else {
            
            if self.signupAsProfessionalPerson == "true" && self.signupAsDeliveryPerson == "true" {
                
                let vc = ScreenManager.getMyCaptionScrollManagerVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }else if self.signupAsProfessionalPerson == "true"{
                
                let vc = ScreenManager.getMyCaptionScrollManagerVC()
                vc.signupUserType = "Professional"
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                
                let vc = ScreenManager.getMyCaptionScrollManagerVC()
                vc.signupUserType = "Delivery"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func tap_myRate(_ sender: Any) {
        
        let vc = ScreenManager.getMyRateVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_contactAdmin(_ sender: Any) {
        
        let vc = ScreenManager.getContactAdminVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func tap_editBtn(_ sender: Any) {
        
        let vc = ScreenManager.getUpdatePhoneVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_saveBtn(_ sender: Any) {
        
        checkValidation()
    }
    
    @IBAction func tap_dobBtn(_ sender: Any) {
        
        openDatePicker()
    }
    
    @IBAction func tap_genderBtn(_ sender: Any) {
        
        dropdownTag = 0
        dropDown.dataSource = genderArr
        dropDown.anchorView = viewGender
        dropDown.show()
    }
    
    @IBAction func tap_countryBtn(_ sender: Any) {
        
        showCountryPicker()
    }
    
    @IBAction func tap_appLanguageBtn(_ sender: Any) {
        
        dropdownTag = 1
        dropDown.dataSource = appLangArr
        dropDown.anchorView = viewAppLanguage
        dropDown.show()
    }
    
    @IBAction func tap_speakLanguageBtn(_ sender: Any) {
        
        dropdownTag = 2
        dropDown.dataSource = speakLangArr
        dropDown.anchorView = viewSpeakLanguage
        dropDown.show()
    }
    
    @IBAction func tap_profileBtn(_ sender: Any) {
        
        showImagePicker()
    }
    
}


extension MyProfileVC{
    
    func updateElement(){
        
        if userDataDict.count != 0 {
            
            let countryName = userDataDict.object(forKey: "country") as? String ?? ""
            let countryCode = userDataDict.object(forKey: "countryCode") as? String ?? ""
         //   let gender = userDataDict.object(forKey: "gender") as? String ?? ""
            let email = userDataDict.object(forKey: "email") as? String ?? ""
            let appLanguage = userDataDict.object(forKey: "appLanguage") as? String ?? ""
            let speakLanguage = userDataDict.object(forKey: "speakLanguage") as? String ?? ""
            let name = userDataDict.object(forKey: "name") as? String ?? ""
          //  let userName = userDataDict.object(forKey: "userName") as? String ?? ""
          //  let fullName = userDataDict.object(forKey: "fullName") as? String ?? ""
           // let dob = userDataDict.object(forKey: "dob") as? String ?? ""
            let mobileNo = userDataDict.object(forKey: "mobileNumber") as? String ?? ""
            
            self.lblMyId.text = "My ID : \(userDataDict.object(forKey: "_id") as? String ?? "")"
           
            
            self.signupAsDeliveryPerson = userDataDict.object(forKey: "signupWithDeliveryPerson") as? String ?? ""
            self.signupAsProfessionalPerson = userDataDict.object(forKey: "signupWithProfessionalWorker") as? String ?? ""
            
                
            self.globalNameStatus = userDataDict.object(forKey: "userName") as? String ?? ""
                
            if self.globalNameStatus == "true"{
                    
                self.txtUserName.text = name
            }
            else{
                    
                self.txtFullName.text = name
            }
           
            
            UserDefaults.standard.set(countryName, forKey: "CountryName")
            
            UserDefaults.standard.setValue(countryCode, forKey: "CountryCode")
            
            txtCountry.text = "\(countryCode) - \(countryName)"
           // txtGender.text = gender
            txtEmail.text = email
            txtAppLanguage.text = appLanguage
            txtSpeakLanguage.text = speakLanguage
           // txtFullName.text = name
           // txtDob.text = dob
            txtPhoneNo.text = mobileNo
            
            let imgStr = userDataDict.object(forKey: "profilePic") as? String ?? ""
            
            let imgUrl = URL(string: imgStr)
            
            if imgUrl != nil{
                
                imgUserProfile.setImageWith(imgUrl!, placeholderImage: UIImage(named:"userPlaceholder"))
                
                if let data = try? Data(contentsOf: imgUrl!)
                {
                    self.imageData = data as NSData
                }
                
            }
            
        }
        
    }
    
    
    func checkValidation(){
        
        var mess = ""
        
        if txtFullName.text == "" && self.globalNameStatus == "false"{
            
            mess = "Please enter name"
        }
        else if txtUserName.text == "" && self.globalNameStatus == "true"{
            
            mess = "Please enter user name"
        }
//        else if txtGender.text == ""{
//
//            mess = "Please select gender"
//        }
//        else if txtDob.text == ""{
//
//            mess = "Please select date of birth"
//        }
        else if txtEmail.text == ""{
            
            mess = "Please select email"
        }
        else if !validation.validateEmail(txtEmail.text!){
            
            mess = "Please enter valid email"
        }
        else if txtAppLanguage.text == ""{
            
            mess = "Please select app language"
        }
        else if txtSpeakLanguage.text == ""{
            
            mess = "Please select speak language"
        }
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
    
    
    
    func openDatePicker(){
        
        var baseview: UIView!
        baseview = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height-350, width: self.view.frame.size.width, height: 350))
        baseview.backgroundColor = UIColor(red:0.75, green:0.44, blue:0.99, alpha:1.0)
        baseview.tag = 668
        self.view.addSubview(baseview)
        self.view.bringSubview(toFront: baseview)
        self.view.endEditing(true)
        
        let doneButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.black, for: .normal)
        doneButton.backgroundColor = UIColor.clear
        doneButton.addTarget(self, action: #selector(doneButtonActionFordatePicker), for: .touchUpInside)
        baseview.addSubview(doneButton)
        
        
        let cancelButton: UIButton = UIButton(frame: CGRect(x: baseview.frame.size.width-100, y: 0, width: 100, height: 50))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.addTarget(self, action: #selector(cancelButtonActionFordatePicker), for: .touchUpInside)
        baseview.addSubview(cancelButton)
        
        let minDate = setMinAndMaxDateForDatePicker(maxYear: 0, minYear: 200).0
        let maxDate = setMinAndMaxDateForDatePicker(maxYear: 0, minYear: 200).1
        
        var datePickerView: UIDatePicker!
        datePickerView  = UIDatePicker(frame: CGRect(x:0, y: 50, width: baseview.frame.width, height:baseview.frame.height - 50))
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.backgroundColor = UIColor.white
        datePickerView.tag = 5454
        datePickerView.maximumDate = maxDate
        datePickerView.minimumDate = minDate
        baseview.addSubview(datePickerView)
        
        if(txtDob.text!.count > 0)
        {
            let selectedDate = txtDob.text!
            let dateFormatter = DateFormatter()
            //  dateFormatter.dateFormat = "dd MMM yyyy"
            
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let dateObj = dateFormatter.date(from: selectedDate)
            datePickerView.setDate(dateObj!, animated: false)
        }
    }
    
    func setMinAndMaxDateForDatePicker(maxYear: Int,minYear: Int) -> (Date , Date)
    {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -minYear
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = maxYear
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        return( minDate,maxDate)
    }
    
    @objc func doneButtonActionFordatePicker()
    {
        if let baseViewTag = self.view.viewWithTag(668)
        {
            if let datePicker = self.view.viewWithTag(5454) as? UIDatePicker
            {
                let dateFormatter = DateFormatter()
                //  dateFormatter.dateFormat = "dd MMM yyyy"
                
                dateFormatter.dateFormat = "dd/MM/yyyy"
                txtDob.text = dateFormatter.string(from: datePicker.date)
                baseViewTag.removeFromSuperview()
            }
        }
    }
    
    @objc func cancelButtonActionFordatePicker()
    {
        if let baseViewTag = self.view.viewWithTag(668)
        {
            baseViewTag.removeFromSuperview()
        }
    }
    
    
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
            
            actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
                
                self.camera()
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
                
                self.photoLibrary()
                
            }))
            
        } else {
            
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
                
                self.photoLibrary()
                
            }))
            
        }
        
        actionSheet.addAction(UIAlertAction(title:"Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            
            let popup = UIPopoverController(contentViewController: actionSheet)
            
            popup.present(from: CGRect(), in: self.view!, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
            
        }else{
            
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
}


//MARK:- ImagePicker delegate
//MARK:-
extension MyProfileVC:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        imgUserProfile.image = chosenImage
        imageData = UIImageJPEGRepresentation(chosenImage, 1.0) as NSData!
        imageName = "user_image.jpg"
        
        dismiss(animated: true, completion: nil)
    }
}




extension MyProfileVC{
    
    func showCountryPicker(){
        self.view.endEditing(true)
        
        ActionSheetStringPicker.show(withTitle: "", rows: self.countryCodeArray as [AnyObject], initialSelection: 29, doneBlock: { (picker,selectedIndex, origin) -> Void in
            
            let select = selectedIndex
            print(select)
            let dic = self.arrayFromPlist.object(at: select) as? NSDictionary
            
            
            let countryCode = dic?.object(forKey: "country_dialing_code") as? String ?? ""
            
            let countryName = dic?.object(forKey: "country_name") as? String ?? ""
            
            self.txtCountry.text = "\(countryCode) - \(countryName)"
            
            print(countryCode)
          
            UserDefaults.standard.set(countryName, forKey: "CountryName")
            
            UserDefaults.standard.setValue(countryCode, forKey: "CountryCode")
            
            
        }, cancel: { (picker) -> Void in
            
        }, origin: self.view)
        
    }
    
    func loadPlistDataatLoadTime() {
        
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        let path = documentsDirectory.appendingPathComponent("countryList.plist")
        let fileManager = FileManager.default
        
        if(!fileManager.fileExists(atPath: path)) {
            
            if let bundlePath = Bundle.main.path(forResource: "countryList", ofType: "plist") {
                let rootArray = NSMutableArray(contentsOfFile: bundlePath)
                print("Bundle RecentSearch.plist file is --> \(String(describing: rootArray?.description))")
                do{
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                }
                catch _ {
                    print("Fail to copy")
                }
                print("copy")
            } else {
                print("RecentSearch.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print("RecentSearch.plist already exits at path.")
            
        }
        
        let rootarray = NSMutableArray(contentsOfFile: path)
        print("Loaded RecentSearch.plist file is --> \(String(describing: rootarray?.description))")
        let array = NSMutableArray(contentsOfFile: path)
        print(array)
        if let dict = array {
            
            
            let tempArray = array!
            self.arrayFromPlist = tempArray
            var i = 0
            for index in tempArray{
                
                let dic = tempArray.object(at: i) as? NSDictionary
                i = i+1
                let code = dic?.object(forKey: "country_dialing_code") as? String
                
                let trimSring:String = code!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                let countryName = dic?.object(forKey: "country_name") as? String
                let codeString = trimSring+" "+countryName!
                
                self.countryCodeArray.add(codeString)
                
            }
            
        } else {
            print("WARNING: Couldn't create dictionary from RecentSearch.plist! Default values will be used!")
        }
    }
    
}



extension MyProfileVC{
    
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
                            
                            self.userDataDict = response
                            
                            self.updateElement()
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
    
    
    func apiCallForEditProfile(){
        
        var sendName = ""
        
        if self.globalNameStatus == "true"{
            
            sendName = txtUserName.text!
        }
        else{
            
            sendName = txtFullName.text!
        }
        
        
        let param:[String:String] = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","name":sendName,"gender":txtGender.text!,"dob":txtDob.text!,"country":UserDefaults.standard.value(forKey: "CountryName") as? String ?? "","email":txtEmail.text!,"appLanguage":txtAppLanguage.text!,"speakLanguage":txtSpeakLanguage.text!]
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithProfileData(imageData: imageData, fileName: "UserProfile.png", imageparm: "profilePic", getUrlString: App.URLs.apiCallForUpdateProfile as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
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


