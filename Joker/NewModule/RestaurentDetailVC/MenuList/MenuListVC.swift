//
//  MenuListVC.swift
//  Joker
//
//  Created by User on 04/01/21.
//  Copyright © 2021 Callsoft. All rights reserved.
//

import UIKit

class MenuListVC: UIViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblCart: UITableView!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var titleHeader: UILabel!


    
    let viewModel = ViewModel()
    var tblArr : [NewRestaurantList]?
    
    var id = String()
    var cuisineName:String?
    var search:String=""
    var closingTime:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.placeholder = "Search products".localized()
        btnAddToCart.setTitle("Add To Cart".localized(), for: .normal)
        self.tblCart.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0);
        titleHeader.text = cuisineName
        txtSearch.delegate = self
        self.fetchMenuData(cuisineName ?? "")
        self.btnAddToCart.addTarget(self, action: #selector(addToCartAction), for: .touchUpInside)
        self.btnBack.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
   
    //TODO: POP Action
    @objc private func buttonAction(sender: UIButton!) {
        self.navigationController?.popViewController(animated: false)
    }
    
    //TODO: Navigate on ADD TO CART
    @objc func addToCartAction(sender: UIButton!) {

        if UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? "" == ""{
            CommonClass.sharedInstance.alertWithAction()
        }else{
            
            let vc = ScreenManager.MyCartNew_VC()
            self.navigationController?.pushViewController(vc, animated: false)
            
        }
    }


    //MARK:- getMenuDataService...
    
    func fetchMenuData(_ item: String){
        commonController = self
        
        self.viewModel.restaurantBaseModelArr.removeAll()
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
            let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                         "resAndStoreId": self.id,
                         "langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,
                         "cuisine":item] as [String:Any]
            viewModel.getMenuDataService(Domain.baseUrl().appending(APIEndpoint.getMenuData), param,header)

        }else{
            
            let param = [
                "resAndStoreId": self.id,
                "langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ,
                "cuisine":item] as [String:Any]
            viewModel.getMenuDataService(Domain.baseUrl().appending(APIEndpoint.getMenuData), param)
        }
       
        clouserSetup()
        
    }
    
    func clouserSetup(){
      
        viewModel.errorMessage = { (message) in
            print(message)
            CommonClass.sharedInstance.callNativeAlert(title: "", message: message, controller: self)
        }
        
        viewModel.success = {(message) in
            if self.viewModel.restaurantBaseModelArr.first?.Data?.restaurantList?.count != 0 {
                self.configTable((self.viewModel.restaurantBaseModelArr.first?.Data?.restaurantList)!)
            }
        }
        
    }
    
    func configTable(_ data:[NewRestaurantList]){
        
        tblCart.dataSource = self
        tblCart.delegate = self
        
        self.tblCart.tableFooterView = UIView()
        self.tblCart.register(UINib(nibName: "CartTableViewCellAndXib", bundle: nil), forCellReuseIdentifier: "CartTableViewCellAndXib")
        
        tblCart.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        self.tblArr = data
        self.tblCart.reloadData()
    }
}

//MARK: - EXTENSION UITABLEVIEW DATASOURCE
extension MenuListVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension

    }
    
}

//MARK: - EXTENSION UITABLEVIEW DATASOURCE
extension MenuListVC:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.tblArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblCart.dequeueReusableCell(withIdentifier: CartTableViewCellAndXib.className) as! CartTableViewCellAndXib
           
        
        cell.btnPlusRef.tag = indexPath.row
        
        cell.btnMinusRef.tag = indexPath.row
        cell.closingTime = closingTime
        //cell.itemMenuList = self.tblArr?[indexPath.row]
        cell.restListModel = self.tblArr?[indexPath.row]
        cell.btnCustomizeRef.isHidden = true
        cell.cellType = CellType.restaurant
        cell.vc = self
        return cell
    }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
}



// MARK: - Search extensions
extension MenuListVC:UITextFieldDelegate{
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if string.isEmpty
        {
            search = String(search.dropLast())
        }
        else
        {
            search=textField.text!+string
        }
        
        print(search)
     
        if search != "" {
            
            tblArr = (self.viewModel.restaurantBaseModelArr.first?.Data?.restaurantList?.filter {data in
                
                return (data.productName?.lowercased().contains(search.lowercased()) ?? false)
                
            } ?? [NewRestaurantList]())
        }else{
            self.tblArr = self.viewModel.restaurantBaseModelArr.first?.Data?.restaurantList
        }
        
        self.tblCart.reloadData()
        return true
    }
    
    
}

