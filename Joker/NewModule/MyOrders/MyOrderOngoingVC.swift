//
//  MyOrderOngoingVC.swift
//  JustBite
//
//  Created by Aman on 16/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import SwiftyJSON

///////new code

struct OrderDataStruct : Codable{
    
    var productId:String
    var quantity:String
    
    init(productId:String , quantity:String) {
        self.productId = productId
        self.quantity = quantity
    }
    
}


import UIKit
import CoreLocation
class MyOrderOngoingVC: BaseViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tblViewHome: UITableView!
    @IBOutlet weak var viewBtn: UIView!
    @IBOutlet weak var btnOnGoingRef: UIButton!
    @IBOutlet weak var btnPreviousRef: UIButton!
    @IBOutlet weak var btnUpcoming: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var lblheader: UILabel!
    @IBOutlet weak var lblTabHome: UILabel!
    @IBOutlet weak var lblTabMyOrder: UILabel!
    @IBOutlet weak var lblTabSearch: UILabel!
    @IBOutlet weak var lblTabProfile: UILabel!
    @IBOutlet weak var lblTabHelp: UILabel!
    @IBOutlet weak var noDataFound: UILabel!

    let viewModel = ViewModel()
    
    var productIDArr = [String]()
    
    var locationManager = CLLocationManager()
    var lat = String()
    var long = String()
    let exchangeRate = UserDefaults.standard.value(forKey: "exchangeRate") as? Double ?? 0.0
    let currency = UserDefaults.standard.value(forKey: "currency") as? String ?? "USD"
    
    var order_Number = String()
   
    var btnTag = 2
    
    var myCartModelArr = [MyOrderModel]()
    var myOrderBaseModelArr = [myOrderBaseModel]()
    var isComingFromSideBar = Bool()
    var isExpandViewMore = Int()
    
   let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
   var isHeaderReload = Bool()
    
   var reloadFromRating = Bool()
    
    //MARK: - View life cycle methods
    //TODO: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataFound.text = "No data found".localized()
        noDataFound.isHidden = true
        tblViewHome.estimatedSectionHeaderHeight = UITableViewAutomaticDimension
        tblViewHome.estimatedSectionFooterHeight = UITableViewAutomaticDimension
        
        lblheader.text = "My Orders".localized()
        
        btnOnGoingRef.setTitle("Ongoing".localized(), for: .normal)
        btnPreviousRef.setTitle("Past".localized(), for: .normal)
        btnUpcoming.setTitle("Upcoming".localized(), for: .normal)
        
        lblTabHome.text = "Home".localized()
        lblTabMyOrder.text = "My Order".localized()
        lblTabSearch.text = "Search".localized()
        lblTabProfile.text = "My Profile".localized()
        lblTabHelp.text = "Help".localized()
        
        initialSetup()
        
      //  self.btnChoiceTapped(3)
       // btnChoiceTapped.(UIButton.btnTag = 3)
        commonController = self
        self.viewModel.getOrderRootArray.removeAll()
        
        IJProgressView.shared.showProgressView(view: commonController.view)
    }

    
    //TODO: View Will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UserDefaults.standard.set("Food", forKey: "Food")
        getCountV()
        
        commonController = self

        //IJProgressView.shared.showProgressView(view: self.view)
        
        self.tblViewHome.reloadData()

        if reloadFromRating {
            
            isExpandViewMore = 0
            self.btnTag = 2
            
            reloadFromRating = false
            
           // IJProgressView.shared.showProgressView(view: self.tblViewHome)
            
            getOrder("Past")

            btnPreviousRef.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!
            btnPreviousRef.setTitleColor(AppColor.whiteColor, for: .normal)
            btnPreviousRef.backgroundColor = AppColor.themeColor
            btnPreviousRef.setTitle("Past".localized(), for: .normal)
            
            btnOnGoingRef.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!
            btnOnGoingRef.setTitleColor(AppColor.placeHolderColor, for: .normal)
            btnOnGoingRef.backgroundColor = AppColor.whiteColor
            btnOnGoingRef.setTitle("Ongoing".localized(), for: .normal)
            
            btnUpcoming.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!
            btnUpcoming.setTitleColor(AppColor.placeHolderColor, for: .normal)
            btnUpcoming.backgroundColor = AppColor.whiteColor
            btnUpcoming.setTitle("Upcoming".localized(), for: .normal)
            
        }else{
            
            reloadFromRating = false

            //IJProgressView.shared.showProgressView(view: self.view)

            isExpandViewMore = 0
            self.btnTag = 0
            getOrder("Upcoming")
            
            btnUpcoming.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!
            btnUpcoming.setTitleColor(AppColor.whiteColor, for: .normal)
            btnUpcoming.backgroundColor = AppColor.themeColor
            btnUpcoming.setTitle("Upcoming".localized(), for: .normal)
            
            btnOnGoingRef.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!
            btnOnGoingRef.setTitleColor(AppColor.placeHolderColor, for: .normal)
            btnOnGoingRef.backgroundColor = AppColor.whiteColor
            btnOnGoingRef.setTitle("Ongoing".localized(), for: .normal)
            
            btnPreviousRef.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!
            btnPreviousRef.setTitleColor(AppColor.placeHolderColor, for: .normal)
            btnPreviousRef.backgroundColor = AppColor.whiteColor
            btnPreviousRef.setTitle("Past".localized(), for: .normal)
        }
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UserDefaults.standard.set("Food", forKey: "Food")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
}

extension MyOrderOngoingVC : checkBackRatingProtocol{
    func backFromRating(_ status: Bool) {
        reloadFromRating = status
    }
}


//MARK: - IBActions
//TODO:
extension MyOrderOngoingVC{
    
    @IBAction func tap_Help(_ sender: Any) {
        let vc = ScreenManager.getContactUsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_sideMenuBtn(_ sender: Any) {
        
        
        UserDefaults.standard.removeObject(forKey: "Food")
        
        let vc = ScreenManager.getMoreVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tap_MyCartBtn(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            let vc = ScreenManager.MyCartNew_VC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            
            self.alertWithAction()
        }
         
    }
    
    //MARK: - TabBar
    //
    @IBAction func tap_HometBtn(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            UserDefaults.standard.removeObject(forKey: "Food")
            let vc = ScreenManager.HomeScreenNew_VC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navController
            appDelegate.window?.makeKeyAndVisible()
            
        }else{
            
            self.alertWithAction()
        }
    }
    
    @IBAction func tap_SearchBtn(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            UserDefaults.standard.removeObject(forKey: "Food")
            let vc = ScreenManager.SearchNew_VC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navController
            appDelegate.window?.makeKeyAndVisible()
        }else{
            
            self.alertWithAction()
        }
    }
    
    
    @IBAction func tap_MyProfileBtn(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            UserDefaults.standard.removeObject(forKey: "Food")
            UserDefaults.standard.set(true, forKey: "NewModul")
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
    
    @IBAction func tap_MyOrdersBtn(_ sender: Any) {
        
    }
    
    @IBAction func btnChoiceTapped(_ sender: UIButton) {
        
        self.viewModel.getOrderRootArray.removeAll()
        self.tblViewHome.reloadData()

        isExpandViewMore = 0
        self.btnTag = sender.tag
        
        if self.btnTag == 1{
            
            getOrder("Ongoing")
            
            btnOnGoingRef.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!
            btnOnGoingRef.setTitleColor(AppColor.whiteColor, for: .normal)
            btnOnGoingRef.backgroundColor = AppColor.themeColor
            btnOnGoingRef.setTitle("Ongoing".localized(), for: .normal)
            
            btnPreviousRef.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!
            btnPreviousRef.setTitleColor(AppColor.placeHolderColor, for: .normal)
            btnPreviousRef.backgroundColor = AppColor.whiteColor
            btnPreviousRef.setTitle("Past".localized(), for: .normal)
            
            btnUpcoming.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!
            btnUpcoming.setTitleColor(AppColor.placeHolderColor, for: .normal)
            btnUpcoming.backgroundColor = AppColor.whiteColor
            btnUpcoming.setTitle("Upcoming".localized(), for: .normal)
            
        } else if self.btnTag == 2 {

            getOrder("Past")

            btnPreviousRef.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!
            btnPreviousRef.setTitleColor(AppColor.whiteColor, for: .normal)
            btnPreviousRef.backgroundColor = AppColor.themeColor
            btnPreviousRef.setTitle("Past".localized(), for: .normal)
            
            btnOnGoingRef.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!
            btnOnGoingRef.setTitleColor(AppColor.placeHolderColor, for: .normal)
            btnOnGoingRef.backgroundColor = AppColor.whiteColor
            btnOnGoingRef.setTitle("Ongoing".localized(), for: .normal)
            
            btnUpcoming.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!
            btnUpcoming.setTitleColor(AppColor.placeHolderColor, for: .normal)
            btnUpcoming.backgroundColor = AppColor.whiteColor
            btnUpcoming.setTitle("Upcoming".localized(), for: .normal)
            
        } else {

            getOrder("Upcoming")
            btnUpcoming.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!
            btnUpcoming.setTitleColor(AppColor.whiteColor, for: .normal)
            btnUpcoming.backgroundColor = AppColor.themeColor
            btnUpcoming.setTitle("Upcoming".localized(), for: .normal)
            
            btnOnGoingRef.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!
            btnOnGoingRef.setTitleColor(AppColor.placeHolderColor, for: .normal)
            btnOnGoingRef.backgroundColor = AppColor.whiteColor
            btnOnGoingRef.setTitle("Ongoing".localized(), for: .normal)
            
            btnPreviousRef.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 16.0)!
            btnPreviousRef.setTitleColor(AppColor.placeHolderColor, for: .normal)
            btnPreviousRef.backgroundColor = AppColor.whiteColor
            btnPreviousRef.setTitle("Past".localized(), for: .normal)
            
        }
    }
}

