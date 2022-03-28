//
//  UserDetailVC.swift
//  Joker
//
//  Created by abc on 18/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class UserDetailVC: UIViewController {

@IBOutlet weak var tblView_userDetails: UITableView!
    
    @IBOutlet weak var lblNav: UILabel!
    
    
    let header: UserDetailsTableViewHeader = Bundle.main.loadNibNamed("UserDetailsTableViewHeader", owner: self, options: nil)!.first! as! UserDetailsTableViewHeader
    
    var userID = ""
    
    var ratingArr = NSArray()
    
    var dictRatingResponse = NSDictionary()
    
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNav.text = "User Detail".localized()
        initialSetup()

    }
    
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    

}
//MARK: - Method extension

extension UserDetailVC{
    
    func initialSetup(){
        
        tblView_userDetails.tableFooterView = UIView()
        
        self.apiCallForGetUserDetail()
    }
}



extension UserDetailVC:UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ratingArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tblView_userDetails.register(UINib(nibName: "UserDetailTableViewCellAndXib", bundle: nil), forCellReuseIdentifier: "UserDetailTableViewCellAndXib")
        let cell = tblView_userDetails.dequeueReusableCell(withIdentifier: "UserDetailTableViewCellAndXib", for: indexPath) as! UserDetailTableViewCellAndXib
      //  cell.lblDescription.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"
        
        let dict = ratingArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        cell.lblName.text = dict.object(forKey: "ratingBy1") as? String ?? ""
        
        let ratingCount = dict.object(forKey: "rate") as? Int ?? 0
        
        if ratingCount == 0{
            
            cell.viewRating.rating = 0.0
        }
        else{
            
            cell.viewRating.rating = Double(ratingCount)
        }
        
        let description = dict.object(forKey: "comments") as? String ?? ""
        
        if description == ""{
            
            cell.lblDescription.text = "No feedback found".localized()
        }
        else{
            
            cell.lblDescription.text = description
        }
        
        return cell
    }
    
    
    func updateHeaderElement(){
        
        let avgRating = dictRatingResponse.object(forKey: "AvgRating") as? Double ?? 0.0
        let name = dictRatingResponse.object(forKey: "name") as? String ?? ""
        let totalRating = dictRatingResponse.object(forKey: "TotalRating") as? Int ?? 0
   //     let gender = dictRatingResponse.object(forKey: "gender") as? String ?? ""
        let imgStr = dictRatingResponse.object(forKey: "profilePic") as? String ?? ""
        
        header.lblName.text = name
        header.lblAvgRating.text = "\(avgRating)"
        
        header.lblAllCommentsFrom.text = "All Comments from Professional Person".localized()
        
        if self.ratingArr.count == 0{
            
            header.lblTotalRating.text = "\(totalRating) "+"Rating".localized()
        }
        else{
            
            header.lblTotalRating.text = "\(totalRating) "+"Rating".localized()+"("+"Given by".localized()+" \(ratingArr.count) "+"User".localized()+")"
        }
        
//        if gender == "Male"{
//
//            header.imgGender.image = UIImage(named: "")
//        }
//        else{
//
//            header.imgGender.image = UIImage(named: "")
//        }
        
        if imgStr == ""{
            
            header.imgUser.image = UIImage(named: "placeholderImg")
        }
        else{
            
            let urlStr = URL(string: imgStr)
            header.imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
        header.imgUser.layer.cornerRadius = header.imgUser.frame.width/2
        header.imgUser.clipsToBounds = true
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        
        return 271
    }
}

//apiCallForGetAllRating

extension UserDetailVC{
    
    func apiCallForGetUserDetail(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":userID]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetAllRating as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.dictRatingResponse = receivedData
                        
                        self.ratingArr = receivedData.object(forKey: "Data1") as? NSArray ?? []
                        
                        self.updateHeaderElement()
                        
                        self.tblView_userDetails.reloadData()

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






/////////sample response
//http://3.18.37.151:3000/api/v1/user/getAllRating
//{
//    AvgRating = "4.2";
//    Data1 =     (
//        {
//            "_id" = 5cc304e08270185bb6140ae2;
//            comments = "Right Person";
//            createdAt = "2019-04-26T13:17:20.020Z";
//            rate = 3;
//            ratingBy = 5cc19ceb152b18709c0dd92a;
//            ratingBy1 = Ravi;
//            ratingByName = Ravi;
//            ratingByType = ProfessionalWorker;
//            ratingMessage = Responsive;
//            ratingTo = 5cc19c97152b18709c0dd929;
//            ratingToName = Abhishek;
//            ratingToType = NormalUser;
//            status = ACTIVE;
//            updatedAt = "2019-04-26T13:17:20.020Z";
//    },
//        {
//            "_id" = 5cc2e927d4ef4554a5d8673e;
//            comments = "Good Experience";
//            createdAt = "2019-04-26T11:19:03.432Z";
//            rate = 5;
//            ratingBy = 5cc19ceb152b18709c0dd92a;
//            ratingBy1 = Ravi;
//            ratingByName = Ravi;
//            ratingByType = DeliveryPerson;
//            ratingMessage = Professional;
//            ratingTo = 5cc19c97152b18709c0dd929;
//            ratingToName = Abhishek;
//            ratingToType = NormalUser;
//            status = ACTIVE;
//            updatedAt = "2019-04-26T11:19:03.432Z";
//    },
//        {
//            "_id" = 5cc2e8d387d4205344551083;
//            comments = "Good Experience";
//            createdAt = "2019-04-26T11:17:39.994Z";
//            rate = 5;
//            ratingBy = 5cc19ceb152b18709c0dd92a;
//            ratingBy1 = Ravi;
//            ratingByName = Ravi;
//            ratingByType = DeliveryPerson;
//            ratingMessage = Professional;
//            ratingTo = 5cc19c97152b18709c0dd929;
//            ratingToName = Abhishek;
//            ratingToType = NormalUser;
//            status = ACTIVE;
//            updatedAt = "2019-04-26T11:17:39.994Z";
//    },
//        {
//            "_id" = 5cc1a76d5257d27b02e853b1;
//            comments = "Better experience";
//            createdAt = "2019-04-25T12:26:21.188Z";
//            rate = 4;
//            ratingBy = 5cc19ceb152b18709c0dd92a;
//            ratingBy1 = Ravi;
//            ratingByName = Ravi;
//            ratingByType = DeliveryPerson;
//            ratingMessage = "Quick Service";
//            ratingTo = 5cc19c97152b18709c0dd929;
//            ratingToName = Abhishek;
//            ratingToType = NormalUser;
//            status = ACTIVE;
//            updatedAt = "2019-04-25T12:26:21.188Z";
//    }
//    );
//    TotalRating = 4;
//    gender = Male;
//    name = Abhishek;
//    profilePic = "https://res.cloudinary.com/boss8055/image/upload/v1556606338/rtipgzhmtpzhv9o0yv56.jpg";
//    "response_message" = "Rating List found successfully \U2714";
//    status = SUCCESS;
//}
