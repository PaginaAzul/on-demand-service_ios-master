//
//  MyCaptionProfileVC.swift
//  Joker
//
//  Created by abc on 23/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit
import DropDown
import Photos

class MyCaptionProfileVC: UIViewController {

    @IBOutlet weak var lblId1: UILabel!
    
    @IBOutlet weak var imgId1: UIImageView!
    
    @IBOutlet weak var lblId2: UILabel!
    
    @IBOutlet weak var imgId2: UIImageView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblUserId: UILabel!
    
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var txtVehicleType: UITextField!
    
    @IBOutlet weak var txtVehicleNumber: UITextField!
    
    @IBOutlet weak var lblUploadVehicleLicense: UILabel!
    
    @IBOutlet weak var imgLicense: UIImageView!
    
    @IBOutlet weak var txtInsuranceNumber: UITextField!
    
    @IBOutlet weak var lblUploadInsurance: UILabel!
    
    @IBOutlet weak var imgInsurance: UIImageView!
    
    @IBOutlet weak var txtBankAccount: UITextField!
    
    @IBOutlet weak var txtEmergencyPhone: UITextField!
    
    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    var imageName = ""
    
    var uploadIdOneData = NSData()
    var uploadIdTwoData = NSData()
    var vehicleLicenseData = NSData()
    var insuranceData = NSData()
    
    var imageUploadTag = 0
    var vehicleTypeArr = ["FourWheeler","TwoWheller"]
    
    let dropDown = DropDown()
    
    
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtView.text = "Write something about"
        txtView.delegate = self
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        getDeliveryPersonDetail()
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            self.txtVehicleType.text = "\(item)"
            
        }
        
    }
    
    
    @IBAction func tap_uploadInsurance(_ sender: Any) {
        
        self.imageUploadTag = 3
        showImagePicker()
    }
    
    @IBAction func tap_uploadVehicleLicense(_ sender: Any) {
        
        self.imageUploadTag = 2
        showImagePicker()
    }
    
    @IBAction func tap_uploadProfile(_ sender: Any) {
        
        self.imageUploadTag = 4
        showImagePicker()
    }
    
    @IBAction func tap_vehicleType(_ sender: Any) {
        
        dropDown.dataSource = vehicleTypeArr
        dropDown.anchorView = txtVehicleType
        dropDown.show()
    }
    
    @IBAction func tap_uploadId2(_ sender: Any) {
        
        self.imageUploadTag = 1
        showImagePicker()
    }
    
    @IBAction func tap_uploadId1(_ sender: Any) {
        
        self.imageUploadTag = 0
        showImagePicker()
        
    }
    
    @IBAction func tap_updateBtn(_ sender: Any) {
        
        checkValidation()
    }

}

extension MyCaptionProfileVC:UITextViewDelegate{
    
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

extension MyCaptionProfileVC{
    
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

extension MyCaptionProfileVC:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    
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
            
            vehicleLicenseData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
            
            imgLicense.image = chosenImage
            
        }
        else if self.imageUploadTag == 3{
            
            insuranceData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
            
            imgInsurance.image = chosenImage
          
        }
        else if self.imageUploadTag == 4{
            
            imageData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
            imgProfile.image = chosenImage
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}




//for request submit after edit
extension MyCaptionProfileVC{
    
    func checkValidation(){
        
        var mess = ""
        
        if uploadIdOneData.length <= 0{
            
            mess = "Please upload id 1"
        }
        else if uploadIdTwoData.length <= 0{
            
            mess = "Please upload id 2"
        }
        else if imageData.length <= 0{
            
            mess = "Please upload profile image"
        }
        else if txtView.text == "" || txtView.text == "Write something about"{
            
            mess = "Please write something about profile"
        }
        else if txtVehicleType.text == ""{

            mess = "Please select your vehicle type"
        }
//        else if txtVehicleNumber.text == ""{
//
//            mess = "Please enter vehicle number"
//        }
//        else if vehicleLicenseData.length <= 0{
//
//            mess = "Please upload vehicle license"
//        }
//        else if txtInsuranceNumber.text == ""{
//
//            mess = "Please enter insurance number"
//        }
//        else if insuranceData.length <= 0{
//
//            mess = "Please upload insurance"
//        }
//        else if txtBankAccount.text == ""{
//
//            mess = "Please enter bank account/IBAN"
//        }
        else if txtEmergencyPhone.text == ""{

            mess = "Please enter emergency contact number"
        }
        else{
            
            mess = ""
        }
        
        if mess == ""{
            
            self.apiCallForBecomeDeliveryPerson()
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
    }
    
    
    func apiCallForBecomeDeliveryPerson(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["aboutUs":txtView.text!,"vehicleNumber":txtVehicleNumber.text!,"vehicleType":txtVehicleType.text!,"insuranceNumber":txtInsuranceNumber.text!,"bankAC":txtBankAccount.text!,"emergencyContact":txtEmergencyPhone.text!,"userType":"DeliveryPersion","userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
            
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithFiveFile(imageData: imageData, uploadId1data: uploadIdOneData, uploadId2Data: uploadIdTwoData, UploadId3data: vehicleLicenseData, uploadId4Data: insuranceData, profileParam: "profilePic", uploadId1Param: "id1", uploadId2Param: "id2", uploadId3Param: "vehicleLicense", uploadId4Param: "insurance", getUrlString: App.URLs.apiCallForUpdateDeliveryPersonProfile as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
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


//for getting data
extension MyCaptionProfileVC{
    
    func getDeliveryPersonDetail(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.getBecomeDeliveryDetails as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
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
        
        let id1Str = userData.object(forKey: "deliverPId1") as? String ?? ""
        let id2Str = userData.object(forKey: "deliveryPId2") as? String ?? ""
        let imgStr = userData.object(forKey: "deliveryPProfilePic") as? String ?? ""
        let uploadedInsurance = userData.object(forKey: "uploadedInsurance") as? String ?? ""
        let vehicleLicenseStr = userData.object(forKey: "vehicleLicense") as? String ?? ""
        
        
        self.txtView.text = userData.object(forKey: "deliveryPAboutUs") as? String ?? ""
        self.txtBankAccount.text = userData.object(forKey: "deliveryPBankAC") as? String ?? ""
        self.txtEmergencyPhone.text = userData.object(forKey: "deliveryPEmergencyContact") as? String ?? ""
        
        self.txtInsuranceNumber.text = userData.object(forKey: "insuranceNumber") as? String ?? ""
        
        self.txtVehicleNumber.text = userData.object(forKey: "vehicleNumber") as? String ?? ""
        
        self.txtVehicleType.text = userData.object(forKey: "vehicleType") as? String ?? ""
        
        self.lblUserId.text = "id : \(userData.object(forKey: "deliveryPersonUniqueId") as? String ?? "")"
        
        //********
        let id1Url = URL(string: id1Str)
        
        if id1Url != nil{
           
            imgId1.setImageWith(id1Url!, placeholderImage: UIImage(named:"licenseImg"))
            
            DispatchQueue.global(qos: .background).async {
                
                if let data = try? Data(contentsOf: id1Url!)
                {
                    self.uploadIdOneData = data as NSData
                }
                
            }
        }
        
        //********
        let id2Url = URL(string: id2Str)
        
        if id2Url != nil{
            
            imgId2.setImageWith(id2Url!, placeholderImage: UIImage(named:"licenseImg"))
            
            DispatchQueue.global(qos: .background).async {
                
                if let data = try? Data(contentsOf: id2Url!)
                {
                    self.uploadIdTwoData = data as NSData
                }
            }
           
        }
        
        //********
        let imgUrl = URL(string: imgStr)
        
        if imgUrl != nil{
            
            imgProfile.setImageWith(imgUrl!, placeholderImage: UIImage(named:"userPlaceholder"))
            
            DispatchQueue.global(qos: .background).async {
                
                if let data = try? Data(contentsOf: imgUrl!)
                {
                    self.imageData = data as NSData
                }
            }
          
        }
        
        //********
        let vehicleUrl = URL(string: vehicleLicenseStr)
        
        if vehicleUrl != nil{
            
            imgLicense.setImageWith(vehicleUrl!, placeholderImage: UIImage(named:"licenseImg"))
            
            DispatchQueue.global(qos: .background).async {
                
                if let data = try? Data(contentsOf: vehicleUrl!)
                {
                    self.vehicleLicenseData = data as NSData
                }
            }
          
        }
        
        //********
        let insuranceUrl = URL(string: uploadedInsurance)
        
        if insuranceUrl != nil{
            
            imgInsurance.setImageWith(insuranceUrl!, placeholderImage: UIImage(named:"licenseImg"))
            
            DispatchQueue.global(qos: .background).async {
                
                if let data = try? Data(contentsOf: insuranceUrl!)
                {
                    self.insuranceData = data as NSData
                }
            }
          
        }
        
    }
    
    
}
