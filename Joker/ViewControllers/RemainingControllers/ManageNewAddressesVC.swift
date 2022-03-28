//
//  ManageNewAddressesVC.swift
//  Joker
//
//  Created by Callsoft on 30/01/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class ManageNewAddressesVC: UIViewController {

    @IBOutlet weak var tblAddress: UITableView!
    @IBOutlet var tblFooterView: UIView!
    @IBOutlet weak var lblManageAddress: UILabel!
    @IBOutlet weak var btnAddNewAddress: UIButton!
    
    @IBOutlet weak var btnEditAddresses: UIButton!
    
    
    
    var addressesArr = NSArray()
    let connection = webservices()
    var delegate: SavedAddressHistoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

         intialSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        localization()
        
        self.apiCallForGetMyAddressess()
        
    }
    
    func localization(){
        
        lblManageAddress.text = "Edit address".localized()
        btnEditAddresses.setTitle("+ Add New Address".localized(), for: .normal)
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_addNewAddressBtn(_ sender: Any) {
        
        let vc = ScreenManager.getAddressPickerVC()
        
        vc.controllerName = ""
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
}


extension ManageNewAddressesVC{
    
    func intialSetUp(){
        
       tblAddress.tableFooterView = tblFooterView
    }
}



extension ManageNewAddressesVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return addressesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tblAddress.register(UINib(nibName: "ManageAddressTableViewCellAndXib", bundle: nil), forCellReuseIdentifier: "ManageAddressTableViewCellAndXib")
        let cell = tblAddress.dequeueReusableCell(withIdentifier: "ManageAddressTableViewCellAndXib", for: indexPath) as! ManageAddressTableViewCellAndXib
        
        let dict = addressesArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let landmark = dict.object(forKey: "landmark") as? String ?? ""
        let address = dict.object(forKey: "address") as? String ?? ""
        let buildingApartment = dict.object(forKey: "buildingAndApart") as? String ?? ""
        
        cell.lblTitle.text = landmark
        
        if buildingApartment == ""{
            cell.lblAddress.text = "\(address)"
        }else{
            cell.lblAddress.text = "\(buildingApartment)\n\(address)"
        }
        
        cell.btnEdit.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        
        cell.btnEdit.addTarget(self, action: #selector(self.tapEditBtn(sender:)), for: UIControlEvents.touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(self.tapDeleteBtn(sender:)), for: UIControlEvents.touchUpInside)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = addressesArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        
        let address = dict.object(forKey: "address") as? String ?? ""
        let buildingAndApart = dict.object(forKey: "buildingAndApart") as? String ?? ""
        let landmark = dict.object(forKey: "landmark") as? String ?? ""
        let lat = dict.object(forKey: "lat") as? String ?? ""
        let long = dict.object(forKey: "long") as? String ?? ""

        
        var add = String()
        if buildingAndApart != "" {
            add = "\(buildingAndApart), \(address)"
        }else{
            add = address
        }
        
        UserDefaults.standard.setValue(add, forKey: "DefaultAddress")
        UserDefaults.standard.setValue(lat, forKey: "DefaultLat")
        UserDefaults.standard.setValue(long, forKey: "DefaultLong")
        UserDefaults.standard.setValue(landmark, forKey: "DefaultLandmark")
        UserDefaults.standard.setValue(buildingAndApart, forKey: "DefaultBuildingAndApart")

        self.delegate?.returnSavedAddress(address: add, lat: (lat as NSString).doubleValue, long: (long as NSString).doubleValue, purpuse: buildingAndApart)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.navigationController?.popViewController(animated: false)
        }

    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    @objc func tapEditBtn(sender:UIButton){
        
        let dict = addressesArr.object(at: sender.tag) as? NSDictionary ?? [:]
        
        let vc = ScreenManager.getAddressPickerVC()
        
        vc.controllerName = "Edit"
        
        vc.addressDictForEdit = dict
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func tapDeleteBtn(sender:UIButton){
        
        
        let alertController = UIAlertController(title: "", message: "Are you sure you want to delete address?".localized(), preferredStyle: .alert)
        
       
        let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default) {
            UIAlertAction in
           
            let dict = self.addressesArr.object(at: sender.tag) as? NSDictionary ?? [:]
            let id = dict.object(forKey: "_id") as? String ?? ""
            self.apiCallForDeleteAddress(deleteID: id)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertActionStyle.cancel) {
            UIAlertAction in
          
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

//MARK:- Webservices
//MARK:-
extension ManageNewAddressesVC{
    
    func apiCallForGetMyAddressess(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param:[String:String] = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetAllAddresses as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        if let dataDict = receivedData.object(forKey: "Data") as? NSDictionary{
                            
                            if let arr = dataDict.object(forKey: "docs") as? NSArray{
                                
                                let dict = arr.object(at: 0) as? NSDictionary ?? [:]
                                
                                if let addressArr = dict.object(forKey: "addresses") as? NSArray{
                                    
                                    self.addressesArr = addressArr
                                    
                                    self.tblAddress.reloadData()
                                }
                                
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
    
    
    
    func apiCallForDeleteAddress(deleteID:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param:[String:String] = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","addressId":deleteID]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForDeleteAddress as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.apiCallForGetMyAddressess()
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

