//
//  OfferListNew_VC.swift
//  Joker
//
//  Created by cst on 21/10/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit

/////////New code

class OfferListNew_VC: UIViewController {
    
    @IBOutlet weak var offerTV: UITableView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblNoOffer: UILabel!
    
    
    var offerListModelArr = [OfferListModel]()
    var mainArr = ["item_a" , "item_b"]
    var headerText = String() , storeCategoryId:String?
    
    let apiHandle = ApiHandler()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var viewModel = ViewModel()
    var search:String=""
    var filterModelArr = [DataOffer]()
    
    var currentCartQuantity = Int()
    var quantity = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNoOffer.isHidden = true
        
        //getOfferList()
        txtSearch.placeholder = "Search products".localized()
        
        lblHeader.text! = "\(headerText) \("Offers".localized())"
        
        txtSearch.delegate = self
        
        offerListModelArr.append(OfferListModel(title: "Corn Flakes", shopName: "99 Store", productDetail: "Lorem ipsum dolor sit amet, Lorem consectetur adipiscing elit.", price: "Kz 7.00", lastPrice: "Kz.9.00",imageProduct: "item_a"))
        
        offerListModelArr.append(OfferListModel(title: "Chocos", shopName: "99 Store", productDetail: "Lorem ipsum dolor sit amet, Lorem consectetur adipiscing elit.", price: "Kz 8.00", lastPrice: "Kz.9.00",imageProduct:"item_b"))
    }
    
    func configureCell(){
        self.offerTV.register(UINib(nibName: "OfferTableViewCellAndXib", bundle: nil), forCellReuseIdentifier: "Cell")
        
        offerTV.tableFooterView = UIView()
        
        offerTV.delegate = self
        offerTV.dataSource = self
        offerTV.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getOfferList()
        commonController = self
    }
    
    @IBAction func dismisBtn(_ sender: Any) {
        
        if UserDefaults.standard.value(forKey: "Shop") != nil {
            
            let value =  UserDefaults.standard.value(forKey: "Shop") as? Bool ?? false
            
            if value == true {
                
                let vc = ScreenManager.OffersNew_VC()
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                appDelegate.window?.rootViewController = navController
                appDelegate.window?.makeKeyAndVisible()
                
            }else{
                self.navigationController?.popViewController(animated: true)
            }
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    
    @objc func tapAddTocart(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            UserDefaults.standard.set(true, forKey: "Shop")
            
            let quantity  =  self.filterModelArr[sender.tag].quantity ?? 0
            let currentCartQuantity = self.filterModelArr[sender.tag].cartData.quantity ?? 0
            /*
             if quantity <= currentCartQuantity {
             CommonClass.sharedInstance.callNativeAlert(title: "", message: "Can't add more items than Quantity".localized(), controller: commonController)
             }else{
             
             self.addQuantity(sender.tag, quantity: quantity, currentCartQuantity: currentCartQuantity)
             
             }
             */
            self.addQuantity(sender.tag, quantity: quantity, currentCartQuantity: currentCartQuantity)
            //  self.addCardItem(tag: Int(sender.tag))
        }else{
            
            self.alertWithAction()
        }
        
    }
    
    
    @IBAction func tap_Filter(_ sender: UIButton) {
        let vc = ScreenManager.FilterNewPOPUP_VC()
        
        vc.sortDelegate = self
        
        self.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func tap_Search(_ sender: UIButton) {
        
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
    
}

extension OfferListNew_VC :sortProtocol {
    
    func sorting(orderHighOrLow: Bool, date: String , noSelectionStatus: Bool) {
        
        print(date)
        
        if noSelectionStatus == true && date != ""{
            
            print(self.viewModel.offerListBaseModelArr.first?.Data?.filter)
            self.filterModelArr =  (self.viewModel.offerListBaseModelArr.first?.Data?.filter { $0.endDateForSorting == date })!
            
            if orderHighOrLow == true {
                
                self.filterModelArr = (self.filterModelArr.sorted(by: { $0.offerPrice ?? 0 > $1.offerPrice ?? 0 }))
                
            }else{
                
                self.filterModelArr =   (self.filterModelArr.sorted(by: { $0.offerPrice ?? 0 < $1.offerPrice ?? 0 }))
            }
            
            print("Count After",self.filterModelArr)
            
        }else if date != "" && noSelectionStatus == false {
            
            self.filterModelArr =  (self.viewModel.offerListBaseModelArr.first?.Data?.filter { $0.endDateForSorting == date })!
            
        }else if noSelectionStatus == true {
            
            if orderHighOrLow == true {
                self.filterModelArr = (self.viewModel.offerListBaseModelArr.first?.Data?.sorted(by: { $0.offerPrice ?? 0 > $1.offerPrice ?? 0 }))!
                
            }else{
                self.filterModelArr = (self.viewModel.offerListBaseModelArr.first?.Data?.sorted(by: { $0.offerPrice ?? 0 < $1.offerPrice ?? 0 }))!
            }
        }
        
        //let newArrUsingMap = self.filterModelArr.map { $0.getSortingValue("13/01/2021")  }
        offerTV.reloadData()
        
    }
}

extension OfferListNew_VC : UITextFieldDelegate{
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if string.isEmpty {
            search = String(search.dropLast())
        }else{
            search=textField.text!+string
        }
        debugPrint(search)
        if search != "" {
            self.filterModelArr = (self.viewModel.offerListBaseModelArr.first?.Data?.filter {data in
                
                return (data.productName?.lowercased().contains(search.lowercased()) ?? false)
                
            } ?? [DataOffer]())
        }else{
            self.filterModelArr = (self.viewModel.offerListBaseModelArr.first?.Data)!
        }
        offerTV.reloadData()
        return true
    }
}

extension OfferListNew_VC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filterModelArr.count
        
        //self.viewModel.offerListBaseModelArr.first?.Data?.count ?? 0
        //offerListModelArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = offerTV.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OfferTableViewCellAndXib
        
        cell.configureWith(info: (self.filterModelArr[indexPath.row]))
        
        /*
         cell.configureWith(info: offerListModelArr[indexPath.row])
         cell.imgThumbnail.image = UIImage(named: "\(mainArr[indexPath.row])")
         */
        cell.btnAddToCart.tag = indexPath.row
        cell.btnAddToCart.addTarget(self, action: #selector(tapAddTocart), for: .touchUpInside)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableViewAutomaticDimension
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
           
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ScreenManager.ProductDetailVC()
        vc.icComingFromOffer = true
        vc.comgFromOffer = true
        vc.productId = self.filterModelArr[indexPath.row].Id
        vc.type = "Offer"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension OfferListNew_VC {
    
    //TODO: OfferList API
    func getOfferList(){
        
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        
        if UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? "" == ""{
            let param = ["longitude":GloblaLong ?? "",
                         "latitude":GloblaLat ?? "",
                         "storeCategoryId": self.storeCategoryId ?? "",
                         "langcode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,]
            print(param)
            
            viewModel.getOfferProductListAPI(Domain.baseUrl().appending(APIEndpoint.getOfferProductList), param, header)
            closureSetup()
            
        }else{
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","longitude":GloblaLong ?? "",
                         "latitude":GloblaLat ?? "",
                         "storeCategoryId": self.storeCategoryId ?? "",
                         "langcode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,]
            print(param)
            
            viewModel.getOfferProductListAPI(Domain.baseUrl().appending(APIEndpoint.getOfferProductList), param, header)
            closureSetup()
        }
    }
    
    //TODO: Capture ViewModel Data from GetOfferList API
    func closureSetup(){
        
        viewModel.reloadList = { ()
            self.filterModelArr.removeAll()
            if self.viewModel.offerListBaseModelArr.first?.Data?.count != 0 {
                self.lblNoOffer.isHidden = true
                self.offerTV.isHidden = false
                self.filterModelArr = (self.viewModel.offerListBaseModelArr.first?.Data)!
            }
            else
            {
                self.lblNoOffer.text = "No item Available".localized()
                self.lblNoOffer.isHidden = false
                self.offerTV.isHidden = true
            }
            self.configureCell()
        }
    }
    
    // Add Item
    func addCardItem(tag:Int){
        
        //  self.currentCartQuantity = productListModel?.cartData?.quantity ?? 0
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        
        let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "" ,
                     "productId": self.filterModelArr[tag].Id! ,
                     "langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "en"] as [String:Any]
        
        apiHandle.fetchApiService(method: .post, url: Domain.baseUrl().appending(APIEndpoint.addToCart), passDict: param, header: header) { (result) in
            
            switch result {
            
            case .success(let data):
                
                print(data)
                
                if data["response_message"].stringValue == "Item added to cart successfully" || data["SUCCESS"].stringValue == "SUCCESS" {
                    
                    let vc = ScreenManager.MyCartNew_VC()
                    vc.icComingFromOffer = true
                    vc.comgFromOffer = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                //                else if data["response_message"].stringValue == "Please clear your cart to add this item."{
                //                    self.currentCartQuantity += 1
                //                    minimumPrice = minimumPrice + (self.price)
                //                    self.updateCartItem()
                //                }
                else{
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: data["response_message"].stringValue, controller: commonController)
                }
                
                break
                
            case .failure(let error):
                
                CommonClass.sharedInstance.callNativeAlert(title: "", message: error.localizedDescription, controller: commonController)
                break
                
            }
        }
    }
    
    func addQuantity(_ indexTag:Int , quantity:Int , currentCartQuantity:Int){
        
        guard UserDefaults.standard.bool(forKey: "IsUserLogin") else {
            CommonClass.sharedInstance.alertWithAction()
            return
        }
        
        /*
         self.quantity = self.filterModelArr[tag].quantity ?? 0
         self.productID = "\(productListModel?.Id ?? "")"
         */
        
        print(currentCartQuantity , quantity)
        
        //        if currentCartQuantity < quantity {
        //            if currentCartQuantity > 0{
        //
        //                self.currentCartQuantity = currentCartQuantity
        //
        //                self.currentCartQuantity += 1
        //
        //                self.updateCartItem(tag: indexTag)
        //            }else{
        //
        //                self.addCardItem(tag: indexTag)
        //
        //            }
        //        }else{
        //            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Can't add more items than Quantity".localized(), controller: commonController)
        //        }
        if currentCartQuantity > 0{
            
            self.currentCartQuantity = currentCartQuantity
            
            self.currentCartQuantity += 1
            
            self.updateCartItem(tag: indexTag)
        }else{
            
            self.addCardItem(tag: indexTag)
            
        }
    }
    
    func updateCartItem(tag:Int){
        
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        
        let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                     "productId": self.filterModelArr[tag].Id!,
                     "langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,
                     "quantity":currentCartQuantity.description ] as [String:Any]
        
        print(header,param)
        
        apiHandle.fetchApiService(method: .post, url: Domain.baseUrl().appending(APIEndpoint.updateCart), passDict: param, header: header) { (result) in
            switch result{
            case .success(let data):
                
                print(data)
                
                if data["response_message"].stringValue == "Cart updated successfully" || data["status"].stringValue == "SUCCESS"{
                    
                    let vc = ScreenManager.MyCartNew_VC()
                    vc.icComingFromOffer = true
                    vc.comgFromOffer = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else if data["response_message"].stringValue == "Item removed from your cart successfully"{
                    
                } else{
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: data["response_message"].stringValue, controller: commonController)
                }
                break
            case .failure(let error):
                CommonClass.sharedInstance.callNativeAlert(title: "", message: error.localizedDescription, controller: commonController)
                break
            }
        }
    }
    
    
    
}

