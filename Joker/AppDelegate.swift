//
//  AppDelegate.swift
//  Joker
//
//  Created by Callsoft on 18/01/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

//Joker main created by tarun
//new placekey -- AIzaSyA-wVrPOX3FbsNMCPGsiAyGJnnQXmyPgjs

//AIzaSyAoZgdp2NxR-fpsv4yj738wvej3uDVOzf4

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces
import Firebase
import IQKeyboardManagerSwift
import UserNotifications
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,CLLocationManagerDelegate{

    var window: UIWindow?
    
    var lastLocation:CLLocation?
    var locationManager = CLLocationManager()
    var sourceLat: Double = 0.0
    var sourceLong: Double = 0.0
    var notificationCenter: UNUserNotificationCenter?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        let simulaterToken = "b1e2d3bb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
        
        UserDefaults.standard.set(simulaterToken as String, forKey: "DeviceToken")
        
        FirebaseApp.configure()
        
//        GMSServices.provideAPIKey("AIzaSyCZCC0KH3xEDnOACnLaI-DmBeAoWw3CO1w")
        //old keys
//        GMSServices.provideAPIKey("AIzaSyAoZgdp2NxR-fpsv4yj738wvej3uDVOzf4")
//        GMSPlacesClient.provideAPIKey("AIzaSyCSLXHvjt-JxEI_r2CAvrOgPyJSsWVMyww")
       // GMSPlacesClient.provideAPIKey("AIzaSyD7gzrvGoxG1ZwdXWTp4oUq2sEfmltNxEg")
        //new keys
        GMSServices.provideAPIKey("AIzaSyAoZgdp2NxR-fpsv4yj738wvej3uDVOzf4")
        GMSPlacesClient.provideAPIKey("AIzaSyDbeg8Dh2fnyHpmMcuL2PtUPN9kqvQFDdY")
        //GMSPlacesClient.provideAPIKey("AIzaSyAoZgdp2NxR-fpsv4yj738wvej3uDVOzf4")
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarTintColor = UIColor.black
        
        setAsInitialViewController()
        
        registerForRemoteNotification()
        
        if launchOptions?[UIApplicationLaunchOptionsKey.location] != nil {
            
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            
            self.notificationCenter = UNUserNotificationCenter.current()
            self.notificationCenter?.delegate = self
        }
                
        if UserDefaults.standard.bool(forKey: "LanguageSelected") as? Bool ?? false == false{

            UserDefaults.standard.set(true, forKey: "LanguageSelected")
            
            UserDefaults.standard.set("ar", forKey: "LANGUAGE")
            Localize.setCurrentLanguage(language: "pt-PT")

        }
        
        return true
    }
    
    
    func setAsInitialViewController(){
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            let vc = ScreenManager.MainModuleNew_VC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            self.window?.rootViewController = navController
            self.window?.makeKeyAndVisible()
            
//            Real Code
//            let vc = ScreenManager.getServiceProviderMapVC()
//            let navController = UINavigationController(rootViewController: vc)
//            navController.navigationBar.isHidden = true
//            self.window?.rootViewController = navController
//            self.window?.makeKeyAndVisible()
            
        }else{
            
            if UserDefaults.standard.bool(forKey: "FirstTimeInstallation"){
                
                //MARK:- Real Code
                let vc = ScreenManager.MainModuleNew_VC()
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                self.window?.rootViewController = navController
                self.window?.makeKeyAndVisible()
  
            }else{

                let storyBoard = UIStoryboard(name: "Login_SignUP", bundle: nil)

                let vc = storyBoard.instantiateViewController(withIdentifier: "WalkInVC") as! WalkInVC
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                self.window?.rootViewController = navController
                self.window?.makeKeyAndVisible()
            }
                       
        }
        
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
      
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
     
        self.updateLocationInBacgroundMode()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
      
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
       
    }

    func applicationWillTerminate(_ application: UIApplication) {
      
        self.saveContext()
    }
    
    
    //MARK:- Notifications delegates
    
    func registerForRemoteNotification() {
        
        if #available(iOS 10, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            UIApplication.shared.registerForRemoteNotifications()
        }
        else if #available(iOS 9, *) {
            
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
            
        }
    }
    
    func setupPushNotifications()
    {
        
        if #available(iOS 10.0, *){
            
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted)
                {
                    let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                    UIApplication.shared.registerUserNotificationSettings(settings)
                    UIApplication.shared.registerForRemoteNotifications()
                }else{
                    
                    DispatchQueue.main.async {
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "DeviceTokenUpdated"), object: nil)
                        
                    }
                    
                    print("unsuccesfull")
                }
            })
        }else{
            
            let userNotificationTypes:UIUserNotificationType = ([UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound])
            
            if UIApplication.shared.responds(to: #selector(getter: UIApplication.isRegisteredForRemoteNotifications)){
                
                let settings = UIUserNotificationSettings(types: userNotificationTypes, categories: nil)
                
                UIApplication.shared.registerUserNotificationSettings(settings)
                UIApplication.shared.registerForRemoteNotifications()
                
            }else {
                
            }
        }
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        if application.isRegisteredForRemoteNotifications == true{
            
            application.registerForRemoteNotifications()
            
        }else{
            
            print("application.isRegisteredForRemoteNotifications() ====== \(application.isRegisteredForRemoteNotifications)")
            
            let simulaterToken = "b1e2d3bb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
            
            UserDefaults.standard.set(simulaterToken as String, forKey: "DeviceToken")
            
        }
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        //let characterSet: NSCharacterSet = NSCharacterSet( charactersIn: "<>" )
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        UserDefaults.standard.set(deviceTokenString as String, forKey: "DeviceToken")
        
        NSLog("Device Token : %@", deviceTokenString)
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        let simulaterToken = "b1e2d3bb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
        UserDefaults.standard.set(simulaterToken, forKey: "DeviceToken")
        print(error, terminator: "")
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        print("hello")
        //  print("Recived: \(userInfo)")
        
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let pushForForegroundDict = notification.request.content.userInfo as NSDictionary
        print(pushForForegroundDict)
        
        let type = pushForForegroundDict.object(forKey: "type") as? String ?? ""
        
        if type == "chat"{
            
            if CommonClass.sharedInstance.chatScreenIsOpen == false{
                
                completionHandler(.alert)
            }else{
                
            }
        }
        else if type == "orderAvailableForDelivery"{
            
            //Refresh new order screen delivery captain side
            
            completionHandler(.alert)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshNewOrderScreenForDeliveryCaptain"), object: nil)
            
        }
        else if type == "orderAvailableForProfessional"{
            
            //Refresh new order screen professional captain side
            
            completionHandler(.alert)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshNewOrderScreenForProfessionalCaptain"), object: nil)
        }
        else if type == "offerAvailable"{
            
            //for normal user screen offer by delivery person
            
            completionHandler(.alert)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdatePendingListNormalUserByDelivery"), object: nil)
        }
        else if type == "offerAcceptOfDelivery"{
            
            //offer is accepted by normal user after bid by delivery person
            
             completionHandler(.alert)
            
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OfferAcceptedByNormal"), object: nil)
        }
        else if type == "offerReject"{
            
            //offer is rejected by normal user after bid by delivery person
            
            completionHandler(.alert)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OfferRejectedByNormal"), object: nil)
        }
        else if type == "orderUnavailable"{
            
            //Normal user picked another delivery worker order
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OfferAcceptedByOther"), object: nil)
            
        }
        else if type == "offerAcceptOfProfessional"{
            
            //Notification will reflect only professional worker side. This is for when normal user accept the offer of professional worker after bid
            
            completionHandler(.alert)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OfferAcceptedOfProfessionalByNormal"), object: nil)
            
        }
        else if type == "offerRejectProfessional"{
            
             //Notification will reflect only professional worker side. This is for when normal user reject the offer of professional worker after bid
            
            completionHandler(.alert)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OfferRejectedOfProfessionalByNormal"), object: nil)
            
            
        }
        else if type == "orderUnavailableForProfessional"{
            
            //Notification will reflect only professional worker side. This is for when normal user accept the offer of other professional worker after bid and your offer is idle right now.
            
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OfferAcceptedByOtherProfessionalWorker"), object: nil)
            
        }
        else if type == "offerAvailableProfessional"{
            
            completionHandler(.alert)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdatePendingListNormalUserByProfessionalWorker"), object: nil)
            
        }
        else if type == "orderCancel"{
            
            completionHandler(.alert)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdatePendingListNormalUserByProfessionalWorker"), object: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdatePendingListNormalUserByDelivery"), object: nil)
            
            //***This notification is for redirect the captain from active dashboard to home screen
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RedirectToHomeFromDashboardOfBothServiceProvider"), object: nil)
            
        }
        else if type == "offerAcceptOfDelivery"{
            
             completionHandler(.alert)
            
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdatePendingAndActiveOrderOfDeliveryPerson"), object: nil)
        }
        else if type == "offerAcceptOfProfessional"{
            
             completionHandler(.alert)
            
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdatePendingAndActiveOrderOfProfessionalWorker"), object: nil)
        }
        else if type == "workDoneByDP"{
            
            completionHandler(.alert)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdateActiveOrderNormalUserDeliveryPersonDone"), object: nil)
            
            let infoDict = pushForForegroundDict.object(forKey: "obj") as? NSDictionary ?? [:]
            
            let ratingToId = infoDict.object(forKey: "deliveryUserId") as? String ?? ""
            let orderId = infoDict.object(forKey: "orderId") as? String ?? ""
            
            let vc = ScreenManager.getSuccessfullDeliveredPopupVC()
            vc.controllerPurpuse = "NormalDelivery"
            
            vc.rateToUserId = ratingToId
            vc.orderId = orderId
            
            self.window?.rootViewController?.present(vc, animated: false, completion: nil)
            
        }
        else if type == "workDoneByPW"{
            
            completionHandler(.alert)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdateActiveOrderNormalUserProfessionalPersonDone"), object: nil)
            
            let infoDict = pushForForegroundDict.object(forKey: "obj") as? NSDictionary ?? [:]
            
            let ratingToId = infoDict.object(forKey: "deliveryUserId") as? String ?? ""
            let orderId = infoDict.object(forKey: "orderId") as? String ?? ""
            
            let vc = ScreenManager.getSuccessfullDeliveredPopupVC()
            vc.controllerPurpuse = "normalPROFESSIONAL"
            
            vc.rateToUserId = ratingToId
            vc.orderId = orderId
            
            self.window?.rootViewController?.present(vc, animated: false, completion: nil)
            
        }
        else if type == "deliveryAction" || type == "professionalAction"{
            
            //update tracking status in normal user side
            
            completionHandler(.alert)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateNormalUserTrackingStatus"), object: nil)
            
            if type == "deliveryAction"{
                
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ActionTakenByDeliveryWorkerInTracking"), object: nil)
            }
            else{
                
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ActionTakenByProfessionalWorkerInTracking"), object: nil)
            }
            
        }
        else if type == "orderCancelFromDelivery"{
            
            completionHandler(.alert)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdatePendingListNormalUserByDelivery"), object: nil)
            
            //offer withdraw by delivery captain and would be listen by normal delivery
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WithdrawByDeliveryWorker"), object: nil)
            
        }
        else if type == "orderCancelFromProfessional"{
            
            completionHandler(.alert)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdatePendingListNormalUserByProfessionalWorker"), object: nil)
            
            //offer withdraw by Professional captain and would be listen by normal professional
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WithdrawByProfessionalWorker"), object: nil)
        }
        else if type == "acceptWithdrawRequestDeliveryPersion"{
            
             completionHandler(.alert)
            
            //request accepted by normal delivery
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WithdrawRequesteAcceptedByNormalDelivery"), object: nil)
            
        }
        else if type == "acceptWithdrawRequestProfessionalWorker"{
            
            completionHandler(.alert)
            
            //request accepted by normal professional
            
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WithdrawRequesteAcceptedByNormalProfessional"), object: nil)
        }
        else if type == "orderChangeFromNormal"{
            
            //normal user has changed the delivery person so we are redirecting delivery person to home screen
            
            let vc = ScreenManager.getServiceProviderMapVC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            self.window?.rootViewController = navController
            self.window?.makeKeyAndVisible()
        }
        else if type == "orderCancelByUserDeliveryOrder"{
            
            completionHandler(.alert)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OfferDeletedByNormalDelivery"), object: nil)
        }
        else if type == "orderCancelByUserProfessionalOrder"{
            
            completionHandler(.alert)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OfferDeletedByNormalProfessional"), object: nil)
            
        }else if type == "rating"{
            completionHandler(.alert)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RatingByProfessional"), object: nil)
        }
        else{
            
            completionHandler(.alert)
        }

    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo as NSDictionary
        print(userInfo)
        
    }
 
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "Joker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
             
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
              
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}



extension AppDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        print("----------->AppDelegate Location Update")
        
        lastLocation = locations.last!
        print("Location: \(String(describing: lastLocation))")
        
        if UIApplication.shared.applicationState == .active {
            
            
        } else {
            
            //App is in BG/ Killed or suspended state
            //send location to server
            // create a New Region with current fetched location
            let location = locations.last
            lastLocation = location
            
            //Make region and again the same cycle continues.
            self.createRegion(location: lastLocation)
        }
    }
    
    func createRegion(location:CLLocation?) {
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let coordinate = CLLocationCoordinate2DMake((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
            let regionRadius = 5.0
            
            let region = CLCircularRegion(center: CLLocationCoordinate2D(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude),
                                          radius: regionRadius,
                                          identifier: "aabb")
            
            region.notifyOnExit = true
            region.notifyOnEntry = true
            
            sourceLat = coordinate.latitude
            sourceLong = coordinate.longitude
            
            CommonClass.sharedInstance.locationLatCordinate = self.sourceLat
            CommonClass.sharedInstance.locationLongCordinate = self.sourceLong
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationForUpdateLocationOnServer"), object: nil)
            
            //Send your fetched location to server
            
            print("----------->AppDelegate Region Update")
            
            //self.getAddressFromLatLon(latitude: String(sourceLat), longitude: String(sourceLong))
            
            // self.callApiUpdateLocationInBackground(withParam: dictParam, header: header)
            //Stop your location manager for updating location and start regionMonitoring
            
            self.locationManager.stopUpdatingLocation()
            self.locationManager.startMonitoring(for: region)
            
        }
            
        else {
            print("System can't track regions")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        print("Entered Region")
        //self.handleEvent(forRegion: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        print("Exited Region")
        
        locationManager.stopMonitoring(for: region)
        //Start location manager and fetch current location
        locationManager.startUpdatingLocation()
        //self.handleEvent(forRegion: region)
    }
    
    func updateLocationInBacgroundMode() {
        
        self.locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
      
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        // self.locationManager.allowsBackgroundLocationUpdates = true
        //self.locationManager.startUpdatingLocation()
        //self.locationManager.startMonitoringSignificantLocationChanges()
    }
}

/////noti data


// if normal user getting offer from delivery worker
//{
//    aps =     {
//        alert = "Hi, New offer is now avialable on your order number 12459706307 offered by Ravi .For more details please check your order dashboard.";
//        badge = 3;
//        sound = "ping.aiff";
//    };
//    msg = "Hi, New offer is now avialable on your order number 12459706307 offered by Ravi .For more details please check your order dashboard.";
//    title = "New Offer Available";
//    type = offerAvailable;
//}


// if normal user getting offer from professional worker
//{
//    aps =     {
//        alert = "Hi, New offer is now avialable on your order number 85308498226 offered by Ravi .";
//        badge = 5;
//        sound = default;
//        };
//        msg = "Hi, New offer is now avialable on your order number 85308498226 offered by Ravi .";
//        title = "New Offer Available";
//        type = offerAvailableProfessional;
//}


// If delivery person cancel the order of normal user
//{
//    aps =     {
//        alert = "Hi, your order number 78317620848 has been cancelled by Ravi If you have not perform this action please contact with admin";
//        badge = 10;
//        sound = default;
//        };
//        msg = "Hi, your order number 78317620848 has been cancelled by Ravi If you have not perform this action please contact with admin";
//        title = "Oops ! Order Cancelled";
//        type = orderCancel;
//}


// if professional person cancel the order of normal user
//{
//    aps =     {
//        alert = "Hi, your order number 85308498226 has been cancelled by Ravi If you have not perform this action please contact with admin";
//        badge = 11;
//        sound = default;
//        };
//        msg = "Hi, your order number 85308498226 has been cancelled by Ravi If you have not perform this action please contact with admin";
//        title = "Oops ! Order Cancelled";
//        type = orderCancel;
//}


// offer accept of delivery
//{
//    aps =     {
//        alert = "Hi, your order number 82812740553 has been accepted by Shalini .";
//        badge = 4;
//        sound = default;
//        };
//        msg = "Hi, your order number 82812740553 has been accepted by Shalini .";
//        title = "Woo-hoo! Order Accepted";
//        type = offerAcceptOfDelivery;
//}

// offer accept of professional Worker
//{
//    aps =     {
//        alert = "Hi, your order number 85308498226 has been accepted by Shalini .";
//        badge = 5;
//        sound = default;
//        };
//        msg = "Hi, your order number 85308498226 has been accepted by Shalini .";
//        title = "Woo-hoo! Order Accepted";
//        type = offerAcceptOfProfessional;
//}


// Work done by delivery person
//{
//    aps =     {
//        alert = "Hi, Congratution ! Your order number 82812740553 has been deliverd now by Ravi Please submit your feedback for better service.";
//        badge = 4;
//        sound = default;
//        };
//        msg = "Hi, Congratution ! Your order number 82812740553 has been deliverd now by Ravi Please submit your feedback for better service.";
//        title = "Order Delivered Successfully";
//        type = workDoneByDP;
//}


// Work done by professional worker
//{
//    aps =     {
//        alert = "Hi, Congratution ! Work has been completed now by Ravi .Please submit your feedback for better service.";
//        badge = 5;
//        sound = default;
//        };
//        msg = "Hi, Congratution ! Work has been completed now by Ravi .Please submit your feedback for better service.";
//        title = "Congratution ! Work Done";
//        type = workDoneByPW;
//}



//new notification to show work done popup globally in the app for normal user

//{
//    aps =     {
//        alert = "Hi, congratulation ! Your order number 99329145049 has been delivered now by Abhishek Please submit your feedback for better service.";
//        sound = default;
//        };
//        msg = "Hi, congratulation ! Your order number 99329145049 has been delivered now by Abhishek Please submit your feedback for better service.";
//        obj =     {
//        deliveryUserId = 5cde6a5b120bf9665dbf92c4;
//        orderId = 5cde6a5b120bf9665dbf92c4;
//        type = Delivery;
//        };
//        title = "Order Delivered Successfully";
//        type = 6;
//}

