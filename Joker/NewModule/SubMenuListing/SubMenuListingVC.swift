//
//  SubMenuListingVC.swift
//  JustBite
//
//  Created by Aman on 14/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import UIKit

class CustomizesDataModel{
    
    var itemHeading = String()
    var type = Int()
    var variation = Int()
    var addons = [AddOnDataModel]()
    
    init(itemHeading:String,type:Int,variation:Int,addons:[AddOnDataModel]){
        self.itemHeading = itemHeading
        self.type = type
        self.variation = variation
        self.addons = addons
    }
    
    
    
}

class AddOnDataModel{
    var name = String()
    var id = Int()
    var price = Int()
    var isSelected = Bool()
    init(name:String,id:Int,price:Int,isSelected:Bool){
        self.name = name
        self.id = id
        self.price = price
        self.isSelected = isSelected
        
    }
}

class SubMenuListingVC:  BaseViewController {
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblAddOns: UITableView!
    @IBOutlet weak var btnTotal: UILabel!
    @IBOutlet weak var viewFooter: UIView!
    
    //MARK: - Variables
    internal var previousOffset: CGFloat = 0
    var customizeDataModelArray = [CustomizesDataModel]()
    var addOnDataModelArr = [AddOnDataModel]()
    
    
    var price = Int()
    var quantity = Int()
    var index = Int()
    var totalPrice = Int()
  
    var addOnString = String()
    var addOnArray = [String]()
    var isNewOrder = String()
    var isComing = String()
    var userType = String()
    var catIndex = Int()
    
    //MARK: - View Life Cycle Methods
    //TODO: View didLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addOnDataModelArr.append( AddOnDataModel(name: "Cheeky Chicken", id: 1, price: Int(7.00), isSelected: true))
        addOnDataModelArr.append(AddOnDataModel(name: "Small San Francisco Chicken BBQ", id: 2, price: Int(11.00), isSelected: false))
        addOnDataModelArr.append(AddOnDataModel(name: "Small San Francisco Chicken Fajita", id: 3, price: Int(6.00), isSelected: false))
        addOnDataModelArr.append( AddOnDataModel(name: "Small San Francisco Chicken Hot Stuff", id: 4, price: Int(12.00), isSelected: false))
        addOnDataModelArr.append(AddOnDataModel(name: "Small San Francisco Chicken Classic", id: 5, price: Int(18.00), isSelected: false))
        addOnDataModelArr.append(AddOnDataModel(name: "Small San Francisco Chicken Seafood", id: 6, price: Int(8.00), isSelected: false))
        addOnDataModelArr.append(AddOnDataModel(name: "Small San Francisco Chicken BBQ", id: 7, price: Int(9.00), isSelected: false))
        addOnDataModelArr.append(AddOnDataModel(name: "Small San Francisco Chicken Fajita", id: 8, price: Int(10.00), isSelected: false))
       
        let item = CustomizesDataModel(itemHeading: "", type: 0, variation: 0, addons: addOnDataModelArr)
        
        customizeDataModelArray.append(item)
        
        initialStup()
    }
    
    //TODO: View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Actions,Gesture
    //TODO: Save Actions
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
