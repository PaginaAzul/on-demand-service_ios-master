//
//  MoreVC.swift
//  Joker
//
//  Created by abc on 22/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//




import UIKit

class MoreVC: UIViewController {
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    
    @IBOutlet weak var tblMore: UITableView!
   
    @IBOutlet weak var deliveryWorkerSwitch: UISwitch!
    
    @IBOutlet weak var professionalWorkerSwitch: UISwitch!
    
    @IBOutlet weak var lblMore: UILabel!
    
    @IBOutlet weak var lblFollowUs: UITextField!
    
    let connection = webservices()
    
//    let containsArray = ["Home","My wallet/Passbook","Address History","My Profile","Become Delivery Person","Become Professional Worker","Settings","Language","Rate Us","Share App & Earn","Contact Admin"]
//
//    var imgArr = ["homeIcon","myWalletIcon","historyIcon","profileIcon","deliveryIcon","professionalIcon","settingsIcon","languageIcon","rateIcon","shareIcon","contactIcon"]
    
    
//    var containsArray = ["Home","Address History","Settings","Language","Rate Us","Share App","Contact"]
//
//    var imgArr = ["homeIcon","historyIcon","settingsIcon","languageIcon","rateIcon","shareIcon","contactIcon"]
    
    var containsArray = ["Home","My Order","My Favorties","Customer Stories","Address History","Settings","Language","Share App","Contact Us"]
    
    var imgArr = ["homeIcon","heartNew","heartNew","heartNew","historyIcon","settingsIcon","languageIcon","shareIcon","contactIcon"]
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    var hasSignupWithDelivery = ""
    var hasSignupWithProfessional = ""
    var adminVerifyDelivery = ""
    var adminVerifyProfessional = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        professionalWorkerSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        deliveryWorkerSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        
        self.imgUser.image = UIImage(named: "newPlace")
        imgUser.layer.cornerRadius = imgUser.frame.size.width/2
        imgUser.clipsToBounds = true
        
        intialSetUp()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        lblMore.text = "More".localized()
        lblFollowUs.text = "Follow Us".localized()
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            
            //            containsArray = ["Home".localized(),"My Order","My Favorites","Customer Stories","Login|Signup".localized(),"Language".localized(),"Share App".localized(),"Contact".localized()]
            //
            //            imgArr = ["homeIcon","Menu","heartNew","Menu","settingsIcon","languageIcon","shareIcon","contactIcon"]
            
            //Dummy
            containsArray = ["Home".localized(),"My Order".localized(),"My Favorties".localized(),"Customer Stories".localized(),"Address History".localized(),"Settings".localized(),"Language".localized(),"Share App".localized(),"Contact Us".localized()]
            
            imgArr = ["homeIcon","my_order_side","heartNew","stories","historyIcon","settingsIcon","languageIcon","shareIcon","contactIcon"]
            
            //Original
            /*
            containsArray = ["Home".localized(),"Address History".localized(),"Settings".localized(),"Language".localized(),"Share App".localized(),"Contact".localized()]
            
            imgArr = ["homeIcon","historyIcon","settingsIcon","languageIcon","shareIcon","contactIcon"]
            */
            hasSignupWithDelivery = ""
            hasSignupWithProfessional = ""
            adminVerifyDelivery = ""
            adminVerifyProfessional = ""
            
            lblUserName.isHidden = false
            imgUser.isHidden = false
            
            self.apiCallForGetUserType()
        }
        else{
            
            
//            containsArray = ["Home".localized(),"My Order","My Favorites","Customer Stories","Login|Signup".localized(),"Language".localized(),"Share App".localized(),"Contact".localized()]
//
//            imgArr = ["homeIcon","Menu","heartNew","Menu","settingsIcon","languageIcon","shareIcon","contactIcon"]
            
     
            containsArray = ["Home".localized(),"My Order".localized(),"My Favorties".localized(),"Customer Stories".localized(),"Login|Signup".localized(),"Language".localized(),"Share App".localized(),"Contact Us".localized()]
            
            imgArr = ["homeIcon","my_order_side","heartNew","stories","settingsIcon","languageIcon","shareIcon","contactIcon"]
            
            lblUserName.isHidden = true
            imgUser.isHidden = true
            
        }
        
        tblMore.reloadData()
    }
    
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_manageProfessional(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            if hasSignupWithProfessional == "true"{
                
                if hasSignupWithProfessional == "true" && hasSignupWithDelivery == "true"{
                    
                    let vc = ScreenManager.getMyCaptionScrollManagerVC()
                    
                    vc.indexItemWillSelect = 1
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                else{
                    
                    let vc = ScreenManager.getMyCaptionScrollManagerVC()
                    vc.signupUserType = "Professional"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else{
                
                let vc = ScreenManager.getAlertPopUPVC()
                vc.nabObj = self
                vc.purpuse = "Professional"
                self.present(vc, animated: true, completion: nil)
            }
          
        }
        else{
            
            alertWithAction()
        }
      
    }
    
    @IBAction func tap_manageDelivery(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            if hasSignupWithDelivery == "true"{
                
                if hasSignupWithProfessional == "true" && hasSignupWithDelivery == "true"{
                    
                    let vc = ScreenManager.getMyCaptionScrollManagerVC()
                  
                    vc.indexItemWillSelect = 0
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                else{
                    
                    let vc = ScreenManager.getMyCaptionScrollManagerVC()
                    vc.signupUserType = "Delivery"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else{
                
                let vc = ScreenManager.getAlertPopUPVC()
                vc.nabObj = self
                vc.purpuse = "Delivery"
                self.present(vc, animated: true, completion: nil)
                
            }
            
        }
        else{
            
            alertWithAction()
        }
        
     
    }
    
    @IBAction func tap_FB(_ sender: Any) {
        
        if let url = URL(string: "https://www.facebook.com/102220028205764/") {
            UIApplication.shared.open(url)
        }
        
    }
    
    
    @IBAction func tap_Insta(_ sender: Any) {
        
       if let url = URL(string: "https://www.instagram.com/_paginazul_/") {
           UIApplication.shared.open(url)
       }
        
    }
    
    
}

//MARK: - User Defined Methods Extension
extension MoreVC{
    
    func intialSetUp(){
        
        tblMore.tableFooterView = UIView()
        
    }
    
    
    func laterSetup(){
        
        if hasSignupWithDelivery == "true"{
            
            self.deliveryWorkerSwitch.isOn = true
        }
        else{
            
            self.deliveryWorkerSwitch.isOn = false
        }
        
        if hasSignupWithProfessional == "true"{
            
            self.professionalWorkerSwitch.isOn = true
        }
        else{
            
            self.professionalWorkerSwitch.isOn = false
        }
    }
}

//MARK: - Extension TableView Controller
extension MoreVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return containsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tblMore.register(UINib(nibName: "MoreTableViewCell", bundle: nil), forCellReuseIdentifier: "MoreTableViewCell")
        
        let cell = tblMore.dequeueReusableCell(withIdentifier: "MoreTableViewCell", for: indexPath) as! MoreTableViewCell
        
        cell.lblContain.text = containsArray[indexPath.row]
        
        cell.imgSide.image = UIImage(named: imgArr[indexPath.row])
        
        cell.lblContain.textColor = UIColor.darkGray
        
        return cell
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            ["Home".localized(),"Address History".localized(),"Settings".localized(),"Language".localized(),"Share App".localized(),"Contact Us".localized()]
            
            switch indexPath.row {
                
            case 0:
                
                
                let vc = ScreenManager.MainModuleNew_VC()
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                appDelegate.window?.rootViewController = navController
                appDelegate.window?.makeKeyAndVisible()

                case 1:
                               
                    if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                        
                        let vc = ScreenManager.MyOrderOngoingVC()
                        vc.isComingFromSideBar = true
                        let navController = UINavigationController(rootViewController: vc)
                        navController.navigationBar.isHidden = true
                        appDelegate.window?.rootViewController = navController
                        appDelegate.window?.makeKeyAndVisible()
                        
                    }
                    else{
                        
                        alertWithAction()
                }
                case 2:
                               
                               if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                                   
                                   let vc = ScreenManager.MyFavNew_VC()
                                   self.navigationController?.pushViewController(vc, animated: true)
                               }
                               else{
                                   
                                   alertWithAction()
                               }
                case 3:
                               
                               if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                                   
                                   let vc = ScreenManager.CustomerStoriesViewController()
                                   self.navigationController?.pushViewController(vc, animated: true)
                               }
                               else{
                                   
                                   alertWithAction()
                               }
                
                
            case 4:
                
                if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                    
                    let vc = ScreenManager.getAddNewAddressVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    
                    alertWithAction()
                }
                
            case 5:
                
                if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                    
                    let vc = ScreenManager.getSettingsVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    
                    alertWithAction()
                }
                
            case 6:
                
                if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                    
                    let vc = ScreenManager.getChangeLanguageVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    
                    alertWithAction()
                }
                
            case 7:
                
                if UserDefaults.standard.bool(forKey: "IsUserLogin"){
    
                    let promoText = "Welcome Paginazul Family".localized()
                    
                    let iOSUrl = "iOS app link:- https://apps.apple.com/br/app/paginazul/id1531074209"
                    
                    let andoirdUrl = "\n\nAndroid app link:- https://play.google.com/store/apps/details?id=com.pagin.azul"
                    
                    //let iOSUrl = "iOS app link:- https://paginzul.page.link/jdF1"
                    
                    //let andoirdUrl = "\n\nAndroid app link:- https://paginazul.page.link/qL6j"
                    
                    let sharableText = "\n\(iOSUrl)" + andoirdUrl
                    let activityController = UIActivityViewController(activityItems: [promoText,sharableText], applicationActivities: nil)
                    print(sharableText)
                    
                    activityController.completionWithItemsHandler = { (nil, completed, _, error) in
                        if completed {
                            print("Completed!")
                        } else {
                            print("Canceled!!")
                        }
                    }
                    
                    present(activityController , animated: true) {
                        print("Text Presented!")
                    }
                    
                }
                else{
                    
                    alertWithAction()
                }
                
            case 8:
                
                if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                    
                    let vc = ScreenManager.getContactUsVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    
                    alertWithAction()
                }
                
              
                
            case 9:
                
                if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                    
                    let vc = ScreenManager.getContactUsVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    
                    alertWithAction()
                }
                
            default:
                
                print("Nothing")
            }
        }
        else{
            
            switch indexPath.row {
                
            case 0:
                
                let vc = ScreenManager.MainModuleNew_VC()
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                appDelegate.window?.rootViewController = navController
                appDelegate.window?.makeKeyAndVisible()
                
                
              case 1:
                
                
                if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                    
                    let vc = ScreenManager.MyOrderOngoingVC()
                    vc.isComingFromSideBar = true
                    let navController = UINavigationController(rootViewController: vc)
                    navController.navigationBar.isHidden = true
                    appDelegate.window?.rootViewController = navController
                    appDelegate.window?.makeKeyAndVisible()
                }
                else{
                    
                    alertWithAction()
                }
                
               
                
            case 2:
                
                if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                    
                    let vc = ScreenManager.MyFavNew_VC()
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                else{
                    
                    alertWithAction()
                }
                
            case 3:
                
               if UserDefaults.standard.bool(forKey: "IsUserLogin"){

                    let vc = ScreenManager.CustomerStoriesViewController()
                    self.navigationController?.pushViewController(vc, animated: true)

                }
                else{

                    alertWithAction()
                }
               
            case 4:
                
               
                
                if UserDefaults.standard.bool(forKey: "IsUserLogin"){

                    self.makeRootToLoginSignup()

                }
                else{

                    alertWithAction()
                }
                
                
                
            case 5:
                
                if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                    
                    let vc = ScreenManager.getChangeLanguageVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    
                    alertWithAction()
                }
                              
           
              case 6:
                let promoText = "Welcome Paginazul Family".localized()
                
                let iOSUrl = "iOS app link:- https://paginzul.page.link/jdF1"
                
                let andoirdUrl = "\n\nAndroid app link:- https://paginazul.page.link/qL6j"
                
                let sharableText = "\n\(iOSUrl)" + andoirdUrl
                let activityController = UIActivityViewController(activityItems: [promoText,sharableText], applicationActivities: nil)
                print(sharableText)
                
                activityController.completionWithItemsHandler = { (nil, completed, _, error) in
                    if completed {
                        print("Completed!")
                    } else {
                        print("Canceled!!")
                    }
                }
                
                present(activityController , animated: true) {
                    print("Text Presented!")
                }
                print("nothing")
                case 7:
                    
                    
                    if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                        
                        let vc = ScreenManager.getContactUsVC()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else{
                        
                        alertWithAction()
                }
                

            default:
                
                print("Nothing")
            }
            
        }
        
    }
    
    
    func shareActivity(){
        
        let title = "This is the dummy content and it will replace at the time of live state of product."
        
        let textToShare = [title ] as [Any]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = []
        activityViewController.setValue("Paginazul", forKey: "Subject")
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    
    func alertWithAction(){
        
        let alertController = UIAlertController(title: "", message: "You are not logged in. Please login/signup before proceeding further.".localized(), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            self.makeRootToLoginSignup()
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func makeRootToLoginSignup(){
        
        UserDefaults.standard.set(true, forKey: "SpecificRootToService")
        
        let vc = ScreenManager.getSignInSignupVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
    }
    
}



extension MoreVC{
    
    func apiCallForGetUserType(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetUserType as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        self.hasSignupWithDelivery = receivedData.object(forKey: "signupWithDeliveryPerson") as? String ?? ""
                        
                        self.hasSignupWithProfessional = receivedData.object(forKey: "signupWithProfessionalWorker") as? String ?? ""
                        
                        self.adminVerifyDelivery = receivedData.object(forKey: "adminVerifyDeliveryPerson") as? String ?? ""
                        
                        self.adminVerifyProfessional = receivedData.object(forKey: "adminVerifyProfessionalWorker") as? String ?? ""
                        
                        let imgStr = receivedData.object(forKey: "profilePic") as? String ?? ""
                        let name = receivedData.object(forKey: "name") as? String ?? ""
                        self.lblUserName.text = name
                        
                        if imgStr != ""{
                            
                            let urlStr = URL(string: imgStr)
                            if urlStr != nil{
                                
                                self.imgUser.setImageWith(urlStr!, placeholderImage: UIImage(named: "newPlace"))
                            }
                        }
                        else{
                            
                            self.imgUser.image = UIImage(named: "newPlace")
                        }
                        
                        self.laterSetup()
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToHome()
                        }
                        else{
                            
                            self.navigationController?.popViewController(animated: true)
                            
                           // CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                        }
                    }
                }
                else{
                    
                    self.navigationController?.popViewController(animated: true)
                    
                   // CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
    
}
