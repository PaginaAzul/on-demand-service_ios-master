//
//  MyRateVC.swift
//  Joker
//
//  Created by abc on 23/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class MyRateVC: UIViewController {
   
    @IBOutlet weak var tblView_MyRate: UITableView!
    
    @IBOutlet weak var btnDeliveryMan: UIButton!
    @IBOutlet weak var btnProfessional: UIButton!
    
    @IBOutlet weak var btnNormalUser: UIButton!
    
    @IBOutlet weak var btnRatingAll: UIButton!
    
    @IBOutlet weak var lblAvgRating: UILabel!
    
    
    
    let connection = webservices()
    
    var ratingType = ""
    var ratingArr = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
        
        ratingType = "NormalUser"
        
        self.apiCallForGetMyRating()
    }

    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tap_normalUserBtn(_ sender: Any) {
        
        btnNormalUser.setTitleColor(UIColor.white, for: .normal)
        btnDeliveryMan.setTitleColor(UIColor(red:0.52, green:0.00, blue:0.74, alpha:1.0), for: .normal)
        btnProfessional.setTitleColor(UIColor(red:0.52, green:0.00, blue:0.74, alpha:1.0), for: .normal)
        
        ratingType = "NormalUser"
        
        self.apiCallForGetMyRating()
    }
    
    @IBAction func tap_professionalWorkerBtn(_ sender: Any) {
        
        
        btnProfessional.setTitleColor(UIColor.white, for: .normal)
        btnNormalUser.setTitleColor(UIColor(red:0.52, green:0.00, blue:0.74, alpha:1.0), for: .normal)
        btnDeliveryMan.setTitleColor(UIColor(red:0.52, green:0.00, blue:0.74, alpha:1.0), for: .normal)
        
        ratingType = "ProfessionalWorker"
        
        self.apiCallForGetMyRating()
    }
    
    @IBAction func tap_deliveryManBtn(_ sender: Any) {
        
         btnNormalUser.setTitleColor(UIColor(red:0.52, green:0.00, blue:0.74, alpha:1.0), for: .normal)
         btnProfessional.setTitleColor(UIColor(red:0.52, green:0.00, blue:0.74, alpha:1.0), for: .normal)
         btnDeliveryMan.setTitleColor(UIColor.white, for: .normal)
        
        ratingType = "DeliveryPerson"
        
        self.apiCallForGetMyRating()
    }

}


//MARK: - Method extension

extension MyRateVC{
    
    func initialSetup(){
        tblView_MyRate.tableFooterView = UIView()
    }
}


//MARK: - Extension TableView Controller
extension MyRateVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ratingArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tblView_MyRate.register(UINib(nibName: "UserDetailTableViewCellAndXib", bundle: nil), forCellReuseIdentifier: "UserDetailTableViewCellAndXib")
        
        let cell = tblView_MyRate.dequeueReusableCell(withIdentifier: "UserDetailTableViewCellAndXib", for: indexPath) as! UserDetailTableViewCellAndXib
        
        let dict = ratingArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let rating = dict.object(forKey: "rate") as? Int ?? 0
        cell.lblDescription.text = dict.object(forKey: "comments") as? String ?? ""
        cell.lblName.text = dict.object(forKey: "ratingByName") as? String ?? ""
        
        cell.viewRating.rating = Double(rating)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
}


extension MyRateVC{
    
    func apiCallForGetMyRating(){
        
        let param:[String:String] = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","ratingToType":ratingType]
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetMyRating as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                       
                        if let data = receivedData.object(forKey: "Data") as? NSDictionary{
                            
                            let avgRating = data.object(forKey: "AvgRating") as? String ?? ""
                            
                            let totalRating = data.object(forKey: "TotalRating") as? Int ?? 0
                            
                            self.lblAvgRating.text = avgRating
                            self.btnRatingAll.setTitle("(\(totalRating) Rating)", for: .normal)
                            
                            self.ratingArr = data.object(forKey: "docs") as? NSArray ?? []
                            
                            self.tblView_MyRate.reloadData()
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
