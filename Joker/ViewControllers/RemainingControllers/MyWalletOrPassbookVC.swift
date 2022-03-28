//
//  MyWalletOrPassbookVC.swift
//  Joker
//
//  Created by abc on 23/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class MyWalletOrPassbookVC: UIViewController {

    @IBOutlet weak var btnNormalUser: UIButton!
    @IBOutlet weak var btnProfessional: UIButton!
    
    @IBOutlet weak var btnDeliveryMan: UIButton!
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        intialSetUp()
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tap_deliveryMan(_ sender: Any) {
        
        ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 2 * self.view.frame.width, y: 0), andScrollView: self.scrollview, andAnimationMargin: 0)
        
        btnNormalUser.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        btnProfessional.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        btnDeliveryMan.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func tap_professional(_ sender: Any) {
        
        ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 1 * self.view.frame.width, y: 0), andScrollView: self.scrollview, andAnimationMargin: 0)
        
        btnNormalUser.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        btnProfessional.setTitleColor(UIColor.white, for: .normal)
        btnDeliveryMan.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
    }
    
    @IBAction func tap_normalUser(_ sender: Any) {
        
        ScreenManager.animateScrollViewHorizontally(destinationPoint: CGPoint(x: 0 * self.view.frame.width, y: 0), andScrollView: self.scrollview, andAnimationMargin: 0)
        
        btnNormalUser.setTitleColor(UIColor.white, for: .normal)
        btnProfessional.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
        btnDeliveryMan.setTitleColor(#colorLiteral(red: 0.537254902, green: 0.3254901961, blue: 0.7098039216, alpha: 1), for: .normal)
    }
    
}


extension MyWalletOrPassbookVC{
    
    func intialSetUp()
    {
        self.scrollview.contentSize = CGSize(width: 3*self.view.frame.width,height: self.scrollview.frame.height);
        
        
//        self.addChildViewController(ScreenManager.getWalletPassbookNormalVC())
//        self.addChildViewController(ScreenManager.getWalletPassbookProfessionalVC())
//        self.addChildViewController(ScreenManager.getWalletPassbookDeliveryPersonVC())
        
        self.addChildViewController(ScreenManager.getWalletPassbookNormalVC())
        self.addChildViewController(ScreenManager.getWalletPassbookDeliveryPersonVC())
        self.addChildViewController(ScreenManager.getWalletPassbookProfessionalVC())
        
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




