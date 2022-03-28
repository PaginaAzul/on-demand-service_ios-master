//
//  ReviewRatingVC.swift
//  Joker
//
//  Created by Callsoft on 31/01/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

protocol checkBackRatingProtocol {
    func backFromRating(_ status:Bool)
}
class ReviewRatingVC: UIViewController {
    
    var isComing = String()
    
    let connection = webservices()
    
    @IBOutlet weak var btnMinus2: UIButton!
    @IBOutlet weak var btnMinus1: UIButton!
    @IBOutlet weak var btnZero: UIButton!
    @IBOutlet weak var btnPlus1: UIButton!
    @IBOutlet weak var btnPlus2: UIButton!
    @IBOutlet weak var lblPlus2: UILabel!
    @IBOutlet weak var lblPlus1: UILabel!
    @IBOutlet weak var lblZero: UILabel!
    @IBOutlet weak var lblMinus1: UILabel!
    @IBOutlet weak var lblMinus2: UILabel!
    @IBOutlet weak var btnQuickService: UIButton!
    @IBOutlet weak var btnGental: UIButton!
    @IBOutlet weak var btnResponsive: UIButton!
    @IBOutlet weak var btnProfessional: UIButton!
    @IBOutlet weak var txtViewComment: UITextView!
    @IBOutlet weak var lblNav: UILabel!
    @IBOutlet weak var lblWhatDoYouLikeMost: UILabel!
    @IBOutlet weak var lblGiveYourRatingAndReview: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var backFromDelegate:checkBackRatingProtocol?
    var likeFeature = "Quick Service".localized()
    var submittedRating = "5"
    var controllerPurpuse = ""
    var ratingPurpuse = ""
    var screenName = ""
    
    ////particular order rating required data
    
    var ratingToUserId = ""
    var ratingToTypeUser = ""
    var ratingByTypeUser = ""
    var orderId = ""
    
    var isComingSub = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isComingFromNew = Bool()
    var resAndStoreId = String()
    
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtViewComment.text = "Give your comment...".localized()
        txtViewComment.delegate = self
        
        if UserDefaults.standard.bool(forKey: "RateThroughPopup"){
            
            UserDefaults.standard.set(false, forKey: "RateThroughPopup")
            
            let ratingData = UserDefaults.standard.object(forKey: "RatingDataDict") as? Data ?? Data()
            
            let dict = NSKeyedUnarchiver.unarchiveObject(with: ratingData) as? NSMutableDictionary ?? [:]
            
            self.isComing = dict.object(forKey: "isComing") as? String ?? ""
            self.ratingToUserId = dict.object(forKey: "RatingToUser") as? String ?? ""
            self.orderId = dict.object(forKey: "OrderId") as? String ?? ""
            self.ratingToTypeUser = dict.object(forKey: "ratingToTypeUser") as? String ?? ""
            self.ratingByTypeUser = dict.object(forKey: "ratingByTypeUser") as? String ?? ""
            self.ratingPurpuse = dict.object(forKey: "ratingPurpuse") as? String ?? ""
            
            UserDefaults.standard.removeObject(forKey: "RatingDataDict")
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if isComingFromNew == true {
            lblNav.text = "Ratings and Reviews".localized()
        }else{
          lblNav.text = "Rating and Review".localized()
        }
        
        lblWhatDoYouLikeMost.text = "What do you like most".localized()
        lblNote.text = "Note: Make sure Once you submit the commentyou are not able to edit".localized()
        btnSubmit.setTitle("Send".localized(), for: .normal)
        lblGiveYourRatingAndReview.text = "Give Your Rating And Review".localized()
        
        btnQuickService.setTitle("Quick Service".localized(), for: .normal)
        btnProfessional.setTitle("Professional".localized(), for: .normal)
        btnResponsive.setTitle("Responsive".localized(), for: .normal)
        btnGental.setTitle("Gentle".localized(), for: .normal)
    }
    
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        if isComing == "DELIVERY"{
            
            redirectToDeliveryWorkerScrollManager()
        }
        else if isComing == "PROFESSIONAL"{
            
            redirectToProfessionalWorkerScrollManager()
            
        }
        else if isComing == "normalDeliveryViaPopup"{
            
            redirectToNormalDeliveryPastDashboard()
            
        }
        else if isComing == "normalPROFESSIONALViaPopup"{
            
            redirectToNormalProfessionalPastDashboard()
            
        }
        else{
            if isComingFromNew == true {
                self.backFromDelegate?.backFromRating(true)

               self.navigationController?.popViewController(animated: true)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
            
        }
      
    }
    
    
    func redirectToDeliveryWorkerScrollManager(){
        
        UserDefaults.standard.set(true, forKey: "RootApply")
        
        UserDefaults.standard.set(true, forKey: "PastRedirectionOfDeliveryWorker")
        
        let vc = ScreenManager.getDeliveryPersonScrollManagerVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func redirectToProfessionalWorkerScrollManager(){
        
        UserDefaults.standard.set(true, forKey: "RootApplyForProfessional")
        
        UserDefaults.standard.set(true, forKey: "PastRedirectionOfProfessionalWorker")
        
        let vc = ScreenManager.getProfessionalWorkerScrollManagerVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        self.appDelegate.window?.rootViewController = navController
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    func redirectToNormalDeliveryPastDashboard(){
        
        let vc = ScreenManager.getMyOrderNoralUserScrollerVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        self.appDelegate.window?.rootViewController = navController
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    func redirectToNormalProfessionalPastDashboard(){
        
        let vc = ScreenManager.getNormalUserWithProfessionalWorkerScrollerVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        self.appDelegate.window?.rootViewController = navController
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    
    @IBAction func tap_submitBtn(_ sender: Any) {
        /*
        if isComingFromNew == true {
            self.navigationController?.popViewController(animated: true)
        }else{
           checkValidation()
        }
        */
        
        
        checkValidation()

     
    }
    
    
    @IBAction func tap_professionalBtn(_ sender: Any) {
        
        btnProfessional.setTitleColor(UIColor.white, for: .normal)
        btnProfessional.backgroundColor = UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00)
        
        btnQuickService.setTitleColor(UIColor.lightGray, for: .normal)
        btnGental.setTitleColor(UIColor.lightGray, for: .normal)
        btnResponsive.setTitleColor(UIColor.lightGray, for: .normal)
        
        btnQuickService.backgroundColor = UIColor.white
        btnGental.backgroundColor = UIColor.white
        btnResponsive.backgroundColor = UIColor.white
        
        btnProfessional.layer.borderWidth = 0
        btnProfessional.layer.borderColor = UIColor.clear.cgColor
        
        btnQuickService.layer.borderWidth = 1
        btnQuickService.layer.borderColor = UIColor.lightGray.cgColor
        btnGental.layer.borderWidth = 1
        btnGental.layer.borderColor = UIColor.lightGray.cgColor
        btnResponsive.layer.borderWidth = 1
        btnResponsive.layer.borderColor = UIColor.lightGray.cgColor
        
        likeFeature = "Professional"
    }
    
    @IBAction func tap_quickServiceBtn(_ sender: Any) {
        
        btnQuickService.setTitleColor(UIColor.white, for: .normal)
        btnQuickService.backgroundColor = UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00)
        
        btnProfessional.setTitleColor(UIColor.lightGray, for: .normal)
        btnGental.setTitleColor(UIColor.lightGray, for: .normal)
        btnResponsive.setTitleColor(UIColor.lightGray, for: .normal)
        
        btnProfessional.backgroundColor = UIColor.white
        btnGental.backgroundColor = UIColor.white
        btnResponsive.backgroundColor = UIColor.white
        
        btnQuickService.layer.borderWidth = 0
        btnQuickService.layer.borderColor = UIColor.clear.cgColor
        
        btnProfessional.layer.borderWidth = 1
        btnProfessional.layer.borderColor = UIColor.lightGray.cgColor
        btnGental.layer.borderWidth = 1
        btnGental.layer.borderColor = UIColor.lightGray.cgColor
        btnResponsive.layer.borderWidth = 1
        btnResponsive.layer.borderColor = UIColor.lightGray.cgColor
        
        likeFeature = "Quick Service"
    }
    
    
    @IBAction func tap_gentalBtn(_ sender: Any) {
        
        btnGental.setTitleColor(UIColor.white, for: .normal)
        btnGental.backgroundColor = UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00)
        
        btnProfessional.setTitleColor(UIColor.lightGray, for: .normal)
        btnQuickService.setTitleColor(UIColor.lightGray, for: .normal)
        btnResponsive.setTitleColor(UIColor.lightGray, for: .normal)
        
        btnProfessional.backgroundColor = UIColor.white
        btnQuickService.backgroundColor = UIColor.white
        btnResponsive.backgroundColor = UIColor.white
        
        btnGental.layer.borderWidth = 0
        btnGental.layer.borderColor = UIColor.clear.cgColor
        
        btnProfessional.layer.borderWidth = 1
        btnProfessional.layer.borderColor = UIColor.lightGray.cgColor
        btnQuickService.layer.borderWidth = 1
        btnQuickService.layer.borderColor = UIColor.lightGray.cgColor
        btnResponsive.layer.borderWidth = 1
        btnResponsive.layer.borderColor = UIColor.lightGray.cgColor
        
        likeFeature = "Gental"
    }
    
    @IBAction func tap_responsiveBtn(_ sender: Any) {
        
        btnResponsive.setTitleColor(UIColor.white, for: .normal)
        btnResponsive.backgroundColor = UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00)
        
        btnProfessional.setTitleColor(UIColor.lightGray, for: .normal)
        btnQuickService.setTitleColor(UIColor.lightGray, for: .normal)
        btnGental.setTitleColor(UIColor.lightGray, for: .normal)
        
        btnProfessional.backgroundColor = UIColor.white
        btnQuickService.backgroundColor = UIColor.white
        btnGental.backgroundColor = UIColor.white
        
        btnResponsive.layer.borderWidth = 0
        btnResponsive.layer.borderColor = UIColor.clear.cgColor
        
        btnProfessional.layer.borderWidth = 1
        btnProfessional.layer.borderColor = UIColor.lightGray.cgColor
        btnQuickService.layer.borderWidth = 1
        btnQuickService.layer.borderColor = UIColor.lightGray.cgColor
        btnGental.layer.borderWidth = 1
        btnGental.layer.borderColor = UIColor.lightGray.cgColor
        
        likeFeature = "Responsive"
    }
    
    @IBAction func tap_plus2Btn(_ sender: Any) {
        
        btnPlus1.setImage(UIImage(named: "veryGoodUnselected"), for: .normal)
        btnPlus2.setImage(UIImage(named: "ExcellentSelected"), for: .normal)
        btnMinus1.setImage(UIImage(named: "badUnselected"), for: .normal)
        btnMinus2.setImage(UIImage(named: "veryBadUnselected"), for: .normal)
        btnZero.setImage(UIImage(named: "goodUnselected"), for: .normal)
        
        submittedRating = "5"
        
        lblZero.textColor = UIColor.black
        lblMinus1.textColor = UIColor.black
        lblMinus2.textColor = UIColor.black
        lblPlus1.textColor = UIColor.black
        lblPlus2.textColor = UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00)
        
    }
    
    @IBAction func tap_plus1Btn(_ sender: Any) {
        
        btnPlus1.setImage(UIImage(named: "veryGoodSelected"), for: .normal)
        btnPlus2.setImage(UIImage(named: "ExcellentUnselected"), for: .normal)
        btnMinus1.setImage(UIImage(named: "badUnselected"), for: .normal)
        btnMinus2.setImage(UIImage(named: "veryBadUnselected"), for: .normal)
        btnZero.setImage(UIImage(named: "goodUnselected"), for: .normal)
        
        submittedRating = "4"
        
        lblZero.textColor = UIColor.black
        lblMinus1.textColor = UIColor.black
        lblMinus2.textColor = UIColor.black
        lblPlus1.textColor = UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00)
        
        lblPlus2.textColor = UIColor.black
    }
    
    @IBAction func tap_zeroBtn(_ sender: Any) {
        
        btnPlus1.setImage(UIImage(named: "veryGoodUnselected"), for: .normal)
        btnPlus2.setImage(UIImage(named: "ExcellentUnselected"), for: .normal)
        btnMinus1.setImage(UIImage(named: "badUnselected"), for: .normal)
        btnMinus2.setImage(UIImage(named: "veryBadUnselected"), for: .normal)
        btnZero.setImage(UIImage(named: "goodSelected"), for: .normal)
        
        submittedRating = "3"
        
        lblZero.textColor = UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00)
        
        lblMinus1.textColor = UIColor.black
        lblMinus2.textColor = UIColor.black
        lblPlus1.textColor = UIColor.black
        lblPlus2.textColor = UIColor.black
    }
    
    @IBAction func tap_minus1Btn(_ sender: Any) {
        
        btnPlus1.setImage(UIImage(named: "veryGoodUnselected"), for: .normal)
        btnPlus2.setImage(UIImage(named: "ExcellentUnselected"), for: .normal)
        btnMinus1.setImage(UIImage(named: "badSelected"), for: .normal)
        btnMinus2.setImage(UIImage(named: "veryBadUnselected"), for: .normal)
        btnZero.setImage(UIImage(named: "goodUnselected"), for: .normal)
        
        submittedRating = "2"
        
        lblZero.textColor = UIColor.black
        lblMinus1.textColor = UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00)
        
        lblMinus2.textColor = UIColor.black
        lblPlus1.textColor = UIColor.black
        lblPlus2.textColor = UIColor.black
    }
    
    @IBAction func tap_minus2Btn(_ sender: Any) {
        
        btnPlus1.setImage(UIImage(named: "veryGoodUnselected"), for: .normal)
        btnPlus2.setImage(UIImage(named: "ExcellentUnselected"), for: .normal)
        btnMinus1.setImage(UIImage(named: "badUnselected"), for: .normal)
        btnMinus2.setImage(UIImage(named: "veryBadSelected"), for: .normal)
        btnZero.setImage(UIImage(named: "goodUnselected"), for: .normal)
        
        submittedRating = "1"
        
        lblZero.textColor = UIColor.black
        lblMinus1.textColor = UIColor.black
        lblMinus2.textColor = UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00)
        
        lblPlus1.textColor = UIColor.black
        lblPlus2.textColor = UIColor.black
        
    }
    
}


extension ReviewRatingVC:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if txtViewComment.text == "Give your comment...".localized(){
            
            txtViewComment.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txtViewComment.text == ""{
            
            txtViewComment.text = "Give your comment...".localized()
        }
    }
}


extension ReviewRatingVC:BackToRating{
    
    func statusChange(status: String) {
        
        if self.isComingSub == ""{
            
            if status == "Yes"{
                
                if let status = UserDefaults.standard.value(forKey: "ISCOMIMG_RATINGPOPUP") as? String{
                    
                    print(status)
                    
                    if status == "TRUE_DELIVERY"{
                        
                        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "WORK_TAP_FOR_DELIVERY") , object: nil)
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    }else{
                        
                        NotificationCenter.default.post(name:NSNotification.Name(rawValue: "WORK_TAP_FOR_PROFESSIONAL") , object: nil)
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            
        }
        else{
            
            //we came on this screen from tracking screen
            
            self.navigationController?.popToRootViewController(animated: true)
            
        }
        
    }
    
}


extension ReviewRatingVC{
    
    func checkValidation(){
        
        if isComingFromNew == true {
            
            if txtViewComment.text == "" || txtViewComment.text == "Give your comment...".localized(){
                self.giveRating("")
            }
            else{
                self.giveRating(txtViewComment.text!)
            }
            
        }else{
            
            if ratingPurpuse == ""{
                
                if txtViewComment.text == "" || txtViewComment.text == "Give your comment...".localized(){
                    
                    apiCallForSubmitRating(commentTxt: "")
                }
                else{
                    
                    apiCallForSubmitRating(commentTxt: txtViewComment.text!)
                }
            }
            else{
                
                if txtViewComment.text == "" || txtViewComment.text == "Give your comment...".localized(){
                    
                     self.apiCallForRateToParticularUser(commentTxt: "")
                }
                else{
                    
                     self.apiCallForRateToParticularUser(commentTxt: txtViewComment.text!)
                }
            }

        }
        
        
    }
    
    func apiCallForSubmitRating(commentTxt:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            let param = ["ratingBy":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","ratingMessage":likeFeature,"comments":commentTxt,"rate":submittedRating]
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForSubmitAppRating as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                print(receivedData)
                
                IJProgressView.shared.hideProgressView()
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let alertController = UIAlertController(title: "", message: receivedData.object(forKey: "response_message") as? String ?? "", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            
                           // self.navigationController?.popViewController(animated: true)
                            
                            if self.isComing == "DELIVERY"{
                                
                                self.redirectToDeliveryWorkerScrollManager()
                            }
                            else if self.isComing == "PROFESSIONAL"{
                                
                                self.redirectToProfessionalWorkerScrollManager()
                                
                            }
                            else if self.isComing == "normalDeliveryViaPopup"{
                                
                                self.redirectToNormalDeliveryPastDashboard()
                                
                            }
                            else if self.isComing == "normalPROFESSIONALViaPopup"{
                                
                                self.redirectToNormalProfessionalPastDashboard()
                                
                            }
                            else{
                                
                                self.navigationController?.popViewController(animated: true)
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
    
    
    
    func apiCallForRateToParticularUser(commentTxt:String){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            let param = ["ratingBy":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","ratingMessage":likeFeature,"comments":commentTxt,"rate":submittedRating,"ratingTo":ratingToUserId,"orderId":orderId,"ratingByType":ratingByTypeUser,"ratingToType":ratingToTypeUser,"langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""]
            
            print("PARAM-Values", param)
            
            self.connection.startConnectionWithSting(App.URLs.apiCallForGiveRatingToParticularUser as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                print(receivedData)
                
                IJProgressView.shared.hideProgressView()
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
//                        if self.isComing == "DELIVERY"{
//
//                            self.redirectToDeliveryWorkerScrollManager()
//
//                        }
//
//                        if self.isComing == "PROFESSIONAL"{
//
//                            self.redirectToProfessionalWorkerScrollManager()
//                        }
//
//                        if self.isComing == "normalPROFESSIONAL"{
//
//                            if self.screenName == "past"{
//
//                                self.navigationController?.popViewController(animated: true)
//                            }
//                            else{
//
//
//                            }
//                        }
//                        else{
//
//                            let vc = ScreenManager.getPopupVC()
//                            vc.navObj = self
//                            vc.isComing = self.isComing
//                            vc.controllerName = "RatingReview"
//                            vc.delegate = self
//                            self.present(vc, animated: true, completion: nil)
//                        }
                        
                        
                        if self.isComing == "DELIVERY"{
                            
                            self.redirectToDeliveryWorkerScrollManager()
                        }
                        else if self.isComing == "PROFESSIONAL"{
                            
                            self.redirectToProfessionalWorkerScrollManager()
                            
                        }
                        else if self.isComing == "normalDeliveryViaPopup"{
                            
                            self.redirectToNormalDeliveryPastDashboard()
                            
                        }
                        else if self.isComing == "normalPROFESSIONALViaPopup"{
                            
                            self.redirectToNormalProfessionalPastDashboard()
                            
                        }
                        else{
                            
                            self.navigationController?.popViewController(animated: true)
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
 
    
    func giveRating(_ commentTxt:String){
       
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        
        let param = ["userId": UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                     "langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,
                     "resAndStoreId": self.resAndStoreId,
                     "rating":submittedRating,
                     "review":commentTxt,
                     "orderId":self.orderId] as [String:Any]
        
        print("---- Res Store Rating -----",param,header)
        
        
        viewModel.resAndStoreRatingAPI(Domain.baseUrl().appending(APIEndpoint.resAndStoreRating), param: param, header: header)
        closureSetup()
        
    }
    
    
    func closureSetup(){
        
        /*
        viewModel.reloadList = { () in
        }
        */
        
        viewModel.success = { message in
            
            let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
            
            let buttonOK = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
                self.backFromDelegate?.backFromRating(true)
                self.navigationController?.popViewController(animated: true)

            }
            
            alertController.addAction(buttonOK)
            self.present(alertController, animated: true, completion: nil)
            
            
        }
    }
    
    
}
