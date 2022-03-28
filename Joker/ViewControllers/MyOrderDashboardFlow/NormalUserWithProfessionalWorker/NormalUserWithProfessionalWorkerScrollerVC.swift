//
//  NormalUserWithProfessionalWorkerScrollerVC.swift
//  Joker
//
//  Created by Callsoft on 02/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class NormalUserWithProfessionalWorkerScrollerVC: UIViewController {

    
    @IBOutlet weak var notificationBottomVw: UIView!
    @IBOutlet weak var btnNew: UIButton!
    
    @IBOutlet weak var btnPending: UIButton!
    
    @IBOutlet weak var btnActive: UIButton!
    
    @IBOutlet weak var btnPast: UIButton!
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var btnHome: UIButton!
    
    @IBOutlet weak var btnMyOrder: UIButton!
    
    @IBOutlet weak var btnNotification: UIButton!
    
    @IBOutlet weak var btnProfile: UIButton!
    
    @IBOutlet weak var lblNav: UILabel!
    
    @IBOutlet weak var btnHelp: UIButton!

    @IBOutlet weak var lblTabHome: UILabel!
    @IBOutlet weak var lblTabMyOrder: UILabel!
    @IBOutlet weak var lblTabNoti: UILabel!
    @IBOutlet weak var lblTabProfile: UILabel!
    @IBOutlet weak var lblTabHelp: UILabel!
    
    
    var controllerPurpuse = ""
    
    var redirectStatus = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnNew.isHidden = true
        
        intialSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        notificationBottomVw.isHidden = true
        lblNav.text = "My Order's Dashboard".localized()
        
        if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
            
            lblTabHome.text = "Home".localized()
            lblTabMyOrder.text = "My Order".localized()
            lblTabNoti.text = "Notifications".localized()
            lblTabProfile.text = "Profile".localized()
            lblTabHelp.text = "Help".localized()
            
            /*
            btnHome.setImage(UIImage(named: "HomeUnselectedLang"), for: .normal)
            btnMyOrder.setImage(UIImage(named: "OrderSelectedLang"), for: .normal)
            btnNotification.setImage(UIImage(named: "NotificationUnselectedLang"), for: .normal)
            btnProfile.setImage(UIImage(named: "ProfileUnselectedLang"), for: .normal)
            */
        }
        else{
            
            lblTabHome.text = "Home".localized()
            lblTabMyOrder.text = "My Order".localized()
            lblTabNoti.text = "Notifications".localized()
            lblTabProfile.text = "Profile".localized()
            lblTabHelp.text = "Help".localized()
            
            /*
            btnHome.setImage(UIImage(named: "shopsUnselected"), for: .normal)
            btnMyOrder.setImage(UIImage(named: "myOrderSelected"), for: .normal)
            btnNotification.setImage(UIImage(named: "notificationsUnselected"), for: .normal)
            btnProfile.setImage(UIImage(named: "captainUnselected"), for: .normal)
            */
        }
        
        btnPending.setTitle("Pending".localized(), for: .normal)
        btnActive.setTitle("Active".localized(), for: .normal)
        btnPast.setTitle("Past".localized(), for: .normal)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "MyOrderSecondIndexSelectedProfessionalTab"){
            
            UserDefaults.standard.set(false, forKey: "MyOrderSecondIndexSelectedProfessionalTab")
            
            btnActive.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            btnPending.setTitleColor(UIColor.darkGray, for: .normal)
            btnNew.setTitleColor(UIColor.darkGray, for: .normal)
            btnPast.setTitleColor(UIColor.darkGray, for: .normal)
            ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 1 * self.view.frame.width, y: 0), andScrollView: self.scrollview, andAnimationMargin: 0)
            
        }
        else if UserDefaults.standard.bool(forKey: "EnabledPastTabInitiallyForNormalProfessional"){
            
            UserDefaults.standard.set(false, forKey: "EnabledPastTabInitiallyForNormalProfessional")
            
            btnPast.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            btnPending.setTitleColor(UIColor.darkGray, for: .normal)
            btnNew.setTitleColor(UIColor.darkGray, for: .normal)
            btnActive.setTitleColor(UIColor.darkGray, for: .normal)
            ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 2 * self.view.frame.width, y: 0), andScrollView: self.scrollview, andAnimationMargin: 0)
        }
        else{
            
            
        }
    }
    
    @IBAction func tap_Help(_ sender: Any) {
            let vc = ScreenManager.getContactUsVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    
    @IBAction func tap_pastBtn(_ sender: Any) {
        btnPast.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        btnPending.setTitleColor(UIColor.darkGray, for: .normal)
        btnNew.setTitleColor(UIColor.darkGray, for: .normal)
        btnActive.setTitleColor(UIColor.darkGray, for: .normal)
         ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 2 * self.view.frame.width, y: 0), andScrollView: self.scrollview, andAnimationMargin: 0)
    }
    
    @IBAction func tap_activeBtn(_ sender: Any) {
        btnActive.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        btnPending.setTitleColor(UIColor.darkGray, for: .normal)
        btnNew.setTitleColor(UIColor.darkGray, for: .normal)
        btnPast.setTitleColor(UIColor.darkGray, for: .normal)
         ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 1 * self.view.frame.width, y: 0), andScrollView: self.scrollview, andAnimationMargin: 0)
    }
    
    @IBAction func tap_btnPending(_ sender: Any) {
        btnPending.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        btnNew.setTitleColor(UIColor.darkGray, for: .normal)
        btnActive.setTitleColor(UIColor.darkGray, for: .normal)
        btnPast.setTitleColor(UIColor.darkGray, for: .normal)
        ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 0 * self.view.frame.width, y: 0), andScrollView: self.scrollview, andAnimationMargin: 0)
    }
    
    @IBAction func tap_btnNew(_ sender: Any) {
        btnNew.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        btnPending.setTitleColor(UIColor.darkGray, for: .normal)
        btnActive.setTitleColor(UIColor.darkGray, for: .normal)
        btnPast.setTitleColor(UIColor.darkGray, for: .normal)
        
        
        UserDefaults.standard.set("", forKey: "RequestDeliveryID")
        let vc = ScreenManager.getPrfessionalWorkerGoOrderVC()
        vc.comingFrom = "ServiceProviderMap"
        self.navigationController?.pushViewController(vc, animated: true)
        
        
//        if redirectStatus == "Seprated"{
//
//            let vc = ScreenManager.getMapWithServicesSepratedVC()
//            let navController = UINavigationController(rootViewController: vc)
//            navController.navigationBar.isHidden = true
//            appDelegate.window?.rootViewController = navController
//            appDelegate.window?.makeKeyAndVisible()
//        }
//        else{
//
//            UserDefaults.standard.set(true, forKey: "NewRedirectionProfessional")
//
//            let vc = ScreenManager.getNormalUserMapOrderDashboardVC()
//            let navController = UINavigationController(rootViewController: vc)
//            navController.navigationBar.isHidden = true
//            appDelegate.window?.rootViewController = navController
//            appDelegate.window?.makeKeyAndVisible()
//        }
      
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
//        UserDefaults.standard.set(false, forKey: "NewRedirectionProfessional")
//
//        if controllerPurpuse == "Push"{
//
//            let vc = ScreenManager.getNormalUserMapOrderDashboardVC()
//            let navController = UINavigationController(rootViewController: vc)
//            navController.navigationBar.isHidden = true
//            appDelegate.window?.rootViewController = navController
//            appDelegate.window?.makeKeyAndVisible()
//        }
//        else{
//
//            self.navigationController?.popViewController(animated: true)
//        }
       
        let vc = ScreenManager.getMoreVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func tap_deliveryBtn(_ sender: Any) {
        
        let vc = ScreenManager.getMyOrderNoralUserScrollerVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    
    @IBAction func tap_professionalBtn(_ sender: Any) {
        
        //don't do anything
    }
    
    @IBAction func tap_shopsBtn(_ sender: Any) {
        
        let vc = ScreenManager.getServiceProviderMapVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func tap_myOrdersBtn(_ sender: Any) {
        
        
    }
    
    @IBAction func tap_bottomNotificationsBtn(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            let vc = ScreenManager.getNotificationVC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navController
            appDelegate.window?.makeKeyAndVisible()
            
        }
        else{
            
            self.alertWithAction()
        }
    }
    
    @IBAction func tap_captainsBtn(_ sender: Any) {
        
        let vc = ScreenManager.getMapWithServicesSepratedVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    
}


extension NormalUserWithProfessionalWorkerScrollerVC{
    
    func intialSetUp()
    {
        self.scrollview.contentSize = CGSize(width: 3*self.view.frame.width,height: self.scrollview.frame.height);
        
        self.addChildViewController(ScreenManager.getNoramlUserProfessionalPendingVC())
        self.addChildViewController(ScreenManager.getNormalUserProfessionalActiveVC())
        self.addChildViewController(ScreenManager.getNormalUserProfessionalPastVC())
        
        self.loadScrollView()
    }
    
    func loadScrollView ()
    {
        print(self.childViewControllers)
        for index in 0 ..< self.childViewControllers.count
        {
            self.loadScrollViewWithPage(index);
        }
    }
    
    func loadScrollViewWithPage(_ page : Int) -> Void
    {
        if(page < 0)
        {
            return
        }
        if page >= self.childViewControllers.count
        {
            return
        }
        let viewController: UIViewController? = (self.childViewControllers as NSArray).object(at: page) as? UIViewController
        if(viewController == nil)
        {
            return
        }
        if(viewController?.view.superview == nil){
            
            var frame: CGRect  = self.scrollview.frame
            frame.origin.x = self.view.frame.width*CGFloat(page)
            frame.origin.y = 0;
            viewController?.view.frame = frame;
            self.scrollview.addSubview(viewController!.view);
        }
    }
    
    
    func alertWithAction(){
        
        let alertController = UIAlertController(title: "", message: "You are not logged in. Please login/signup before proceeding further.".localized(), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            self.makeRootToLoginSignup()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func makeRootToLoginSignup(){
        
        let vc = ScreenManager.getSignInSignupVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    
}
