//
//  ProductListingNew_VC.swift
//  Joker
//
//  Created by cst on 22/10/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit

/////New code

class ProductListingNew_VC: UIViewController {
    
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var btnBottomCart: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var myCartModelArr = [OfferListModel]()
    
    internal var viewModel = ViewModel()
    
    var resAndStoreId:String? , subCategoryName:String? , comgFromOffer = Bool() , search:String=""
    var productListArr : [ProductList]?
    var closingTime:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.delegate = self
        lblHeader.text = "Product".localized()
        btnBottomCart.setTitle("Add to cart".localized(), for: .normal)
        txtSearch.placeholder = "Search products".localized()
        
        /*
        
        myCartModelArr.append(OfferListModel(title: "Corn Flakes", shopName: "99 Store", productDetail: "Lorem ipsum dolor sit amet, Lorem consectetur adipiscing elit.", price: "Kz 7.00", lastPrice: "Kz.9.00",imageProduct: "item_a"))
        
        myCartModelArr.append(OfferListModel(title: "Chocos", shopName: "99 Store", productDetail: "Lorem ipsum dolor sit amet, Lorem consectetur adipiscing elit.", price: "Kz 8.00", lastPrice: "Kz.9.00",imageProduct:"item_b"))
        
        
        myCartModelArr.append(OfferListModel(title: "Corn Flakes", shopName: "99 Store", productDetail: "Lorem ipsum dolor sit amet, Lorem consectetur adipiscing elit.", price: "Kz 7.00", lastPrice: "Kz.9.00",imageProduct: "item_a"))
        
        myCartModelArr.append(OfferListModel(title: "Chocos", shopName: "99 Store", productDetail: "Lorem ipsum dolor sit amet, Lorem consectetur adipiscing elit.", price: "Kz 8.00", lastPrice: "Kz.9.00",imageProduct:"item_b"))
        */
        
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.fetchProductList()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {

    }
}


//MARK: - IBActions
//TODO:
extension ProductListingNew_VC {
    
    //TODO: - Back Button
    @IBAction func tap_BackBTN(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    //TODO: - Cart Button
    @IBAction func tap_cartBtn(_ sender: Any) {
       
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){

           
                let vc = ScreenManager.MyCartNew_VC()
                vc.comgFromOffer  = true
                vc.resAndStoreId = self.resAndStoreId
                vc.closingTime = closingTime
                self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            
            self.alertWithAction()
        }
        
    }

}
