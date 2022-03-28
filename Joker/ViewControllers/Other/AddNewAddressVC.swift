//
//  AddNewAddressVC.swift
//  Joker
//
//  Created by Dacall soft on 22/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

protocol SavedAddressHistoryDelegate{
    
    func returnSavedAddress(address:String,lat:Double,long:Double,purpuse:String)
}


import UIKit

class AddNewAddressVC: UIViewController {

    let connection = webservices()
    
    @IBOutlet weak var viewTableHolder: UIView!
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var lblSelectAddress: UILabel!
    
    
    var addressesArr = NSArray()
   
    var selectionDeselectionArr = NSMutableArray()
    
    var delegate:SavedAddressHistoryDelegate?
    
    var purpuse = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.apiCallForGetMyAddressess()
        
        lblSelectAddress.text = "Select Address".localized()
        
    }
    
    @IBAction func tap_crossBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func tap_DoneBtn(_ sender: Any) {
       
        if selectionDeselectionArr.contains("1"){
            
            let index = selectionDeselectionArr.index(of: "1")
            
            let dict = addressesArr.object(at: index) as? NSDictionary ?? [:]
            
            //let landmark = dict.object(forKey: "landmark") as? String ?? ""
            let address = dict.object(forKey: "address") as? String ?? ""
            let buildingApartment = dict.object(forKey: "buildingAndApart") as? String ?? ""
            let lati = dict.object(forKey: "lat") as? Double ?? 0.0
            let longi = dict.object(forKey: "long") as? Double ?? 0.0
            
            self.delegate?.returnSavedAddress(address: "\(buildingApartment),\(address)", lat: lati, long: longi, purpuse: self.purpuse)
            
            self.dismiss(animated: true, completion: nil)
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please select the address", controller: self)
        }
        
       
    }
    
}

extension AddNewAddressVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return addressesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableview.register(UINib(nibName: "ManageAddressTableViewCellAndXib", bundle: nil), forCellReuseIdentifier: "ManageAddressTableViewCellAndXib")
        let cell = tableview.dequeueReusableCell(withIdentifier: "ManageAddressTableViewCellAndXib", for: indexPath) as! ManageAddressTableViewCellAndXib
        
        let dict = addressesArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let landmark = dict.object(forKey: "landmark") as? String ?? ""
        let address = dict.object(forKey: "address") as? String ?? ""
        let buildingApartment = dict.object(forKey: "buildingAndApart") as? String ?? ""
        
        cell.viewStack.isHidden = true
        
        cell.lblTitle.text = landmark
        
        cell.lblAddress.text = "\(buildingApartment)\n\(address)"
      
        if selectionDeselectionArr.object(at: indexPath.row) as? String ?? "" == "0"{
            
            cell.imgAddress.isHidden = true
        }
        else{
            
            cell.imgAddress.isHidden = false
        }
        
        cell.viewContentHolder.borderColor = UIColor.clear
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectionDeselectionArr.removeAllObjects()
        for _ in 0..<addressesArr.count{
            
            selectionDeselectionArr.add("0")
            
        }
        
        selectionDeselectionArr.replaceObject(at: indexPath.row, with: "1")
        
        self.tableview.reloadData()
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    
}

extension AddNewAddressVC{
    
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
                                    
                                    self.selectionDeselectionArr.removeAllObjects()
                                    
                                    if self.addressesArr.count != 0{
                                        
                                        for _ in 0..<self.addressesArr.count{
                                            
                                            self.selectionDeselectionArr.add("0")
                                        }
                                        
                                    }
                                    else{
                                        
                                        let alertController = UIAlertController(title: "", message: "No address found".localized(), preferredStyle: .alert)
                                        
                                        
                                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                            UIAlertAction in
                                            
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                        
                                        alertController.addAction(okAction)
                                        
                                        self.present(alertController, animated: true, completion: nil)
                                        
                                    }
                                    
                                    self.tableview.reloadData()
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
}

extension AddNewAddressVC{
    

}
