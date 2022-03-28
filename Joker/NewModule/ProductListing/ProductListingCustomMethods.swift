//
//  ProductListingCustomMethods.swift
//  Joker
//
//  Created by User on 24/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation


//// New code

extension ProductListingNew_VC{
    
    //TODO: Register Nib method
    internal func registerNib(){
        
        productListArr = self.viewModel.productBaseModelArr.first?.Data?.productList
        self.tblView.tableFooterView = UIView()
        self.tblView.register(UINib(nibName: "CartTableViewCellAndXib", bundle: nil), forCellReuseIdentifier: "CartTableViewCellAndXib")
        tblView.dataSource = self
        tblView.delegate = self
        tblView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tblView.reloadData()
        
    }
  
    func makeRootToLoginSignup(){
        
        let vc = ScreenManager.getSignInSignupVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    //TODO: Alert Action
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


extension ProductListingNew_VC : UpdateCartCountProtocol{
    
    func getCountCart(_ flag: Bool) {
        self.getCountV()
    }
      
}
