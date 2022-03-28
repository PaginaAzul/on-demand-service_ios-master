//
//  MainModuleNew_VC.swift
//  Joker
//
//  Created by cst on 21/10/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit
import CoreLocation

class MainModuleNew_VC: UIViewController {
    
    //MARK: - OUTLETS
    //TODO:
    @IBOutlet weak var collectionMain: UICollectionView!
    @IBOutlet weak var  lblHome: UILabel!
    
    
    var mainArr = ["banner" , "food" , "home_services"]
    var nameArr = ["","Meals & Shopping","Services"]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let apiHandle = ApiHandler()
    var dashboardDataModel = [DashboardDataModel]()
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeTheLocationManager()

        commonController = self
        lblHome.text = "Home".localized()
        //self.getDashboardDataService()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblHome.text = "Home".localized()

        self.initializeTheLocationManager()
        self.getDashboardDataService()

    }
    
    @IBAction func tap_sideMenuBtn(_ sender: Any) {
        
        let vc = ScreenManager.getMoreVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_Notification(_ sender: UIButton) {
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
    func alertWithAction(){
        
        let alertController = UIAlertController(title: "", message: "You are not logged in. Please login/signup before proceeding further.".localized(), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            self.makeRootToLoginSignup()
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertActionStyle.cancel) {
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

extension MainModuleNew_VC: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    func configCollection(){
        self.collectionMain.delegate = self
        self.collectionMain.dataSource = self
        self.collectionMain.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }else if section == 1{
            return 1
        } else{
            return self.dashboardDataModel.first?.Data?.mainService?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 1 {
            
            self.collectionMain.register(UINib(nibName: "MainCollCell", bundle: nil), forCellWithReuseIdentifier: "MainCollCell")
            
            let cell = collectionMain.dequeueReusableCell(withReuseIdentifier: "MainCollCell", for: indexPath) as! MainCollCell
            
            return cell
            
        } else{
            
            let cell = collectionMain.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoriesCollectionViewCell
            
            cell.imgView.cornerRadius = 8
            cell.imgView.layer.masksToBounds = true
            
            cell.layer.cornerRadius = 8
         
            cell.layer.masksToBounds = false
            
            if indexPath.section == 0 {
                
                cell.itemFromBanner = self.dashboardDataModel.first?.Data?.homeBanner
               // cell.lblCategoryNameHeight.constant = 5
                cell.lblCategoriesName.text = "Offers".localized()
                
            }else{
                
                cell.itemFromMainServices = self.dashboardDataModel.first?.Data?.mainService?[indexPath.row]
               // cell.lblCategoryNameHeight.constant = 37.5
                
            }
            
            cell.lblCategoriesName.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 15.0)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 1 {
            return CGSize(width: collectionMain.frame.size.width-20, height:140)
            
        }else{
            if indexPath.row == 0 {
                return CGSize(width: collectionMain.frame.size.width-20, height:260)
            }else{
                return CGSize(width: collectionMain.frame.size.width-20, height: 260)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.removeObject(forKey: "Shop")
        if indexPath.section == 0 {
            
            let vc = ScreenManager.OffersNew_VC()  //ScreenManager.OfferController()

           // ScreenManager.OffersNew_VC()
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.section == 2{
            
            if indexPath.row == 0{
                
                let vc = ScreenManager.HomeScreenNew_VC()
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                appDelegate.window?.rootViewController = navController
                appDelegate.window?.makeKeyAndVisible()
                
            }else{
                
                UserDefaults.standard.set(false, forKey: "NewModul")
                
                let vc = ScreenManager.getServiceProviderMapVC()
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                self.appDelegate.window?.rootViewController = navController
                self.appDelegate.window?.makeKeyAndVisible()
                
            }
        }
    }
}
extension MainModuleNew_VC{
    
    func getDashboardDataService(){
        apiHandle.fetchApiService(method: .get, url: Domain.baseUrl().appending(APIEndpoint.getDashboardData)) { (result) in
            switch result{
            case .success(let data):
                if self.dashboardDataModel.count > 0 {
                    self.dashboardDataModel.removeAll()
                }
                self.dashboardDataModel.append(DashboardDataModel(data))
                
                if self.dashboardDataModel.first?.responseMessage == "Data found successfully"{
                    self.configCollection()
                }else{
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: self.dashboardDataModel.first?.responseMessage ?? "", controller: self)
                }
                
                break
            case .failure(let error):
                CommonClass.sharedInstance.callNativeAlert(title: "", message: error.localizedDescription, controller: self)
                break
            }
        }
    }
 
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
}

extension MainModuleNew_VC:CLLocationManagerDelegate {
    
    
    //TODO: Method Access Current Location
    func initializeTheLocationManager() {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        locationManager.startUpdatingHeading()
        
        var location = locationManager.location?.coordinate
       
        GloblaLat = location?.latitude.description ?? ""
        GloblaLong = location?.longitude.description ?? ""

        
    }
}

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}
