//
//  MyCartNew_VC.swift
//  Joker
//
//  Created by cst on 21/10/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit

////// new code

class MyCartNew_VC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var lblNoItemInCart: UILabel!
    @IBOutlet weak var lblHeader: UILabel!

    
    var myCartModelArr = [MyCartModel]()
    var closingTime:String = ""
    let footer:ViewFooterForCartChoice = Bundle.main.loadNibNamed("ViewFooterForCartChoice", owner: self, options: nil)!.last! as! ViewFooterForCartChoice
    
    let Header:CartHeaderView = Bundle.main.loadNibNamed("CartHeaderView", owner: self, options: nil)!.first! as! CartHeaderView
    
    var valueCheckFoodORGrocery = String(),icComingFromOffer = Bool(), comgFromOffer = Bool()
    
    var buildingAndAppNo = String() , resAndStoreId:String? , landMark = String(), long = String() , lat = String() , address = String()
    
    let viewModel = ViewModel()
    var deliverySlot:String? , deliveryTimeSlot:String? , deliveryDate:String? , deliveryDay:String?
    
    var isFromDelivery = String()
    var toclearCart = String()
    let apiHandle = ApiHandler()
    var productID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if toclearCart == "clearCart" {
            self.getClearCartAPI()
            
            
        }
        else {
            self.lblNoItemInCart.font = UIFont.systemFont(ofSize: 15.0)
            lblNoItemInCart.text = "No item".localized()
            btnPay.setTitle("Pay".localized(), for: .normal)
            lblHeader.text = "My Cart".localized()
            self.lblNoItemInCart.isHidden = true
            commonController = self
            self.fetchCartItem()
        }
        
        /*
        if  UserDefaults.standard.value(forKey: "Food") != nil {
            
            valueCheckFoodORGrocery = UserDefaults.standard.value(forKey: "Food") as? String ?? "Restaurent"
            print("valueCheckFoodORGrocery",valueCheckFoodORGrocery)
            
        }
        */
        
        
        
    }
    
    //TODO: Register Nib method
    func registerNib(){
        
        self.tblView.rowHeight = 80
        
        self.tblView.tableFooterView = UIView()
        self.tblView.register(UINib(nibName: "CartTableViewCellAndXib", bundle: nil), forCellReuseIdentifier: "CartTableViewCellAndXib")
        self.tblView.register(UINib(nibName: "eatTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "eatTypeTableViewCell")
        tblView.dataSource = self
        tblView.delegate = self
        tblView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}

//MARK: - IBActions
//TODO:
extension MyCartNew_VC {
    
    //TODO: Back Button Action
    @IBAction func tap_BackBTN(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //Button Place Order Action
    @IBAction func tap_PayTapped(_ sender: Any) {
                
        print("Values",deliveryDate , deliverySlot , deliveryTimeSlot)
        print(self.viewModel.myCartDataArray.first)
        
        let footer:HomeDeleiveryFooterView = Bundle.main.loadNibNamed("HomeDeleiveryFooterView", owner: self, options: nil)!.first! as! HomeDeleiveryFooterView
        
        let itemPrice = self.viewModel.myCartDataArray.first?.Data
        let minimumValue = self.viewModel.deliveryChargeArray.first?.Data?.minimumValue ?? 0
        
        var price = Int()
        for i in 0..<(itemPrice?.count ?? 0){
            if itemPrice?[i].productData?.oStatus == "Active"{
               // print("whenActive...........\(itemPrice?[i].productData?.oStatus)")
                if MyHelper.isValidNewOfferPeriod(endDate: itemPrice?[i].productData?.endDate ?? ""){
                   
                    price += ((itemPrice?[i].productData?.offerPrice ?? 0) * (itemPrice?[i].quantity ?? 0))
                }else{
                   
                    price += ((itemPrice?[i].productData?.price ?? 0) * (itemPrice?[i].quantity ?? 0))
                }
            }else{
                price += ((itemPrice?[i].productData?.price ?? 0) * (itemPrice?[i].quantity ?? 0))
            }
            //price += (((itemPrice?[i].productData?.offerPrice ?? 0) == 0 ? (itemPrice?[i].productData?.price ?? 0):(itemPrice?[i].productData?.offerPrice ?? 0)) * (itemPrice?[i].quantity ?? 0))
        }
        
        
//        let amt = footer.totalAmount.text
//        let split = amt?.components(separatedBy: " ")
//        let actualAmt = Int(split?[0] ?? "")
//        print(footer.totalAmount)
        
        if (self.deliveryTimeSlot == nil  || deliveryDate == nil || deliveryTimeSlot == "") && (valueCheckFoodORGrocery != "Food") {
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please select the schedule delivery day and time slot".localized(), controller: self)
        }
        else if price < minimumValue {
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Minimum order is \(minimumValue)".localized(), controller: self)
        }
//        else if price < 100 || price == 100{
//            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Minimum order is 100".localized(), controller: self)
//        }
        
        else{
            self.apiPlaceOrder()
            
        }
    }
}

extension MyCartNew_VC : getGroceryPlaceOrderProtocol {
    
    func getPlaceOrderData(deliverySlot: String, deliveryTimeSlot: String, deliveryDate: String, deliveryDay: String) {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "YYYY-MM-dd"

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/YYYY"

        let showDate = inputFormatter.date(from: deliveryDate)
        let resultString = outputFormatter.string(from: showDate!)

        print(resultString)
        
        self.deliverySlot = deliverySlot
        self.deliveryTimeSlot = deliveryTimeSlot
        self.deliveryDate = resultString
        self.deliveryDay = deliveryDay
        if self.deliverySlot == "Day not available" {
            self.isFromDelivery = ""
        }
        else
        {
            self.isFromDelivery = "Delivery"

        }
        print("isFromDelivery",self.isFromDelivery)
        print("deliveryDay",self.deliveryDay ?? "")
        print("deliverySlot",self.deliverySlot ?? "")
        print("deliveryTimeSlot",self.deliveryTimeSlot ?? "")
        print("deliveryDate",self.deliveryDate ?? "")
        self.tblView.reloadData()
    }
       
}

//
extension MyCartNew_VC : UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension

    }
    
}

extension MyCartNew_VC : UITableViewDataSource,RefreshPriceDelegate,SavedAddressHistoryDelegate {
    
    
    func returnSavedAddress(address: String, lat: Double, long: Double, purpuse: String) {
        self.address = address
        commonController = self
        self.fetchCartItem()
    }
    
    
    func refreshPrice() {
        self.fetchCartItem()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.myCartDataArray.first?.Data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCellAndXib", for: indexPath) as! CartTableViewCellAndXib
        
        if valueCheckFoodORGrocery == "Food"{
            cell.imgType.isHidden = false
        }else{
            cell.imgType.isHidden = true
            cell.imgVerWidth.constant = 0
            cell.lblWasLeading.constant = 0
        }
        cell.showQunatity = true
        cell.comgFromOffer = comgFromOffer
       
        cell.itemFromCart = self.viewModel.myCartDataArray.first?.Data?[indexPath.row]
        
        cell.delegatePrice = self
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.isFromDelivery == "Delivery" {
            if valueCheckFoodORGrocery == "Food"{
                return 406
            }else{
                return 462
            }
        }
        else
        {
            if valueCheckFoodORGrocery == "Food"{
                return 300
            }else{
                return 352
            }
        }
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer:HomeDeleiveryFooterView = Bundle.main.loadNibNamed("HomeDeleiveryFooterView", owner: self, options: nil)!.first! as! HomeDeleiveryFooterView
        
        footer.lblBillDetails.text?.localized()
        footer.lblITemTotaal.text?.localized()
        footer.lblDeliveryFee.text?.localized()
        footer.lblFixedTotalAmout.text?.localized()
        if self.isFromDelivery == "Delivery" {
            footer.stackVwSchedule.isHidden = false
            footer.lblDeliveryDate.text = "Date : \(self.deliveryDate ?? "")"
            footer.lblDeliveryDay.text = "Day : \(self.deliveryDay ?? "")"
            footer.lblDeliveryTimeSlot.text = "Time Slot : \(self.deliveryTimeSlot ?? "")"
            footer.lblDeliverySlot.text = "Slot : \(self.deliverySlot ?? "")"
        }
        else
        {
            footer.stackVwSchedule.isHidden = true
        }
        if valueCheckFoodORGrocery == "Food"{
            footer.DeliveryView.isHidden = true
            footer.DeliveryViewHeight.constant = 0
        }else{
            footer.DeliveryView.isHidden = false
            footer.DeliveryViewHeight.constant = 45
            footer.btnSchedulDelivery.addTarget(self, action: #selector(scheduleDelivery), for: .touchUpInside)
        }
        
        let attributeString = NSMutableAttributedString(string: "Change".localized())

        attributeString.addAttribute(NSAttributedStringKey.underlineStyle, value: 1, range: NSMakeRange(0, "Change".count))

        footer.btnAdresss.setAttributedTitle(attributeString, for: .normal)
        
        footer.btnAdresss.addTarget(self, action: #selector(EditAddress), for: .touchUpInside)
        
        footer.deliveryPriceValue = self.viewModel.deliveryChargeArray.first?.Data?.deliveryCharge ?? 0
        
        footer.itemPrice = self.viewModel.myCartDataArray.first?.Data
        footer.deliveryPrice = self.viewModel.deliveryChargeArray.first?.Data
        
        
        if let address = UserDefaults.standard.value(forKey: "DefaultAddress") as? String{
            
            self.address = address
            
            self.lat = UserDefaults.standard.value(forKey: "DefaultLat") as? String ?? ""
            
            self.long = UserDefaults.standard.value(forKey: "DefaultLong") as? String ?? ""
            
            self.landMark = UserDefaults.standard.value(forKey: "DefaultLandmark") as? String ?? ""
            
            self.buildingAndAppNo = UserDefaults.standard.value(forKey: "DefaultBuildingAndApart") as? String ?? ""
            
            footer.addressTV.text = address
            
        }else{
            
            if self.address == "" || self.address == nil {
                
                if UserDefaults.standard.value(forKey: "CurrentAdd") != nil {
                    
                    footer.addressTV.text = UserDefaults.standard.value(forKey: "CurrentAdd") as? String
                    self.address = UserDefaults.standard.value(forKey: "CurrentAdd") as? String ?? ""
                    
                }else{
                    footer.addressTV.text = self.address

                }
            }else{
                footer.addressTV.text = self.address
            }
           // UserDefaults.standard.set("\(self.makeAddressString(inArr: addressNew))", forKey: "CurrentAdd")
        }
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    //MARK: - Schedule Delivery
    //TODO: Present Schedule Delivery Controller
    @objc func scheduleDelivery(){
        
        let vc = ScreenManager.GroceryScheduleDeliveryPoPUpVC()
        vc.resAndStoreId = self.viewModel.myCartDataArray.first?.Data?.first?.resAndStoreId
        vc.groceryDelegate = self
        vc.deliverySlot = deliverySlot
        vc.deliveryTimeSlot = deliveryTimeSlot
        vc.deliveryDate = deliveryDate
        vc.deliveryDay = self.deliveryDay
        self.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func EditAddress(){
        
        let vc = ScreenManager.getAddNewAddressVC()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
