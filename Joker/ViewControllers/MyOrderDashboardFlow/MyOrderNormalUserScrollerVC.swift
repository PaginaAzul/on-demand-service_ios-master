//
//  MyOrderNormalUserScrollerVC.swift
//  Joker
//
//  Created by Callsoft on 02/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class MyOrderNormalUserScrollerVC: UIViewController {

    @IBOutlet weak var btnPast: UIButton!
    
    @IBOutlet weak var btnActive: UIButton!
    
    @IBOutlet weak var btnPending: UIButton!
    
    @IBOutlet weak var btnNew: UIButton!
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var btnHelp: UIButton!

    
    var controllerPurpuse = ""
    
    var redirectStatus = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
       intialSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if UserDefaults.standard.bool(forKey: "SendToPastSection"){
            
            UserDefaults.standard.set(false, forKey: "SendToPastSection")
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "MyOrderSecondIndexSelected"){
            
            UserDefaults.standard.set(false, forKey: "MyOrderSecondIndexSelected")
            
            btnActive.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            btnPending.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
            btnNew.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
            btnPast.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
            ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 1 * self.view.frame.width, y: 0), andScrollView: self.scrollview, andAnimationMargin: 0)
            
        }
        else if UserDefaults.standard.bool(forKey: "EnabledPastTabInitiallyForNormalDelivery"){
            
            UserDefaults.standard.set(false, forKey: "EnabledPastTabInitiallyForNormalDelivery")
            
            btnPast.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            btnPending.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
            btnNew.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
            btnActive.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
            ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 2 * self.view.frame.width, y: 0), andScrollView: self.scrollview, andAnimationMargin: 0)
            
        }
        else{
            
            
        }
        
    }
    
    @IBAction func tap_Help(_ sender: Any) {
        let vc = ScreenManager.getContactUsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_menuBtn(_ sender: Any) {
        
//        UserDefaults.standard.set(false, forKey: "NewRedirectionDelivery")
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
    

    @IBAction func tap_newBtn(_ sender: Any) {
        
        btnNew.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        btnPending.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        btnActive.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        btnPast.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
//        let vc = ScreenManager.getDeliveryPersonGoOrderVC()
//        self.navigationController?.pushViewController(vc, animated: true)
        
       // self.navigationController?.popViewController(animated: true)
        
        
        if redirectStatus == "Seprated"{
            
            let vc = ScreenManager.getMapWithServicesSepratedVC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navController
            appDelegate.window?.makeKeyAndVisible()
        }
        else{
            
            UserDefaults.standard.set(true, forKey: "NewRedirectionDelivery")
            
            let vc = ScreenManager.getNormalUserMapOrderDashboardVC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navController
            appDelegate.window?.makeKeyAndVisible()
          
        }
     
    }
    
    @IBAction func tap_pendingBtn(_ sender: Any) {
        btnPending.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        btnNew.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        btnActive.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        btnPast.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 0 * self.view.frame.width, y: 0), andScrollView: self.scrollview, andAnimationMargin: 0)
    }
    
    @IBAction func tap_activeBtn(_ sender: Any) {
        btnActive.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        btnPending.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        btnNew.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        btnPast.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 1 * self.view.frame.width, y: 0), andScrollView: self.scrollview, andAnimationMargin: 0)
        
    }
    @IBAction func tap_pastBtn(_ sender: Any) {
        btnPast.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        btnPending.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        btnNew.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        btnActive.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 2 * self.view.frame.width, y: 0), andScrollView: self.scrollview, andAnimationMargin: 0)
    }
    
    
    @IBAction func tap_deliveryBtn(_ sender: Any) {
        
        
    }
    
    @IBAction func tap_professionalBtn(_ sender: Any) {
        
        let vc = ScreenManager.getNormalUserWithProfessionalWorkerScrollerVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
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
    
    @IBAction func tap_notificationsBtn(_ sender: Any) {
        
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
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            let vc = ScreenManager.getMapWithServicesSepratedVC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navController
            appDelegate.window?.makeKeyAndVisible()
        }
        else{
            
            self.alertWithAction()
        }
        
      
    }
    
}



extension MyOrderNormalUserScrollerVC{
    
    func intialSetUp()
    {
        self.scrollview.contentSize = CGSize(width: 3*self.view.frame.width,height: self.scrollview.frame.height);
        
        self.addChildViewController(ScreenManager.getMyOrderNoralUserPendingVC())
        self.addChildViewController(ScreenManager.getMyOrderNoralUserActiveVC())
        self.addChildViewController(ScreenManager.getMyOrderNoralUserPastVC())
      
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
        
        UserDefaults.standard.set(true, forKey: "SpecificRootToService")
        
        let vc = ScreenManager.getSignInSignupVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
}
