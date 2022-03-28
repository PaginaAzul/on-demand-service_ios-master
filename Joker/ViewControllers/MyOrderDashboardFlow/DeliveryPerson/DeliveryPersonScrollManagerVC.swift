//
//  DeliveryPersonScrollManagerVC.swift
//  Joker
//
//  Created by Callsoft on 02/02/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class DeliveryPersonScrollManagerVC: UIViewController {

    
    @IBOutlet weak var scrollviw: UIScrollView!
    
    @IBOutlet weak var pastBtn: UIButton!
    
    @IBOutlet weak var activeBtn: UIButton!
    
    @IBOutlet weak var pendingBtn: UIButton!
    
    @IBOutlet weak var newBtn: UIButton!
    
    @IBOutlet weak var lblNav: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var weNeedToFreezeTheActiveOrder = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.withdrawRequestAcceptedByNormalDelivery), name: NSNotification.Name(rawValue: "WithdrawRequesteAcceptedByNormalDelivery"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.freezeActiveOrderBasedOnActiveData), name: NSNotification.Name(rawValue: "FreezeStatusOfDeliveryWorker"), object: nil)
        
        intialSetUp()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if UserDefaults.standard.bool(forKey: "ActiveRedirectionOfDeliveryWorker"){
            
            UserDefaults.standard.set(false, forKey: "ActiveRedirectionOfDeliveryWorker")
            
            activeBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            pendingBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
            newBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
            pastBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
            
            self.pendingBtn.isUserInteractionEnabled = false
            self.newBtn.isUserInteractionEnabled = false
            self.pastBtn.isUserInteractionEnabled = false
            
            ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 2 * self.view.frame.width, y: 0), andScrollView: self.scrollviw, andAnimationMargin: 0)
            
        }
        else if UserDefaults.standard.bool(forKey: "PastRedirectionOfDeliveryWorker"){
            
            UserDefaults.standard.set(false, forKey: "PastRedirectionOfDeliveryWorker")
            
            pastBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            pendingBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
            newBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
            activeBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
            
            ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 3 * self.view.frame.width, y: 0), andScrollView: self.scrollviw, andAnimationMargin: 0)
            
        }
        else{
            
            
        }
        
        
        if self.weNeedToFreezeTheActiveOrder == "yes"{
                        
            self.pendingBtn.isUserInteractionEnabled = false
            self.newBtn.isUserInteractionEnabled = false
            self.pastBtn.isUserInteractionEnabled = false
            
            activeBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            pendingBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
            newBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
            pastBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
            
            ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 2 * self.view.frame.width, y: 0), andScrollView: self.scrollviw, andAnimationMargin: 0)
            
        }
        
    }
    
    
    @IBAction func tap_backbtn(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "RootApply"){
            
            UserDefaults.standard.set(false, forKey: "RootApply")
            
            let vc = ScreenManager.getServiceProviderMapVC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navController
            appDelegate.window?.makeKeyAndVisible()
            
        }
        else{
            
            self.navigationController?.popViewController(animated: true)
        }
       
    }
    
    @IBAction func tap_newBtn(_ sender: Any) {
        newBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        pendingBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        activeBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        pastBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        
        ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 0 * self.view.frame.width, y: 0), andScrollView: self.scrollviw, andAnimationMargin: 0)
    }
    
    @IBAction func tap_pendingBtn(_ sender: Any) {
        pendingBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        newBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        activeBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        pastBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        
        ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 1 * self.view.frame.width, y: 0), andScrollView: self.scrollviw, andAnimationMargin: 0)
    }
    
    @IBAction func tap_activeBtn(_ sender: Any) {
        activeBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        pendingBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        newBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        pastBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        
        ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 2 * self.view.frame.width, y: 0), andScrollView: self.scrollviw, andAnimationMargin: 0)
    }
    
    @IBAction func tap_pastBtn(_ sender: Any) {
        pastBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        pendingBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        newBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        activeBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        
        ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 3 * self.view.frame.width, y: 0), andScrollView: self.scrollviw, andAnimationMargin: 0)
    }
    
    @objc func sendToNewScreenVC(_ notification:Notification) {
        newBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        pendingBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        activeBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        pastBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        
        ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 0 * self.view.frame.width, y: 0), andScrollView: self.scrollviw, andAnimationMargin: 0)
    }
    
    @objc func sendToPendingVC(_ notification:Notification) {
        pendingBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        newBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        activeBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        pastBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        
        ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 1 * self.view.frame.width, y: 0), andScrollView: self.scrollviw, andAnimationMargin: 0)
    }
    
    
    
    @objc func withdrawRequestAcceptedByNormalDelivery(){
        
        UserDefaults.standard.set(true, forKey: "RootApply")
        
        let vc = ScreenManager.getDeliveryPersonScrollManagerVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    
    //send to active screen if we are on dashboard and getting notification for
    
    @objc func freezeActiveOrderBasedOnActiveData(){
        
        self.pendingBtn.isUserInteractionEnabled = false
        self.newBtn.isUserInteractionEnabled = false
        self.pastBtn.isUserInteractionEnabled = false
        
        activeBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        pendingBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        newBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        pastBtn.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        
        ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 2 * self.view.frame.width, y: 0), andScrollView: self.scrollviw, andAnimationMargin: 0)
    }
    
}



extension DeliveryPersonScrollManagerVC{
    
    func intialSetUp()
    {
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendToNewScreenVC(_:)), name: NSNotification.Name(rawValue: "YES_TAP_FOR_DELIVERY"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendToPendingVC(_:)), name: NSNotification.Name(rawValue: "WORK_TAP_FOR_DELIVERY"), object: nil)
        
        self.scrollviw.contentSize = CGSize(width: 4*self.view.frame.width,height: self.scrollviw.frame.height);
        
        self.addChildViewController(ScreenManager.getDeliveryPersonNewVC())
        self.addChildViewController(ScreenManager.getDeliveryPersonPendingVC())
        self.addChildViewController(ScreenManager.getDeliveryPersonActiveVC())
        self.addChildViewController(ScreenManager.getDeliveryPersonPastVC())
        
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
            
            var frame: CGRect  = self.scrollviw.frame
            frame.origin.x = self.view.frame.width*CGFloat(page)
            frame.origin.y = 0;
            viewController?.view.frame = frame;
            self.scrollviw.addSubview(viewController!.view);
        }
    }
    
    
}
