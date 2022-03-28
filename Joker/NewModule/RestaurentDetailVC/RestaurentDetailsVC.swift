

//
//  RestaurentDetailsVC.swift
//  JustBite
//
//  Created by Aman on 13/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import UIKit
import Cosmos
import CoreLocation
import IQKeyboardManagerSwift

///////new code

struct CategoryDataModel{
    
    var type = String()
    var id = String()
    var menuCount = String()
    var name = String()
    var isSelected = Bool()
    var index = Int()
    init(type:String,id:String,menuCount:String,name:String,isSelected:Bool,index:Int){
        self.type = type
        self.id = id
        self.menuCount = menuCount
        self.name = name
        self.isSelected = isSelected
        self.index = index
    }
}


class RestaurentDetailsVC: UIViewController {
    
    var locationManager = CLLocationManager()
    var lat = String()
    var long = String()
    let apiHandle = ApiHandler()
    //MARK: - Outlets
    
    @IBOutlet weak var disLbl: UILabel!
    @IBOutlet weak var btnCancelSearchRef: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lblMinOrder: UILabel!
    @IBOutlet weak var lblDeliveryTime: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var viewLike: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var heightConstraints: NSLayoutConstraint!
    @IBOutlet weak var tblCart: UITableView!
    @IBOutlet weak var collectionViewHeader: UICollectionView!
    @IBOutlet weak var collectionview: UICollectionView!

    @IBOutlet weak var btnConfirmRef: UIButton!
    @IBOutlet weak var reviewsRef: UILabel!
    @IBOutlet weak var imgRestaurent: UIImageView!
    @IBOutlet weak var heigntConsBtn: NSLayoutConstraint!
    @IBOutlet weak var viewCosmos: CosmosView!
    @IBOutlet weak var btnFavRef: UIButton!
    @IBOutlet weak var btn_MenuFilter: UIButton!
    
    @IBOutlet weak var lblMEnu: UILabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var lblNoItem: UILabel!

    
    @IBOutlet weak var scrollView: UIScrollView!
    let screenHeight = UIScreen.main.bounds.height
    let scrollViewContentHeight = 1200 as CGFloat
    
    //MARK: - Variables
    internal var previousOffset: CGFloat = 0
    var id = String()
    var isFav = Bool()
    var categoryDataModelArray = [CategoryDataModel]()
    var index = Int()
    var price = Int()
    var quantity = Int()
    var addOn = String()
    var cart_value = Int()
    var catIndex = Int()
    var isSearchBarHidden = Bool()
    var searchActive = Bool()
    var myCartModelArr = [MyCartModel]()
    var store_type = String()
    
    //TODO: FOR REALM
    var restaurentName = String()
    var restaurentAddress = String()
    var restaurentLat = String()
    var restaurentLong = String()
    
    var comingLat = String()
    var comingLong = String()
    var currentLat = String()
    var currentLong = String()
    let exchangeRate = UserDefaults.standard.value(forKey: "exchangeRate") as? Double ?? 0.0
    var locationTExt = ["North Indian" , "Italian" ,"Chinese"]
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var comgFromOffer = Bool()
    
    let viewModel = ViewModel()
    var filterArr : [DataCuisines]?
    var tblArr : [DataCuisines]?
    
    
    
    @IBAction func btnRating(_ sender: Any) {
        
        
        let vc = ScreenManager.ratingReviewsNew_VC()
        if self.viewModel.ResAndStoreDetailArray.first?.Data?.rating?.count != 0 {
            vc.ratingModelArr = (
                self.viewModel.ResAndStoreDetailArray.first?.Data?.rating)!

        }
        

        
        vc.avgRating = self.viewModel.ResAndStoreDetailArray.first?.Data?.resAndStoreDetail?.avgRating ?? 0.0
        vc.totalRating = self.viewModel.ResAndStoreDetailArray.first?.Data?.resAndStoreDetail?.totalRating ?? 0
         
        //ratingModelArr
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    
    @objc func didPressOnDoneButton() {
        
        searchActive = false
        
        self.searchBar.endEditing(true)
        isSearchBarHidden = false
        searchBar.isHidden = true
        btnCancelSearchRef.isHidden = false
        
        searchBar.text = String()
        lblMEnu.isHidden = false
        btnSearch.isHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewsRef.text = "\(0) (\(0) \("Reviews".localized()))"

        lblNoItem.font = UIFont.systemFont(ofSize: 17.0)
        lblNoItem.text = "No Item".localized()

        lblMEnu.text = "Menu".localized()
        self.configureColl()
        
        btnConfirmRef.setTitle("Add To Cart".localized(), for: .normal)
        
        commonController = self
        minimumPrice = 0
        AccessCurrentLocationuser()
        
        self.getresAndStoreDetailService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        btnConfirmRef.setTitle("Add To Cart".localized(), for: .normal)
        
        commonController = self
        minimumPrice = 0
        AccessCurrentLocationuser()
        
        self.getresAndStoreDetailService()
       
    }
    
  
    
    func configCollection(_ data:[DataCuisines]){
        
        self.tblArr = data

        self.collectionview.delegate = self
        self.collectionview.dataSource = self
        self.collectionview.reloadData()
        
        
    }
    
    //MARK:- setData on Screen
    func setDataOnScreen(){
        print("called setDataOnScreen.........")
        let data = self.viewModel.ResAndStoreDetailArray.first?.Data?.resAndStoreDetail
        //print("data...........\(data)")
        if let closingTime = data?.closingTime{
            UserDefaults.standard.setValue(closingTime, forKey: "closingTime")
            print("Close == ",UserDefaults.standard.object(forKey: "closingTime") ?? "")

            UserDefaults.standard.synchronize()
            print("Closeat == ",UserDefaults.standard.object(forKey: "closingTime") ?? "")
        }
        IQKeyboardManager.shared.enable = true
        let invocation = IQInvocation(self, #selector(didPressOnDoneButton))
        searchBar.keyboardToolbar.doneBarButton.invocation = invocation
        searchBar.delegate = self
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.isHidden = true
        
        self.btnCancelSearchRef.isHidden = false
        
        viewCosmos.settings.fillMode = .half
        disLbl.isHidden = false
        
        let lat = self.lat as NSString
        let long = self.long as NSString
        
        disLbl.text = CommonClass.sharedInstance.getDistanceFromCurrentToAll(currentLocationLat: lat.doubleValue, currentLocationLong: long.doubleValue, latitude: data?.latitude ?? "", longitude: data?.longitude ?? "")
        viewCosmos.rating = Double(data?.avgRating ?? 0)
        btnFavRef.setImage(data?.isFav ?? false ? #imageLiteral(resourceName: "fav"):UIImage(named: "Unfav") , for: .normal)
        
        CommonClass.sharedInstance.provideCornarRadius(btnRef: viewLike)
        
        let myMutableString1 = NSMutableAttributedString()
        let normalText1 = " \(data?.name ?? "")"
        let myMutableString2 = NSAttributedString(string: "\(normalText1) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 17.0)!, .foregroundColor :AppColor.textColor])
        
        myMutableString1.append(myMutableString2)
        
        lblDetails.attributedText = myMutableString1
        
        lblAddress.attributedText = CommonClass.sharedInstance.updateHomeTableViewCellLabel(title: "" , cusineArray: data?.cuisinesName ?? [] , address: data?.address ?? "", delemit: "\n")
        
        let localPrice = data?.minimumValue?.description as NSString?
        
        self.imgRestaurent.setImage(withImageId: data?.image ?? "", placeholderImage: #imageLiteral(resourceName: "food_icon"))
        
        self.lblDeliveryTime.text = "\(data?.deliveryTime ?? "") \("mins".localized())."
        self.lblMinOrder.textColor = AppColor.subtitleColor
        self.lblMinOrder.text = "\("Min. Order".localized()) : \(getCurrencyFormat(amount: localPrice?.doubleValue ?? 0.0)) Kz"
        self.btn_MenuFilter.isHidden = true
        let avgRat = Double(round(data?.avgRating ?? 0.0))
        reviewsRef.text = "\(avgRat) (\(data?.totalRating ?? 0) \("Reviews".localized()))"
        
    }
    
    
    @objc func callLocation(_ notification: Notification){
        
    }
    
    
    //TODO: View will layout Subviews
    override func viewDidLayoutSubviews() {
        
    }
    
    //Price Change Currancy
    
    func getCurrencyFormat(amount: Double) -> String
    {
        let amountFormatter = NumberFormatter()
        amountFormatter.numberStyle = .decimal ///ERROR
        amountFormatter.locale = NSLocale.system
        let price = amountFormatter.string(from: amount as NSNumber)! as NSString
        return String(price.description)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func locationBtn(_ sender: Any) {
        CommonClass.sharedInstance.openMapButtonAction(self, self.viewModel.ResAndStoreDetailArray.first?.Data?.resAndStoreDetail?.latitude ?? "", self.viewModel.ResAndStoreDetailArray.first?.Data?.resAndStoreDetail?.longitude ?? "")
    }
    
    
    @IBAction func btnSearchTapped(_ sender: UIButton) {
        
        isSearchBarHidden = true
        searchBar.isHidden = false
        btnCancelSearchRef.isHidden = true
        lblMEnu.isHidden = true
        btnSearch.isHidden = true
        
    }
    
    @IBAction func btnCancelSearchTapped(_ sender: UIButton) {
        
        self.searchBar.endEditing(true)
        isSearchBarHidden = false
        searchBar.isHidden = true
        btnCancelSearchRef.isHidden = true
        searchActive = false
        searchBar.text = String()
        tblCart.reloadData()
        
    }
    
    
    @IBAction func btnInfoTapped(_ sender: Any) {
//        print("isValid.........\(isValidTime())")
        let vc = ScreenManager.ResturantInfoViewC()
        vc.viewC = self
        vc.ResAndStoreDetailArray = self.viewModel.ResAndStoreDetailArray
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func btnFilterTapped(_ sender: UIButton) {
        
        let vc = UIStoryboard.init(name: "NewModule", bundle: nil).instantiateViewController(withIdentifier: "MenuItemListVc") as! MenuItemListVc
        vc.modalPresentationStyle = .formSheet
        vc.id = self.id
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnFilterTapped1(_ sender: UIButton) {
        let vc = ScreenManager.NewFilterVCAman()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    @IBAction func btnAddToCartTapped(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            UserDefaults.standard.removeObject(forKey: "Shop")
            let minivalue = self.viewModel.ResAndStoreDetailArray.first?.Data?.resAndStoreDetail?.minimumValue ?? 0
            
            let vc = ScreenManager.MyCartNew_VC()
            vc.icComingFromOffer = false
            vc.comgFromOffer = self.comgFromOffer
            let data = self.viewModel.ResAndStoreDetailArray.first?.Data?.resAndStoreDetail
            //print("data...........\(data)")
            if let closingTime = data?.closingTime{
                vc.closingTime = closingTime
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        else{
            self.alertWithAction()
        }
    }
   
    func makeRootToLoginSignup(){
        
        let vc = ScreenManager.getSignInSignupVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
        
    }

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
    
    @IBAction func btnFavTapped(_ sender: UIButton) {
        
        
        guard UserDefaults.standard.bool(forKey: "IsUserLogin") else {
            // alertWithAction()
            CommonClass.sharedInstance.alertWithAction()
            return
        }
        
        guard CommonClass.sharedInstance.isConnectedToNetwork() else {
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: commonController)
            return
        }
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                     "resAndStoreId":self.id,
                     "langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ]
        apiHandle.fetchApiService(method: .post, url: Domain.baseUrl().appending(APIEndpoint.addToFavourite), passDict: param, header: header) { (result) in
            switch result{
            
            case .success(let data):
                print(data)
                let response_message = data["response_message"].stringValue
                
                if response_message == "Added to favourite successfully".localized(){
                    self.btnFavRef.setImage(#imageLiteral(resourceName: "fav") , for: .normal)
                    isFavt = true
                    self.btnFavRef.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    
                    UIView.animate(withDuration: 2.0,
                                   delay: 0,
                                   usingSpringWithDamping: 0.2,
                                   initialSpringVelocity: 6.0,
                                   options: .allowUserInteraction,
                                   animations: { [weak self] in
                                    self?.btnFavRef.transform = .identity
                                   },
                                   completion: nil)
                }else if response_message == "Remove from favourite successfully".localized(){
                    self.btnFavRef.setImage(UIImage(named: "Unfav") , for: .normal)
                    isFavt = false
                    
                } else{
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: response_message, controller: commonController)
                }
                
                break
            case .failure(let error):
                CommonClass.sharedInstance.callNativeAlert(title: "", message: error.localizedDescription, controller: commonController)
                break
            }
        }
    }
    
}


//MARK: - Extension Location Delegates
extension RestaurentDetailsVC {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation:CLLocation = locations.first!
        print("LATTITUDE IS:", currentLocation.coordinate.latitude)
        print("LONGITUDE IS:", currentLocation.coordinate.longitude)
        self.lat = String(currentLocation.coordinate.latitude)
        self.long = String(currentLocation.coordinate.longitude)
        
        // reverseGeocodeCoordinate(inLat:currentLocation.coordinate.latitude, inLong:currentLocation.coordinate.longitude)
        self.locationManager.delegate = nil
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}

//MARK: - Extension Method Access Current Location
extension RestaurentDetailsVC: CLLocationManagerDelegate {
    
    
    func AccessCurrentLocationuser(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
    }
    
    func getDistanceFromCurrentToAll(currentLocationLat:Double,currentLocationLong:Double,latitude:String,longitude:String) -> String{
        
        print(currentLocationLat)
        print(currentLocationLong)
        print(latitude)
        print(longitude)
        
        if currentLocationLat == 0.0 || currentLocationLong == 0.0{
            
            return ""
        }
        
        let lati = latitude.trimmingCharacters(in: .whitespaces)
        let longi = longitude.trimmingCharacters(in: .whitespaces)
        
        if lati == "" || longi == ""{
            
            return ""
        }
        
        let doubleLat = Double(lati)
        let doubleLong = Double(longi)
        
        let coordinate₀ = CLLocation(latitude: currentLocationLat, longitude: currentLocationLong)
        
        let coordinate₁ = CLLocation(latitude: doubleLat!, longitude: doubleLong!)
        
        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
        let distanceInKm = distanceInMeters / 1000
        
        var integerDistance = Int()
        
        if distanceInKm < 1.0 && distanceInKm > 0.0{
            
            integerDistance = 1
        }
        else{
            
            integerDistance = Int(distanceInKm)
        }
        
        return "\(integerDistance) \("KM".localized())"
        
    }
    
}

//Mark: - Scroll
extension RestaurentDetailsVC {
    
    
    
}

//MARK:- Menu List VC

class MenuItemListVc: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    //MARK:- Outlets
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var btnClose:UIButton!
    
    let apiHandle = ApiHandler()
    var id = String()
    var menuItemDataArray = [MenuItemModel]()
    
    override func viewDidLoad() {
        self.fetchMenuItemService()
        self.btnClose.addTarget(self, action: #selector(btnCloseTap(_:)), for: .touchUpInside)
    }
    
    @objc func btnCloseTap(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func configTable(){
        self.tblView.register(UINib(nibName: "MenuItemCell", bundle: nil), forCellReuseIdentifier: "MenuItemCell")
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return myCartModelArr.count
        return self.menuItemDataArray.first?.Data?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
        cell.item = self.menuItemDataArray.first?.Data?[indexPath.row]
        return cell
    }
    
    func fetchMenuItemService(){
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                     "resAndStoreId": self.id,
                     "langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ] as [String:Any]
        apiHandle.fetchApiService(method: .post, url: Domain.baseUrl().appending(APIEndpoint.getRestaurantMenuList), passDict: param, header: header) { (result) in
            switch result{
            case .success(let data):
                print(data)
                if self.menuItemDataArray.count > 0 {
                    self.menuItemDataArray.removeAll()
                }
                self.menuItemDataArray.append(MenuItemModel(data))
                if self.menuItemDataArray.first?.responseMessage == "Menu list found successfully" {
                    self.configTable()
                }else{
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: self.menuItemDataArray.first?.responseMessage ?? "", controller: self)
                }
                break
            case .failure(let error):
                CommonClass.sharedInstance.callNativeAlert(title: "", message: error.localizedDescription, controller: self)
                break
            }
        }
    }
    
    
}
