//
//  BecomeProfessionalPersonVC.swift
//  Joker
//
//  Created by abc on 24/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit
import DropDown
import Photos


class BecomeProfessionalPersonVC: UIViewController {

    
    @IBOutlet weak var lblUploadIdOne: UILabel!
    
    @IBOutlet weak var lblUploadId2: UILabel!
    
    @IBOutlet weak var txtview: UITextView!
    
    @IBOutlet weak var btnIndustry: UIButton!
    
    @IBOutlet weak var txtIndustry: UITextField!
    
    @IBOutlet weak var btnSection: UIButton!
    
    @IBOutlet weak var txtSection: UITextField!
    
    @IBOutlet weak var btnProfessional: UIButton!
    
    @IBOutlet weak var txtProfessional: UITextField!
    
    @IBOutlet weak var txtProfessionalTapPlumber: UITextField!
    
    @IBOutlet weak var lblUploadProfessionalId1: UILabel!
    
    @IBOutlet weak var btnOfficialGovId: UIButton!
    
    @IBOutlet weak var txtOfficialGovId: UITextField!
    
    @IBOutlet weak var lblProfessionalUploadId2: UILabel!
    
    @IBOutlet weak var txtBankAccount: UITextField!
    
    @IBOutlet weak var txtEmergencyContact: UITextField!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
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
    
    var industryArr = ["Chemical","Automobile","IT"]
    var sectionArr = ["Dummy Section 1","Dummy Section 2","Dummy Section 3"]
    var professionalArr = ["Chemical Professional","Automobile Professional","IT Professional"]
    var officialGovIDArr = ["Passport","Driving License","Adhar Card"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtview.text = "Write something about"
        txtview.delegate = self
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
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
                
                self.txtOfficialGovId.text = "\(item)"
            }
            
        }
        
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_submitBtn(_ sender: Any) {
        
        checkValidation()
       
    }
    
    @IBAction func tap_uploadIdOne(_ sender: Any) {
        
        imageUploadTag = 0
        showImagePicker()
    }
    
    @IBAction func tap_uploadId2(_ sender: Any) {
        
        imageUploadTag = 1
        showImagePicker()
    }
    
    
    @IBAction func tap_uploadProfileBtn(_ sender: Any) {
        
        imageUploadTag = 4
        showImagePicker()
    }
    
    @IBAction func tap_industryBtn(_ sender: Any) {
        
        dropdownTag = 0
        dropDown.dataSource = industryArr
        dropDown.anchorView = btnIndustry
        dropDown.show()
    }
    
    @IBAction func tap_sectionBtn(_ sender: Any) {
        
        dropdownTag = 1
        dropDown.dataSource = sectionArr
        dropDown.anchorView = btnSection
        dropDown.show()
        
    }
    
    @IBAction func tap_professionalBtn(_ sender: Any) {
        
        dropdownTag = 2
        dropDown.dataSource = professionalArr
        dropDown.anchorView = btnProfessional
        dropDown.show()
    }
    
    @IBAction func tap_professionalIdOne(_ sender: Any) {
        
        imageUploadTag = 2
        showImagePicker()
    }
    
    @IBAction func tap_officialGovId(_ sender: Any) {
        
        dropdownTag = 3
        dropDown.dataSource = officialGovIDArr
        dropDown.anchorView = btnOfficialGovId
        dropDown.show()
    }
    
    @IBAction func tap_professionalId2(_ sender: Any) {
        
        imageUploadTag = 3
        showImagePicker()
    }
    
    
    
}

extension BecomeProfessionalPersonVC:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if txtview.text == "Write something about"{
            
            txtview.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txtview.text == ""{
            
            txtview.text = "Write something about"
        }
    }
}

extension BecomeProfessionalPersonVC{
    
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

extension BecomeProfessionalPersonVC:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        var imageName = ""
        if let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
            let asset = result.firstObject
            // print(asset?.value(forKey: "filename"))
            imageName = "\(asset?.value(forKey: "filename") ?? "")"
            
        }
        
        if self.imageUploadTag == 0{
            
            uploadIdOneData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
            
            lblUploadIdOne.text = imageName
            
            if lblUploadIdOne.text == ""{
                
                lblUploadIdOne.text = "ID - 1 attached".localized()
            }
        }
        else if self.imageUploadTag == 1{
            
            uploadIdTwoData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
            
            lblUploadId2.text = imageName
            
            if lblUploadId2.text == ""{
                
                lblUploadId2.text = "ID - 2 attached".localized()
            }
        }
        else if self.imageUploadTag == 2{
            
            professionalIdOneData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
            
            lblUploadProfessionalId1.text = imageName
            
            if lblUploadProfessionalId1.text == ""{
                
                lblUploadProfessionalId1.text = "ID - 1 attached".localized()
            }
        }
        else if self.imageUploadTag == 3{
            
            professionalIdTwoData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
            
            lblProfessionalUploadId2.text = imageName
            
            if lblProfessionalUploadId2.text == ""{
                
                lblProfessionalUploadId2.text = "ID - 2 attached".localized()
            }
        }
        else if self.imageUploadTag == 4{
            
            imageData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
            imgProfile.image = chosenImage
            
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension BecomeProfessionalPersonVC{
    
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
        else if txtview.text == "" || txtview.text == "Write something about"{
            
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
//            mess = "Please upload id 1"
//        }
//        else if txtOfficialGovId.text == ""{
//
//            mess = "Please enter official gov. id"
//        }
//        else if professionalIdTwoData.length <= 0{
//
//            mess = "Please upload id 2"
//        }
//        else if txtBankAccount.text == ""{
//
//            mess = "Please enter bank account"
//        }
        else if txtEmergencyContact.text == ""{

            mess = "Please enter emergency contact"
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
            
            let param = ["aboutUs":txtview.text!,"officialGovntId":txtOfficialGovId.text!,"industry":txtIndustry.text!,"section":txtSection.text!,"professional":txtProfessional.text!,"bankAC":txtBankAccount.text!,"emergencyContact":txtEmergencyContact.text!,"userType":"ProfessionalWorker","userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","professionalTab":txtProfessionalTapPlumber.text!]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithFiveFile(imageData: imageData, uploadId1data: uploadIdOneData, uploadId2Data: uploadIdTwoData, UploadId3data: professionalIdOneData, uploadId4Data: professionalIdTwoData, profileParam: "profilePic", uploadId1Param: "id1", uploadId2Param: "id2", uploadId3Param: "id3", uploadId4Param: "id4", getUrlString: App.URLs.apiCallForBecomeProfessionalPerson as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                      //  CommonClass.sharedInstance.callNativeAlert(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", controller: self)
                        
                        let alertController = UIAlertController(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            
                            for controller in self.navigationController!.viewControllers as Array {
                                
                                if controller is MoreVC{
                                    
                                self.navigationController!.popToViewController(controller, animated: true)
                                    
                                    break
                                }
                            }
                            
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

extension BecomeProfessionalPersonVC{
    
    
}

