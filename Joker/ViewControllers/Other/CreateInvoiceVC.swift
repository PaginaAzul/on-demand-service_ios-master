//
//  CreateInvoiceVC.swift
//  Joker
//
//  Created by Callsoft on 19/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

protocol CreateInvoiceDelegate{
    
    func invoiceCreated(status:Bool)
}


class CreateInvoiceVC: UIViewController {

    @IBOutlet weak var lblDiscountCutting: UILabel!
    
    @IBOutlet weak var txtTotalCostOfGoods: UITextField!
    
    @IBOutlet weak var imgInvoice: UIImageView!
    
    @IBOutlet weak var lblGoodsCostValue: UILabel!
    
    @IBOutlet weak var lblDeliveryCost: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    
    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    var imageName = ""
    
    var orderId = ""
    var controllerPurpuse = ""
    var userType = ""
    
    let connection = webservices()
    
    var isComing = ""
    
    var deliveryCost = ""
    
    var tax = ""
    
    var sendTotalPrice = 0.0
    
    var delegate:CreateInvoiceDelegate?
    
    var enteredGoodsAmount = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        txtTotalCostOfGoods.delegate = self
        
        initialSetup()
        
        if self.controllerPurpuse == "Edit"{
            
            self.apiCallForGetInvoiceDetail()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //uncomment this line when vat section will implement in next version
        
//        let lineView = UIView(
//            frame: CGRect(x: 0,y: lblDiscountCutting.bounds.size.height / 2,width: lblDiscountCutting.bounds.size.width,height: 1)
//        )
//        lineView.backgroundColor = UIColor.lightGray
//        lblDiscountCutting.addSubview(lineView)
    }
    
    
    @IBAction func tap_imgInvoiceBtn(_ sender: Any) {
        
        showImagePicker()
    }
    
    
    @IBAction func tap_closeBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_sendBtn(_ sender: Any) {
        
        checkValidation()
    }
    
    
    func updateElement(invoiceDict:NSDictionary){
        
        let imgStr = invoiceDict.object(forKey: "invoiceImage") as? String ?? ""
        
        let imgUrl = URL(string: imgStr)
        
        if imgUrl != nil{
            
            imgInvoice.setImageWith(imgUrl!)
            
            if let data = try? Data(contentsOf: imgUrl!)
            {
                self.imageData = data as NSData
                self.imageName = "invoice_image.jpg"
                
            }
            
        }
        
      //  self.txtTotalCostOfGoods.text = "\(invoiceDict.object(forKey: "invoiceSubtoatl") as? Int ?? 0)"
        
        deliveryCost = deliveryCost.trim()
        tax = tax.trim()
        let deliveryCostInt = Int(deliveryCost) ?? 0
        
        let goodsCost = invoiceDict.object(forKey: "invoiceTotal") as? Double ?? 0.0
        
        let deliveryCostInDouble = Double(deliveryCost) ?? 0.0
        let taxInDouble = Double(tax) ?? 0.0
        
        self.lblGoodsCostValue.text = "\(Int(goodsCost - deliveryCostInDouble - taxInDouble)) SAR"
        
        self.txtTotalCostOfGoods.text = "\(Int(goodsCost - deliveryCostInDouble - taxInDouble))"
        
        self.enteredGoodsAmount = "\(Int(goodsCost - deliveryCostInDouble - taxInDouble))"
        
        lblDiscountCutting.text = "\(deliveryCostInt) SAR + \(taxInDouble) SAR"
        
        lblTotal.text = "\(goodsCost) SAR"
        
        self.sendTotalPrice = goodsCost
        
//        self.lblGoodsCostValue.text = "\(goodsCost - deliveryCostInt) SAR"
//        self.txtTotalCostOfGoods.text = "\(goodsCost - deliveryCostInt)"
//
//
//        lblDiscountCutting.text = "\(deliveryCostInt) SAR"
//        lblTotal.text = "\(deliveryCostInt+goodsCost) SAR"
//
//        self.sendTotalPrice = deliveryCostInt + goodsCost
        
    }
    
    
}


extension CreateInvoiceVC{
    
    func initialSetup(){
        
        lblDiscountCutting.text = "\(deliveryCost) SAR + \(tax) SAR"
        
        deliveryCost = deliveryCost.trimmingCharacters(in: .whitespaces)
        tax = tax.trimmingCharacters(in: .whitespaces)
        
        let deliveryAmountDouble = Double(deliveryCost) ?? 0.0
        let taxInDouble = Double(tax) ?? 0.0
        
        let totalAmountInDouble = deliveryAmountDouble + taxInDouble
        
        lblTotal.text = "\(totalAmountInDouble) SAR"
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


extension CreateInvoiceVC:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        imgInvoice.image = chosenImage
        imageData = UIImageJPEGRepresentation(chosenImage, 1.0) as NSData!
        imageName = "invoice_image.jpg"
        
        dismiss(animated: true, completion: nil)
    }
    
}


extension CreateInvoiceVC{
    
    func checkValidation(){
        
        var mess = ""
        
        if txtTotalCostOfGoods.text == ""{
            
            mess = "Please enter total cost of goods"
        }
//        else if imageName == ""{
//
//            mess = "Please upload invoice image"
//        }
        else{
            
            mess = ""
        }
        
        
        if mess == ""{
            
            self.apiCallForCreateInvoice()
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: mess, controller: self)
        }
        
    }
    
    
    func apiCallForCreateInvoice(){
        
      //  let param:[String:String] = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","orderId":orderId,"goodsPrice":txtTotalCostOfGoods.text!]
        
        let param:[String:String] = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","orderId":orderId,"goodsPrice":"\(self.sendTotalPrice)","amount":"\(enteredGoodsAmount)"]
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithProfileData(imageData: imageData, fileName: "invoice_image.jpg", imageparm: "invoiceImage", getUrlString: App.URLs.apiCallForCreateInvoice as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let alertController = UIAlertController(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            
                            if self.isComing == ""{
                                
                                if self.controllerPurpuse == "Edit"{
                                    
                                    self.navigationController?.popViewController(animated: true)
                                }
                                else{
                                    
                                    self.delegate?.invoiceCreated(status: true)
                                    self.navigationController?.popViewController(animated: true)
                                    
                                }
                             
                            }
                            else{
                                
                            self.navigationController?.popToRootViewController(animated: true)
                                
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
    
    
    func apiCallForGetInvoiceDetail(){
        
        let param:[String:String] = ["orderId":orderId]
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
           self.connection.startConnectionWithSting(App.URLs.apiCallForGetInvoiceDetail as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let invoiceDict = receivedData.object(forKey: "result") as? NSDictionary ?? [:]
                        
                        self.updateElement(invoiceDict: invoiceDict)
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
                    
                    self.navigationController?.popViewController(animated: true)
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
                
            }
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }

}


//MARK:- UITextField Delegate
//MARK:-
extension CreateInvoiceVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtTotalCostOfGoods{
            
            let textGoods = NSString(string: txtTotalCostOfGoods.text!).replacingCharacters(in: range, with: string)
            
            if textGoods.isNumeric == false{
                
                return false
            }
            
            tax = tax.trim()
            
            let taxInDouble = Double(tax) ?? 0.0
            deliveryCost = deliveryCost.trimmingCharacters(in: .whitespaces)
            
            let deliveryCostInDouble = Double(deliveryCost) ?? 0.0
            
            let goodsPrice = textGoods.trimmingCharacters(in: .whitespaces)
            
            let goodsPriceInt = Int(goodsPrice) ?? 0
            
            let goodsCostDouble = Double(goodsPrice) ?? 0.0
            
            self.enteredGoodsAmount = "\(goodsPriceInt)"
            
            self.lblGoodsCostValue.text = "\(goodsPriceInt) SAR"
            
            self.lblDiscountCutting.text = "\(deliveryCost) SAR + \(taxInDouble) SAR"
            
            self.lblTotal.text = "\(goodsCostDouble + deliveryCostInDouble + taxInDouble) SAR"
            
            self.sendTotalPrice = goodsCostDouble + deliveryCostInDouble + taxInDouble
            
            
            
//            self.lblGoodsCostValue.text = "\(goodsPriceInt) SAR"
//            self.lblDiscountCutting.text = "\(deliveryCost) SAR"
//
//            let deliveryCostInt = Int(deliveryCost) ?? 0
//
//            self.lblTotal.text = "\(deliveryCostInt+goodsPriceInt) SAR"
//
//            self.sendTotalPrice = deliveryCostInt + goodsPriceInt
            
            return true
        }
        
        return true
    }
    
}


//FORMATTER EXTENSION
extension Formatter {
    
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ","
    }
}


extension String {
    
    var isNumeric: Bool {
        guard self.count >= 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
        return Set(self).isSubset(of: nums)
    }
}
