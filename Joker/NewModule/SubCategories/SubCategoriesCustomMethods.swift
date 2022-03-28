//
//  SubCategoriesCustomMethods.swift
//  Joker
//
//  Created by User on 24/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation

//MARK: - Custom Methods
//TODO:
extension SubCategoriesVC {
    
    //TODO: - InitalSetup
    func initialSetup(){
        lblHeader.text = "Sub Categories".localized()
        txtSearch.text = "Search by subcategories".localized()
        txtSearch.delegate = self
    }
    
    
    //TODO:- Navigate On Login Screen
    func makeRootToLoginSignup(){
        
        let vc = ScreenManager.getSignInSignupVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    //TODO:- Alert Pop Up
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
    
    
}
