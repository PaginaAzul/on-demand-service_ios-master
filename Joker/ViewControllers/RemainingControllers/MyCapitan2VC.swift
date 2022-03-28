//
//  MyCapitan2VC.swift
//  Joker
//
//  Created by abc on 24/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit
import DropDown
import Photos


class MyCapitan2VC: UIViewController {

    
    @IBOutlet weak var lblId1: UILabel!
    
    @IBOutlet weak var lblId2: UILabel!
    
    @IBOutlet weak var imgId1: UIImageView!
    
    @IBOutlet weak var imgId2: UIImageView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var btnIndustry: UIButton!
    
    @IBOutlet weak var txtIndustry: UITextField!
    
    @IBOutlet weak var lblUserId: UILabel!
    
    @IBOutlet weak var btnSection: UIButton!
    
    @IBOutlet weak var txtSection: UITextField!
    
    @IBOutlet weak var btnProfessional: UIButton!
    
    @IBOutlet weak var txtProfessional: UITextField!
    
    @IBOutlet weak var txtProfessionalTapPlumber: UITextField!
    
    @IBOutlet weak var lblUploadCertificate: UILabel!
    
    @IBOutlet weak var imgCertificate: UIImageView!
    
    @IBOutlet weak var txtVehicleLicense: UITextField!
    
    @IBOutlet weak var btnVehicleLicense: UIButton!
    
    @IBOutlet weak var lblUploadvehicleLicense: UILabel!
    
    @IBOutlet weak var imgvehicleLicense: UIImageView!
    
    @IBOutlet weak var txtBankAccount: UITextField!
    
    @IBOutlet weak var txtEmergencyPhone: UITextField!
    
    
    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    var imageName = ""
    
    var uploadIdOneData = NSData()
    var uploadIdTwoData = NSData()
    var professionalIdOneData = NSData()
    var professionalIdTwoData = NSData()
    
    var imageUploadTag = 0
    
    var dropdownTag = 0
    let dropDown = DropDown()
    let connection = webservices()
    
    var industryArr = ["Furnitures","Paint","Other"]
    var sectionArr = ["Architects","Engineers","Carpentry","Plumbing","Other"]
    var professionalArr = ["Education","Electronics and telecom","Entertainment and media","Other"]
    var officialGovIDArr = ["Passport","Driving License","Adhar Card"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtView.text = "Write something about"
        txtView.delegate = self
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        getProfessionalPersonDetail()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            if self.dropdownTag == 0{
                
                self.txtIndustry.text = "\(item)"
            }
            else if self.dropdownTag == 1{
                
                self.txtSection.text = "\(item)"
            }
            else if self.dropdownTag == 2{
                
                self.txtProfessional.text = "\(item)"
            }
            else if self.dropdownTag == 3{
                
                self.txtVehicleLicense.text = "\(item)"
            }
            
        }
        
    }
    
    
    @IBAction func tap_contactUsToAddCategory(_ sender: Any) {
        
        let vc = ScreenManager.getCancellationVC()
        vc.controllerPurpuse = "ContactAdmin"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    @IBAction func tap_vehicleLicensebtn(_ sender: Any) {
        
        dropdownTag = 3
        dropDown.dataSource = officialGovIDArr
        dropDown.anchorView = btnVehicleLicense
        dropDown.show()
    }
    
    @IBAction func tap_uploadCertificate(_ sender: Any) {
        
        imageUploadTag = 2
        showImagePicker()
    }
    
    @IBAction func tap_btnprofessional(_ sender: Any) {
        
        dropdownTag = 2
        dropDown.dataSource = professionalArr
        dropDown.anchorView = btnProfessional
        dropDown.show()
    }
    
    @IBAction func tap_sectionBtn(_ sender: Any) {
        
        dropdownTag = 1
        dropDown.dataSource = sectionArr
        dropDown.anchorView = btnSection
        dropDown.show()
    }
    
    @IBAction func tap_industryBtn(_ sender: Any) {
        
        dropdownTag = 0
        dropDown.dataSource = industryArr
        dropDown.anchorView = btnIndustry
        dropDown.show()
    }
    
    @IBAction func tap_uploadImgBtn(_ sender: Any) {
        
        imageUploadTag = 4
        showImagePicker()
    }
    
    @IBAction func tap_uploadId2(_ sender: Any) {
        
        imageUploadTag = 1
        showImagePicker()
    }
    
    @IBAction func tap_uploadId1(_ sender: Any) {
        
        imageUploadTag = 0
        showImagePicker()
    }
    
    @IBAction func tap_uploadVehicleLicense(_ sender: Any) {
        
        imageUploadTag = 3
        showImagePicker()
    }
    
    @IBAction func tap_updateBtn(_ sender: Any) {
        
        checkValidation()
    }
    
    
}


extension MyCapitan2VC:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if txtView.text == "Write something about"{
            
            txtView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txtView.text == ""{
            
            txtView.text = "Write something about"
        }
    }
}

extension MyCapitan2VC{
    
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
            
        }else {
            
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

extension MyCapitan2VC:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        
        if self.imageUploadTag == 0{
            
            uploadIdOneData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
            
            imgId1.image = chosenImage
            
        }
        else if self.imageUploadTag == 1{
            
            uploadIdTwoData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
            
            imgId2.image = chosenImage
        }
        else if self.imageUploadTag == 2{
            
            //certificate
            
            professionalIdOneData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
            
            imgCertificate.image = chosenImage
           
        }
        else if self.imageUploadTag == 3{
            
            //vehicle license
            
            professionalIdTwoData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
            
            imgvehicleLicense.image = chosenImage
            
        }
        else if self.imageUploadTag == 4{
            
            imageData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
            imgProfile.image = chosenImage
            
        }
        
        dismiss(animated: true, completion: nil)
    }
}


//for getting data
extension MyCapitan2VC{
    
    func getProfessionalPersonDetail(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.getBecomeProfessionalDetails as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        if let data = receivedData.object(forKey: "Data") as? NSDictionary{
                            
                            if data.count != 0{
                                
                                self.updateElement(userData: data)
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
    
    
    func updateElement(userData:NSDictionary){
        
        self.txtSection.text = userData.object(forKey: "section") as? String ?? ""
        self.txtIndustry.text = userData.object(forKey: "industry") as? String ?? ""
        self.txtProfessional.text = userData.object(forKey: "professional") as? String ?? ""
        self.txtView.text = userData.object(forKey: "professionalAboutUs") as? String ?? ""
        self.txtBankAccount.text = userData.object(forKey: "professionalBankAc") as? String ?? ""
        
        self.txtEmergencyPhone.text = userData.object(forKey: "professionalEmergencyContact") as? String ?? ""
        
        self.txtVehicleLicense.text = userData.object(forKey: "officialGovntId") as? String ?? ""
        
        self.txtProfessionalTapPlumber.text = userData.object(forKey: "professionalTab") as? String ?? ""
        
        self.lblUserId.text = "id : \(userData.object(forKey: "professiona1PersonUniqueId") as? String ?? "")"
        
        let id1Str = userData.object(forKey: "professionalId1") as? String ?? ""
        let id2Str = userData.object(forKey: "professionalId2") as? String ?? ""
        let id3Str = userData.object(forKey: "profession1Id3") as? String ?? ""
        let id4Str = userData.object(forKey: "profession1Id4") as? String ?? ""
        
        let imgStr = userData.object(forKey: "professionalProfie") as? String ?? ""
        
        //**********
        let id1Url = URL(string: id1Str)
        
        if id1Url != nil{
            
            imgId1.setImageWith(id1Url!, placeholderImage: UIImage(named:"licenseImg"))
            
            if let data = try? Data(contentsOf: id1Url!)
            {
                self.uploadIdOneData = data as NSData
            }
            
        }
        
        
        //**********
        let id2Url = URL(string: id2Str)
        
        if id2Url != nil{
            
            imgId2.setImageWith(id2Url!, placeholderImage: UIImage(named:"licenseImg"))
            
            DispatchQueue.global(qos: .background).async {
                
                if let data = try? Data(contentsOf: id1Url!)
                {
                    self.uploadIdTwoData = data as NSData
                }
            }
            
        }
        
        //**********
        let imgUrl = URL(string: imgStr)
        
        if imgUrl != nil{
            
            imgProfile.setImageWith(imgUrl!, placeholderImage: UIImage(named:"userPlaceholder"))
            
            DispatchQueue.global(qos: .background).async {
                
                if let data = try? Data(contentsOf: id1Url!)
                {
                    self.imageData = data as NSData
                }
            }
            
        }
        
        
        //**********
        let certiUrl = URL(string: id3Str)
        
        if certiUrl != nil{
            
            imgCertificate.setImageWith(certiUrl!, placeholderImage: UIImage(named:"certificateImg"))
            
            DispatchQueue.global(qos: .background).async {
                
                if let data = try? Data(contentsOf: id1Url!)
                {
                    self.professionalIdOneData = data as NSData
                }
            }
            
        }
        
        
        //**********
        let licenseUrl = URL(string: id4Str)
        
        if licenseUrl != nil{
            
            imgvehicleLicense.setImageWith(licenseUrl!, placeholderImage: UIImage(named:"licenseImg"))
            
            DispatchQueue.global(qos: .background).async {
                
                if let data = try? Data(contentsOf: id1Url!)
                {
                    self.professionalIdTwoData = data as NSData
                }
            }
            
        }
        
    }
    
}


//for submit request
extension MyCapitan2VC{
    
    func checkValidation(){
        
        var mess = ""
        
        if uploadIdOneData.length <= 0{
            
            mess = "Please upload id 1"
        }
        else if uploadIdTwoData.length <= 0{
            
            mess = "Please upload id 2"
        }
        else if imageData.length <= 0{
            
            mess = "Please update profile picture"
        }
        else if txtView.text == "" || txtView.text == "Write something about"{
            
            mess = "Please write something for your profile"
        }
        else if txtIndustry.text == ""{
            
            mess = "Please select the industry"
        }
        else if txtSection.text == ""{
            
            mess = "Please select the section"
        }
        else if txtProfessional.text == ""{
            
            mess = "Please select professional"
        }
//        else if txtProfessionalTapPlumber.text == ""{
//
//            mess = "Please enter professional tap plumber"
//        }
//        else if professionalIdOneData.length <= 0{
//
//            mess = "Please upload certificate"
//        }
//        else if txtVehicleLicense.text == ""{
//
//            mess = "Please enter vehicle license"
//        }
//        else if professionalIdTwoData.length <= 0{
//
//            mess = "Please upload vehicle license"
//        }
//        else if txtBankAccount.text == ""{
//
//            mess = "Please enter bank account"
//        }
        else if txtEmergencyPhone.text == ""{

            mess = "Please enter emergency contact number"
        }
        else{
            
            mess = ""
        }
        
        if mess == ""{
            
            self.apiCallForBecomeProfessionalPerson()
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
        
    }
    
    
    func apiCallForBecomeProfessionalPerson(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["aboutUs":txtView.text!,"officialGovntId":txtVehicleLicense.text!,"industry":txtIndustry.text!,"section":txtSection.text!,"professional":txtProfessional.text!,"bankAC":txtBankAccount.text!,"emergencyContact":txtEmergencyPhone.text!,"userType":"ProfessionalWorker","userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithFiveFile(imageData: imageData, uploadId1data: uploadIdOneData, uploadId2Data: uploadIdTwoData, UploadId3data: professionalIdOneData, uploadId4Data: professionalIdTwoData, profileParam: "profilePic", uploadId1Param: "id1", uploadId2Param: "id2", uploadId3Param: "id3", uploadId4Param: "id4", getUrlString: App.URLs.apiCallForUpdateProfessionalPersonProfile as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
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
