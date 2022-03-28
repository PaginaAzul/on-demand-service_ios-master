//
//  SignUpVC.swift
//  Joker
//
//  Created by Apple on 18/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import DropDown
import ActionSheetPicker_3_0

class SignUpVC: UIViewController {

    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
   
    
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var fullNameTxtField: UITextField!
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var selectYourBirthTxtField: UITextField!
    @IBOutlet weak var selectAppLanguageTxtField: UITextField!
    @IBOutlet weak var selectcountryTxtField: UITextField!
    @IBOutlet weak var emailAddTxtField: UITextField!
    @IBOutlet weak var selectSpeakLangTxtField: UITextField!
    
    @IBOutlet weak var btnFullNameRadio: UIButton!
    
    @IBOutlet weak var btnFullName: UIButton!
    
    @IBOutlet weak var btnUserNameRadio: UIButton!
    
    @IBOutlet weak var btnUserName: UIButton!
    
    @IBOutlet weak var btnMale: UIButton!
    
    @IBOutlet weak var btnMaleRadio: UIButton!
    
    @IBOutlet weak var btnFemale: UIButton!
    
    @IBOutlet weak var btnFemaleRadio: UIButton!
    
    @IBOutlet weak var viewSpeakLanguage: UIView!
    
    @IBOutlet weak var viewAppLanguage: UIView!
    
    @IBOutlet weak var lblNav: UILabel!
    
    @IBOutlet weak var lblSelectName: UILabel!
    
    
    
    var maleSelection = true
    var userNameSelection = true
    
    let validation:Validation = Validation.validationManager() as! Validation
    
    var appLangArr = ["English".localized(),"Portuguese".localized()]
    var speaklangArr = ["English","Portuguese"]
    var countryCodeArray = NSMutableArray()
    var arrayFromPlist = NSMutableArray()
    var countryCodeCheck = false
    let dropDown = DropDown()
    
    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    var imageName = ""
    
    var dropdownTag = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting dummy due to removed the field and want no change in API
        selectYourBirthTxtField.text = "12/08/1993"
        intialise()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            if self.dropdownTag == 0{
                
                self.selectAppLanguageTxtField.text = "\(item)"
            }
            else{
                
                self.selectSpeakLangTxtField.text = "\(item)"
            }
            
        }
        
        localization()
    }
    
    
    func localization(){
        
        lblNav.text = "Sign Up".localized()
        btnFullName.setTitle("Full Name".localized(), for: .normal)
        btnUserName.setTitle("User Name".localized(), for: .normal)
        lblSelectName.text = "Select Name".localized()
        userNameTxtField.placeholder = "Enter Name".localized()
        emailAddTxtField.placeholder = "Email Address".localized()
        selectSpeakLangTxtField.placeholder = "Select Speak Language".localized()
        selectAppLanguageTxtField.placeholder = "Select App Language".localized()
        signUpBtn.setTitle("Sign Up".localized(), for: .normal)
    }
    
    
    override func viewDidAppear(_ animated: Bool){
        
        super.viewDidAppear(true)
        loadPlistDataatLoadTime()
        
        if countryCodeCheck == false{
            
            if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String
            {
                for i in 0 ..< self.arrayFromPlist.count
                {
                    if let dic = self.arrayFromPlist.object(at: i) as? NSDictionary
                    {
                        if countryCode == dic.object(forKey: "country_code") as! String
                        {
                            
                            let countryName = dic.object(forKey: "country_name") as? String ?? ""
                            
                            let plusCCode = dic.object(forKey: "country_dialing_code") as? String ?? ""
                            
                            selectcountryTxtField.text = "\(plusCCode) - \(countryName)"
                            
                            print(countryCode)
                            //US,,IN,,CA
                            
                           // UserDefaults.standard.set("\(countryCode)", forKey: "CountryName")
                            
                            UserDefaults.standard.setValue(plusCCode, forKey: "CountryCode")
                            
                            UserDefaults.standard.set(countryName, forKey: "CountryName")
                        }
                    }
                }
            }
            
            countryCodeCheck = true
        }
        
    }

    @IBAction func tap_userImgBtn(_ sender: Any) {
        
        showImagePicker()
    }
  
    @IBAction func tap_SignUpBtn(_ sender: UIButton) {
        
        UserDefaults.standard.set("Signup", forKey: "AuthenticationPurpuse")
//
//        let vc = ScreenManager.getOtpVerifyVC()
//
//        vc.navObj = self
//
//        self.present(vc, animated: true, completion: nil)
        
//        let vc = ScreenManager.getSignupWithPhoneVC()
//        self.navigationController?.pushViewController(vc, animated: true)
        
        checkValidation()
        
    }
    
    @IBAction func tap_BackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tap_femaleRadioBtn(_ sender: Any) {
        
        btnFemaleRadio.setImage(UIImage(named: "male"), for: .normal)
        btnMaleRadio.setImage(UIImage(named: "female"), for: .normal)
        maleSelection = false
    }
    
    @IBAction func tap_femaleBtn(_ sender: Any) {
        
        btnFemaleRadio.setImage(UIImage(named: "male"), for: .normal)
        btnMaleRadio.setImage(UIImage(named: "female"), for: .normal)
        maleSelection = false
    }
    
    @IBAction func tap_maleRadioBtn(_ sender: Any) {
        
        btnFemaleRadio.setImage(UIImage(named: "female"), for: .normal)
        btnMaleRadio.setImage(UIImage(named: "male"), for: .normal)
        maleSelection = true
    }
    
    @IBAction func tap_maleBtn(_ sender: Any) {
        
        btnFemaleRadio.setImage(UIImage(named: "female"), for: .normal)
        btnMaleRadio.setImage(UIImage(named: "male"), for: .normal)
        maleSelection = true
    }
    
    @IBAction func tap_btnFullNameRadio(_ sender: Any) {
        
        userNameSelection = false
        btnUserNameRadio.setImage(UIImage(named: "female"), for: .normal)
        btnFullNameRadio.setImage(UIImage(named: "male"), for: .normal)
        
    }
    
    @IBAction func tap_fullName(_ sender: Any) {
        
        userNameSelection = false
        btnUserNameRadio.setImage(UIImage(named: "female"), for: .normal)
        btnFullNameRadio.setImage(UIImage(named: "male"), for: .normal)
    }
    
    @IBAction func tap_userNameRadioBtn(_ sender: Any) {
        
        userNameSelection = true
        btnUserNameRadio.setImage(UIImage(named: "male"), for: .normal)
        btnFullNameRadio.setImage(UIImage(named: "female"), for: .normal)
    }
    
    @IBAction func tap_userNameBtn(_ sender: Any) {
        
        userNameSelection = true
        btnUserNameRadio.setImage(UIImage(named: "male"), for: .normal)
        btnFullNameRadio.setImage(UIImage(named: "female"), for: .normal)
    }
    
    
    @IBAction func tap_dateOfBirthBtn(_ sender: Any) {
        
        openDatePicker()
    }
    
    @IBAction func tap_selectCountryBtn(_ sender: Any) {
        
        showCountryPicker()
    }
    
    @IBAction func tap_selectApplanguageBtn(_ sender: Any) {
        
        dropdownTag = 0
        dropDown.anchorView = viewAppLanguage
        dropDown.dataSource = appLangArr
        dropDown.show()
        
    }
    
    @IBAction func tap_selectSpeakLanguagebtn(_ sender: Any) {
        
        dropdownTag = 1
        dropDown.anchorView = viewSpeakLanguage
        dropDown.dataSource = speaklangArr
        dropDown.show()
        
    }
 
}



//MARK:- Custom Method
//MARK:-
extension SignUpVC{
    
    func showCountryPicker(){
        self.view.endEditing(true)
        
        ActionSheetStringPicker.show(withTitle: "", rows: self.countryCodeArray as [AnyObject], initialSelection: 29, doneBlock: { (picker,selectedIndex, origin) -> Void in
            
            let select = selectedIndex
            print(select)
            let dic = self.arrayFromPlist.object(at: select) as? NSDictionary
            
            
            let countryCode = dic?.object(forKey: "country_dialing_code") as? String ?? ""
            
           // self.countryCodeTxtFld.text = dic?.object(forKey: "country_dialing_code") as? String
          //  let countryCode = dic?.object(forKey: "country_code") as? String ?? ""
            
            let countryName = dic?.object(forKey: "country_name") as? String ?? ""
            
            self.selectcountryTxtField.text = "\(countryCode) - \(countryName)"
            
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



extension SignUpVC:calendarDateDelegate{
    
    func calendarDatePicker(date: String) {
        
        print(date)
    }
}


extension SignUpVC{
    
    func intialise()
    {
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        self.fullNameTxtField.placeHolderColor = UIColor(red: 30.0/255, green: 30.0/255, blue: 30.0/255, alpha: 1.0)
        self.emailAddTxtField.placeHolderColor = UIColor(red: 30.0/255, green: 30.0/255, blue: 30.0/255, alpha: 1.0)

        self.selectAppLanguageTxtField.placeHolderColor = UIColor(red: 30.0/255, green: 30.0/255, blue: 30.0/255, alpha: 1.0)
        self.selectcountryTxtField.placeHolderColor = UIColor(red: 30.0/255, green: 30.0/255, blue: 30.0/255, alpha: 1.0)
        self.userNameTxtField.placeHolderColor = UIColor(red: 30.0/255, green: 30.0/255, blue: 30.0/255, alpha: 1.0)
        self.selectSpeakLangTxtField.placeHolderColor = UIColor(red: 30.0/255, green: 30.0/255, blue: 30.0/255, alpha: 1.0)
        self.selectYourBirthTxtField.placeHolderColor = UIColor(red: 30.0/255, green: 30.0/255, blue: 30.0/255, alpha: 1.0)
        
        
        btnFemaleRadio.setImage(UIImage(named: "female"), for: .normal)
        btnMaleRadio.setImage(UIImage(named: "male"), for: .normal)
        btnUserNameRadio.setImage(UIImage(named: "male"), for: .normal)
        btnFullNameRadio.setImage(UIImage(named: "female"), for: .normal)
        
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
        
        if(selectYourBirthTxtField.text!.count > 0)
        {
            let selectedDate = selectYourBirthTxtField.text!
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
                selectYourBirthTxtField.text = dateFormatter.string(from: datePicker.date)
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
    
}


//MARK:- ImagePicker delegate
//MARK:-
extension SignUpVC:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        userProfileImg.image = chosenImage
        imageData = UIImageJPEGRepresentation(chosenImage, 1.0) as NSData!
        imageName = "user_image.jpg"
        
        dismiss(animated: true, completion: nil)
    }
}



extension SignUpVC:DismissAndPushDelegate{
    
    func getControllerStatus(status: String) {
        
        if status == "Yes"{
            
            let vc = ScreenManager.getPopupVC()
            
            self.present(vc, animated: true, completion: nil)
        }
    }
 
}

extension SignUpVC{
    
    func checkValidation(){
        
        var mess = ""
       
        if userNameTxtField.text == ""{
            
            mess = "Please enter name"
        }
//        else if selectYourBirthTxtField.text == ""{
//
//            mess = "Please enter your date of birth"
//        }
        else if emailAddTxtField.text == ""{
            
            mess = "Please enter email"
        }
        else if !validation.validateEmail(emailAddTxtField.text){
            
            mess = "Please enter valid email address"
        }
        else if selectcountryTxtField.text == ""{
            
            mess = "Please select your country"
        }
        else if selectAppLanguageTxtField.text == ""{
            
            mess = "Please select the app language"
        }
//        else if selectSpeakLangTxtField.text == ""{
//
//            mess = "Please select the speak language"
//        }
        
        if mess == ""{
            
            var nameType = ""
            var gender = ""
            let signupDataDict = NSMutableDictionary()
            signupDataDict.removeAllObjects()
            
            if userNameSelection == true{
                
                nameType = "Username"
            }
            else{
                
                nameType = "Fullname"
            }
            
            if maleSelection == true{
                
                gender = "Male"
            }
            else{
                
                gender = "Female"
            }
            
            signupDataDict.setValue(imageData, forKey: "UserImgData")
            signupDataDict.setValue(userNameSelection, forKey: "NameType")
            signupDataDict.setValue(gender, forKey: "Gender")
            signupDataDict.setValue(userNameTxtField.text!, forKey: "UserName")
            signupDataDict.setValue(selectYourBirthTxtField.text!, forKey: "DOB")
            signupDataDict.setValue(emailAddTxtField.text!, forKey: "EmailAddress")
            
            
            var language = ""
            if selectAppLanguageTxtField.text! == "English".localized(){
                language = "English"
            }else{
                language = "Portuguese"
            }
            
            signupDataDict.setValue(language, forKey: "AppLanguage")
            signupDataDict.setValue(selectSpeakLangTxtField.text!, forKey: "SpeakLanguage")
            
          //  UserDefaults.standard.setValue(signupDataDict, forKey: "SignupData")
            
            let data = NSKeyedArchiver.archivedData(withRootObject: signupDataDict)
            UserDefaults.standard.set(data, forKey: "SignupData")
            
            
            redirectToAnotherController()
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
        
    }
    
    
    func redirectToAnotherController(){
        
        let vc = ScreenManager.getSignupWithPhoneVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}



