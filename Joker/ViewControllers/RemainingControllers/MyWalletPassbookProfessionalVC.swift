//
//  MyWalletPassbookProfessionalVC.swift
//  Joker
//
//  Created by Callsoft on 31/01/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class MyWalletPassbookProfessionalVC: UIViewController {

    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var headerViewTMyWalletOrPassbook: UIView!
    
    @IBOutlet var newViewHeader: UIView!
    
    @IBOutlet weak var lblAcountBalance: UILabel!
    
    @IBOutlet weak var lblTotalDeliveryRevenue: UILabel!
    
    @IBOutlet weak var lblTax: UILabel!
    
    @IBOutlet weak var lblTotalOrder: UILabel!
    
    let connection = webservices()
    
    var professionalWalletDataArr = NSArray()
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
        
        configureTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let param = ["userType":"ProfessionalWorker","userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? ""]
        
        self.apiCallForGetWalletDataOfProfessionalUser(param: param)
    }
    
    func configureTableView(){
        
        let cellNib = UINib(nibName: "ManageWalletPassbookNewTableViewCell", bundle: nil)
        tableview.register(cellNib, forCellReuseIdentifier: "ManageWalletPassbookNewTableViewCell")
        
        tableview.tableHeaderView = newViewHeader
        tableview.estimatedRowHeight = UITableViewAutomaticDimension
        tableview.tableFooterView = UIView()
        
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    
    @IBAction func tap_newAddMoney(_ sender: Any) {
        
        CommonClass.sharedInstance.callNativeAlert(title: "", message: "Coming Soon...", controller: self)
    }
    
    @IBAction func tap_newManageCards(_ sender: Any) {
        
        CommonClass.sharedInstance.callNativeAlert(title: "", message: "Coming Soon...", controller: self)
    }
    
    @IBAction func tap_newMyBank(_ sender: Any) {
        
        CommonClass.sharedInstance.callNativeAlert(title: "", message: "Coming Soon...", controller: self)
    }
    
    @IBAction func tap_newPayYourCredit(_ sender: Any) {
        
        CommonClass.sharedInstance.callNativeAlert(title: "", message: "Coming Soon...", controller: self)
    }
    
    @IBAction func tap_newOurBankAccount(_ sender: Any) {
        
        CommonClass.sharedInstance.callNativeAlert(title: "", message: "Coming Soon...", controller: self)
    }
    
    @IBAction func tap_newContactAdmin(_ sender: Any) {
        
        let vc = ScreenManager.getContactAdminVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_newDate(_ sender: Any) {
        
        let vc = ScreenManager.getFilterMonthVC()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tap_newFilter(_ sender: Any) {
        
        let vc = ScreenManager.getFilterTransactionVC()
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    @IBAction func tap_addMoneyBtn(_ sender: Any) {
        
        let vc = ScreenManager.getAdd_MoneyVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_manageCardBtn(_ sender: Any) {
        
        let vc = ScreenManager.getManageCardVC()
        vc.controllerName = "ManageWalletPassbook"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_paymYourCreditBtn(_ sender: Any) {
        
        let vc = ScreenManager.getPayYourCreditVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_contactAdminBtn(_ sender: Any) {
        
        let vc = ScreenManager.getContactAdminVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func tap_filterBtn(_ sender: Any) {
        
        let vc = ScreenManager.getFilterTransactionVC()
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tap_dateBtn(_ sender: Any) {
        
        let vc = ScreenManager.getFilterMonthVC()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func tap_myBankBtn(_ sender: Any) {
        
        let vc = ScreenManager.getAddNewBanksVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tap_ourBankAccountBtn(_ sender: Any) {
        
        let vc = ScreenManager.getBankToBankVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateElement(dataDict:NSDictionary){
        
        let orderCount = dataDict.object(forKey: "Order") as? Int ?? 0
        
        if orderCount < 2{
            
            lblTotalOrder.text = "\(orderCount) Order"
        }
        else{
            
            lblTotalOrder.text = "\(orderCount) Orders"
        }
        
    }
}


//MARK: - Extension TableView Controller
extension MyWalletPassbookProfessionalVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return professionalWalletDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "ManageWalletPassbookNewTableViewCell", for: indexPath) as! ManageWalletPassbookNewTableViewCell
      
        let dict = professionalWalletDataArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let dateAndTime = dict.object(forKey: "invoiceCreatedAt") as? String ?? ""
        let deliveryOffer = dict.object(forKey: "invoiceSubtoatl") as? String ?? ""
        let tax = dict.object(forKey: "invoiceTax") as? String ?? ""
        let total = dict.object(forKey: "invoiceTotal") as? String ?? ""
        
        cell.lblDeliveryOffer.text = "\(deliveryOffer) SAR"
        cell.lblTax.text = "\(tax) SAR"
        cell.lblTotal.text = "\(total) SAR"
        
        if dateAndTime != ""{
            
            cell.lblDateAndTime.text = self.fetchData(dateToConvert: dateAndTime)
        }
        else{
            
            cell.lblDateAndTime.text = ""
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func fetchData(dateToConvert:String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let pendingDate = dateFormatter.date(from: dateToConvert)!
        let sendTime = self.dateFormatterForTime.string(from: pendingDate)
        let sendDate = self.dateFormatterForDate.string(from: pendingDate)
        
        return "\(sendDate) \(sendTime)"
    }
 
}

//MARK:- Webservices
//MARK:-
extension MyWalletPassbookProfessionalVC:FilterMonthOrYearDelegate{
    
    func filterByMonthOrYear(Type: String, value: String) {
        
        let param = ["userType":"ProfessionalWorker","userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "","\(Type)":value]
        
        self.apiCallForGetWalletDataOfProfessionalUser(param: param)
    }
 
}

//MARK:- Webservices
//MARK:-
extension MyWalletPassbookProfessionalVC{
    
    func apiCallForGetWalletDataOfProfessionalUser(param:[String:String]){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            print(param)
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithSting(App.URLs.apiCallForGetWalletPassbookInvoiceDetail as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        let invoiceArr = receivedData.object(forKey: "Data1") as? NSArray ?? []
                        
                        self.professionalWalletDataArr = invoiceArr
                        
                        self.updateElement(dataDict: receivedData)
                        
                        self.tableview.reloadData()
                    }
                    else{
                        
                        let msg = receivedData.object(forKey: "response_message") as? String ?? ""
                        
                        if msg == "Invalid Token"{
                            
                            CommonClass.sharedInstance.redirectToHome()
                        }
                        else{
                            
                            CommonClass.sharedInstance.callNativeAlert(title: "", message: msg, controller: self)
                        }
                    }
                }
                else{
                    
                    
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
    }
}
