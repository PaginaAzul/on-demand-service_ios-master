//
//  MyOrderOngoing + API.swift
//  Joker
//
//  Created by User on 21/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation


extension MyOrderOngoingVC {
    
    func getOrder(_ type:String){
        
        IJProgressView.shared.showProgressView(view: commonController.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
            
            let param = ["userId": UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                         "type":type ,  "langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ] as [String:Any]
            
            print(header , param)
            
            viewModel.getOrderAPI(Domain.baseUrl().appending(APIEndpoint.getUserOrder), param, header)
            self.closureSetup()
        }
      
        
    }
    
    
    func closureSetup(){
       
        viewModel.reloadList = {() in
            
            if ((self.viewModel.getOrderRootArray.first?.Data?.count ?? 0) > 0) {
                
                self.noDataFound.isHidden = true
                self.registerNib()
             
                self.tblViewHome.delegate = self
                self.tblViewHome.dataSource = self
                self.tblViewHome.reloadData()
                
            }else{
                
                self.noDataFound.isHidden = false

                self.tblViewHome.reloadData()

            }
        }
        
        viewModel.cartCount = {(count , type) in
             setBage(self.btnCart, "\(count)")
        }
        
        
        viewModel.errorMessage = { (message) in
            print(message)
            //CommonClass.sharedInstance.callNativeAlert(title: "", message: message, controller: self)
        }
        
    }
    
    
    func getCountV(){
        
        let param = ["userId" : UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
        viewModel.getCartCountAPI(Domain.baseUrl().appending(APIEndpoint.getCartCount), param)
        self.closureSetup()
        
    }
    
    
   @objc func updateCancelOrder(_ sender:UIButton){
        
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        
    
        let param = ["userId" : UserDefaults.standard.value(forKey: "UserID") as? String ?? "", "langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,
                     "orderId": self.viewModel.getOrderRootArray.first?.Data?[sender.tag].orderNumber ?? 0 ,
                     "cancelStatus":true] as [String : Any]
        
    
    print("param",param)
    
        viewModel.updateCancelStatusAPI(Domain.baseUrl().appending(APIEndpoint.updateCancelStatus), param, header)
        self.closureSetup()
        
    }
    
    
    func reOrder(_ param:[String:Any]){
        
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
    
        viewModel.reOrder_API(Domain.baseUrl().appending(APIEndpoint.reOrder), param: param, header: header)
        
        viewModel.reloadList = {() in
            
          let vc = ScreenManager.MyCartNew_VC()
          self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        viewModel.errorMessage = { (message) in
            print(message)
            CommonClass.sharedInstance.callNativeAlert(title: "", message: message, controller: self)
        }

        
        
    }
    
    
 
}
