//
//  SignInSignUPVC.swift
//  Joker
//
//  Created by Apple on 18/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SignInSignUPVC: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var signInBtn: UIButton!
    
    @IBOutlet weak var btnSignup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       intialise()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        signInBtn.setTitle("SignIn".localized(), for: .normal)
        btnSignup.setTitle("SignUp".localized(), for: .normal)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tap_SignInBtn(_ sender: UIButton) {
      
        
        
        let vc = ScreenManager.getSignInVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_SignUpBtn(_ sender: UIButton) {
      
        let vc = ScreenManager.getSignupVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension SignInSignUPVC{
    
    func intialise()
    {
        headerView.backgroundColor = UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00)
        
        signInBtn.backgroundColor = UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00)
        
    }
    
}

