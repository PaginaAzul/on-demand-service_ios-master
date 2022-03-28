//
//  MyCaptionScrollManagerVC.swift
//  Joker
//
//  Created by Callsoft on 31/01/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class MyCaptionScrollManagerVC: UIViewController {

    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var btnDeliveryMan: UIButton!
    
    @IBOutlet weak var btnProfessional: UIButton!
    
    
    var signupUserType = ""
    
    var indexItemWillSelect = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        intialSetUp()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        if signupUserType != ""{
            
            if signupUserType == "Delivery"{
                
                btnDeliveryMan.setTitleColor(UIColor.white, for: .normal)
                btnProfessional.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
                
                ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 0 * self.view.frame.width, y: 0), andScrollView: self.scrollview, andAnimationMargin: 0)
            }
            else{
                
                btnProfessional.setTitleColor(UIColor.white, for: .normal)
                btnDeliveryMan.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
                
                ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 1 * self.view.frame.width, y: 0), andScrollView: self.scrollview, andAnimationMargin: 0)
                
            }
        }
        else{
            
            //// redirect to particular index of profile
            
            if indexItemWillSelect == 0{
                
                btnDeliveryMan.setTitleColor(UIColor.white, for: .normal)
                btnProfessional.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
                
                ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 0 * self.view.frame.width, y: 0), andScrollView: self.scrollview, andAnimationMargin: 0)
                
            }
            else{
                
                btnProfessional.setTitleColor(UIColor.white, for: .normal)
                btnDeliveryMan.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
                
                ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 1 * self.view.frame.width, y: 0), andScrollView: self.scrollview, andAnimationMargin: 0)
                
            }
            
        }
        
    }
    
    
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_deliveryPerson(_ sender: Any) {
        
        
        if self.signupUserType == "" || self.signupUserType == "Delivery"{
            
            btnDeliveryMan.setTitleColor(UIColor.white, for: .normal)
            btnProfessional.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
            
            ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 0 * self.view.frame.width, y: 0), andScrollView: self.scrollview, andAnimationMargin: 0)
        }
        else{
            
            self.alertWithAction(message: "You are not registered as delivery worker. Do you want to register as delivery worker?", type: "Delivery")
        }
     
    }
    
    @IBAction func tap_professionalBtn(_ sender: Any) {
        
        if self.signupUserType == "" || self.signupUserType == "Professional"{
            
            btnProfessional.setTitleColor(UIColor.white, for: .normal)
            btnDeliveryMan.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
            
            ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 1 * self.view.frame.width, y: 0), andScrollView: self.scrollview, andAnimationMargin: 0)
        }
        else{
            
            self.alertWithAction(message: "You are not registered as professional worker. Do you want to register as professional worker?", type: "Professional")
        }
       
    }
    
    
    func alertWithAction(message:String,type:String){
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            if type == "Delivery"{
                
                let vc = ScreenManager.getBecomeADeliveryPersonVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                
                let vc = ScreenManager.getBecomeAProfessionalWorkerVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

}


extension MyCaptionScrollManagerVC{
    
    func intialSetUp()
    {
        self.scrollview.contentSize = CGSize(width: 2*self.view.frame.width,height: self.scrollview.frame.height);
        
        
        self.addChildViewController(ScreenManager.getMyCaptionProfileVC())
        self.addChildViewController(ScreenManager.getMyCaptionProfile2VC())
      
      //  let panGesture = UIPanGestureRecognizer(target: self, action: #selector(FoodieScrollManagerViewController.scrollViewOnPressingPanGeture(panGesture:)))
     //   self.scrollview.addGestureRecognizer(panGesture)
        
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
    
    
}
