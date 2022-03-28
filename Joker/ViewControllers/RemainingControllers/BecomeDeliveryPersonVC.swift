//
//  BecomeDeliveryPersonVC.swift
//  Joker
//
//  Created by abc on 24/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit
import DropDown
import Photos


class BecomeDeliveryPersonVC: UIViewController {

    
    @IBOutlet weak var lblUploadId1: UILabel!
    
    @IBOutlet weak var lblUploadId2: UILabel!
    
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var btnVehicleType: UIButton!
    
    @IBOutlet weak var txtVehicleType: UITextField!
    
    @IBOutlet weak var txtVehicleNumber: UITextField!
    
    @IBOutlet weak var lblVehicleLicense: UILabel!
    
    @IBOutlet weak var txtInsuranceNumber: UITextField!
    
    @IBOutlet weak var lblUploadInsurancelbl: UILabel!
    
    @IBOutlet weak var txtBankAccount: UITextField!
    
    @IBOutlet weak var txtEmergencyContact: UITextField!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            self.txtVehicleType.text = "\(item)"
            
        }
        
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_uploadId1(_ sender: Any) {
        
        self.imageUploadTag = 0
        showImagePicker()
    }
    
    @IBAction func tap_uploadId2(_ sender: Any) {
        
        self.imageUploadTag = 1
        showImagePicker()
    }
    
    @IBAction func tap_vehicleType(_ sender: Any) {
        
        dropDown.dataSource = vehicleTypeArr
        dropDown.anchorView = btnVehicleType
        dropDown.show()
    }
    
    @IBAction func tap_vehicalLicense(_ sender: Any) {
        
        self.imageUploadTag = 2
        showImagePicker()
    }
    
    @IBAction func tap_uploadInsuranceBtn(_ sender: Any) {
        
        self.imageUploadTag = 3
        showImagePicker()
    }
    
    @IBAction func tap_submitBtn(_ sender: Any) {
        
        checkValidation()
    }
    
    @IBAction func tap_uploadImgBtn(_ sender: Any) {
        
        self.imageUploadTag = 4
        showImagePicker()
    }
    
    
}


extension BecomeDeliveryPersonVC{
    
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

extension BecomeDeliveryPersonVC:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
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
            
            lblUploadId1.text = imageName
            
            if lblUploadId1.text == ""{
                
                lblUploadId1.text = "ID - 1 attached".localized()
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
            
            vehicleLicenseData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
            
            lblVehicleLicense.text = imageName
            
            if lblVehicleLicense.text == ""{
                
                lblVehicleLicense.text = "Vehicle license attached".localized()
            }
        }
        else if self.imageUploadTag == 3{
            
            insuranceData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
            
            lblUploadInsurancelbl.text = imageName
            
            if lblUploadInsurancelbl.text == ""{
                
                lblUploadInsurancelbl.text = "Insurance attached"
            }
        }
        else if self.imageUploadTag == 4{
            
            imageData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
            imgProfile.image = chosenImage
            
        }

        dismiss(animated: true, completion: nil)
    }
}

extension BecomeDeliveryPersonVC:UITextViewDelegate{
    
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

extension BecomeDeliveryPersonVC{
    
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
        else if txtEmergencyContact.text == ""{

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
            
            let param = ["aboutUs":txtView.text!,"vehicleNumber":txtVehicleNumber.text!,"vehicleType":txtVehicleType.text!,"insuranceNumber":txtInsuranceNumber.text!,"bankAC":txtBankAccount.text!,"emergencyContact":txtEmergencyContact.text!,"userType":"DeliveryPersion","userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
            
            print(param)
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithFiveFile(imageData: imageData, uploadId1data: uploadIdOneData, uploadId2Data: uploadIdTwoData, UploadId3data: vehicleLicenseData, uploadId4Data: insuranceData, profileParam: "profilePic", uploadId1Param: "id1", uploadId2Param: "id2", uploadId3Param: "vehicleLicense", uploadId4Param: "insurance", getUrlString: App.URLs.apiCallForBecomeDeliveryPerson as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
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
