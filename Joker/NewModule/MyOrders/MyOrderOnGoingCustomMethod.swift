//
//  MyOrderOnGoingCustomMethod.swift
//  JustBite
//
//  Created by Aman on 16/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import Foundation
import UIKit

//MARK: Custom Methods and Target Methods
extension MyOrderOngoingVC{
    
    //TODO: Initial Setup
    internal func initialSetup(){
        
        UserDefaults.standard.set("Food", forKey: "Food")
        
        updateUI()
        
        if isComingFromSideBar == true {
            bottomView.isHidden = true
        }else{
            bottomView.isHidden = false
        }
        
    }
    
    //TODO: Update UI
    fileprivate func updateUI(){
        
        hideKeyboardWhenTappedAround()
        tblViewHome.backgroundColor = AppColor.whiteColor
        
        viewBtn.layer.cornerRadius = 10.0
        viewBtn.clipsToBounds = true
        CommonClass.sharedInstance.provideCustomBorder(btnRef: viewBtn)
        
        btnOnGoingRef.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!
        btnOnGoingRef.setTitleColor(AppColor.placeHolderColor, for: .normal)
        btnOnGoingRef.backgroundColor = AppColor.whiteColor
        btnOnGoingRef.setTitle("Ongoing".localized(), for: .normal)
        
        btnUpcoming.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!
        
        btnUpcoming.setTitleColor(AppColor.placeHolderColor, for: .normal)
        btnUpcoming.backgroundColor = AppColor.whiteColor
        btnUpcoming.setTitle("Upcoming".localized(), for: .normal)
        
        btnPreviousRef.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!
        btnPreviousRef.setTitleColor(AppColor.whiteColor, for: .normal)
        btnPreviousRef.backgroundColor = AppColor.themeColor
        btnPreviousRef.setTitle("Past".localized(), for: .normal)
        
        registerNib()
                
        
    }
    
    
    
    //TODO: Register Nib method
    internal func registerNib(){
        
        self.tblViewHome.register(UINib(nibName:  "InnerTableViewCell", bundle: nil), forCellReuseIdentifier:  "InnerTableViewCell")
        self.tblViewHome.delegate = self
        self.tblViewHome.dataSource = self
        self.tblViewHome.reloadData()
    }
    
    func makeRootToLoginSignup(){
        
        let vc = ScreenManager.getSignInSignupVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    //TODO: Show Alert
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
    
    //TODO: Target Method ViewMore Button
    ///Expand section table cells
    @objc func btnViewMore(sender:UIButton){
        
        if btnTag == 1{
            if isExpandViewMore == 2 {
                isExpandViewMore = 1
            }else{
                isExpandViewMore = 2
            }
            
            self.tblViewHome.reloadData()
        }
        else if btnTag == 2{
            
            if isExpandViewMore == 2 {
                isExpandViewMore = 1
            }else{
                isExpandViewMore = 2
            }
            
            self.tblViewHome.reloadData()
        }
        else{
            if isExpandViewMore == 2 {
                isExpandViewMore = 1
            }else{
                isExpandViewMore = 2
            }
            self.tblViewHome.reloadData()
        }
        
    }
    
    //TODO: Target Method Expand Section
    ///Expand section of UITableView
    @objc func tapSectionBtn(sender:UIButton){
        if btnTag == 1{
            
            if self.viewModel.getOrderRootArray.first?.Data?[sender.tag].isSelected == true {
                self.viewModel.getOrderRootArray[0].Data?[sender.tag].changeIsSelected(false)
            }else {
                self.viewModel.getOrderRootArray[0].Data?[sender.tag].changeIsSelected(true)
            }
            
        }
        else if btnTag == 2{
            
            if self.viewModel.getOrderRootArray.first?.Data?[sender.tag].isSelected == true {
                self.viewModel.getOrderRootArray[0].Data?[sender.tag].changeIsSelected(false)
            }else {
                self.viewModel.getOrderRootArray[0].Data?[sender.tag].changeIsSelected(true)
            }
            
        }
        else{
            
            if self.viewModel.getOrderRootArray.first?.Data?[sender.tag].isSelected == true {
                self.viewModel.getOrderRootArray[0].Data?[sender.tag].changeIsSelected(false)
            }else {
                self.viewModel.getOrderRootArray[0].Data?[sender.tag].changeIsSelected(true)
            }
            
        }
        
        isExpandViewMore = 1
        
        /*
        UIView.setAnimationsEnabled(false)
        self.tblViewHome.beginUpdates()
        self.tblViewHome.reloadSections(NSIndexSet(index: sender.tag) as IndexSet, with: UITableViewRowAnimation.none)
        self.tblViewHome.endUpdates()
        */
        
        self.tblViewHome.reloadData()
        
        
        }
    
    //TODO: Target Method Share Review Button
    ///Navigate on Rating and Review Controller from Individual section
    @objc func tapShareReviews(sender:UIButton){
        
        print(self.viewModel.getOrderRootArray.first?.Data?[sender.tag].ratingData ?? RatingData.self )

        if self.viewModel.getOrderRootArray.first?.Data?[sender.tag].ratingData?.Id == ""{
            print("Contain Value Not")

            let viewC = ScreenManager.getReviewAndRatingVC()
            viewC.isComingFromNew = true
            viewC.resAndStoreId =  self.viewModel.getOrderRootArray.first?.Data?[sender.tag].resAndStoreId ?? ""
            viewC.orderId = self.viewModel.getOrderRootArray.first?.Data?[sender.tag].Id ?? ""
            viewC.backFromDelegate = self
            self.navigationController?.pushViewController(viewC, animated: true)
            
        }else{
            
            print("Contain Value")

        }
        
       
        
    }
    
    //TODO: Target Re-Order Button
    ///You can reorder the items from Past Tab Section
    @objc func tapReOrder(sender:UIButton){
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            UserDefaults.standard.removeObject(forKey: "Shop")
            
            var arrOrderData = [OrderDataStruct]()
            
            let countOrderData = self.viewModel.getOrderRootArray.first?.Data?[sender.tag].orderData?.count ?? 0
            
            print("Check On ReOrder Product from Past")
            
            for i in 0..<countOrderData {
                
                let item = OrderDataStruct(productId: (self.viewModel.getOrderRootArray.first?.Data?[sender.tag].orderData?[i].productId ?? "")!, quantity:"\(String(describing: self.viewModel.getOrderRootArray.first?.Data?[sender.tag].orderData?[i].quantity ?? 0))")
                arrOrderData.append(item)
                
            }
            
            
            if let jsonData = try? JSONEncoder().encode(arrOrderData),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                
                let jsonData = jsonString.data(using: .utf8)!
                
                let json = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                
                
                
                let param = ["userId" : UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                             "productData" :json,
                             "langCode":UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? ""] as [String : Any]
                
                self.reOrder(param)
                
            }
            
        }
        else{
            
            self.alertWithAction()
        }
    }
    
    
}

