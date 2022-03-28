//
//  SubCategoriesVC.swift
//  Joker
//
//  Created by cst on 24/10/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit

class SubCategoriesVC: UIViewController {
    
    //MARK: - Outlet's
    //TODO:
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblHeader: UILabel!

    
    //MARK: - Variable's
    //TODO:
    var groceryDetailModelArr = [GroceryDetailModel]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //TODO: ViewModel Obj Variable's
    internal var viewModel = ViewModel()
    var categoryId:String?
    var resAndStoreId:String?
    var closingTime:String = ""
    var groceryDataArr : [GroceryData]?
    
    var search:String=""
    var categoryName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
        self.fetchSubCategoryData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchSubCategoryData()
    }
    
}

//MARK: - IBActions
//TODO:
extension SubCategoriesVC {
    
    @IBAction func tapMenu(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        // let vc = ScreenManager.getMoreVC()
        // self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tapCart(_ sender: Any) {
        //let closingTime = UserDefaults.standard.object(forKey: "closingTime") as! String
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
                UserDefaults.standard.removeObject(forKey: "Shop")
                let vc = ScreenManager.MyCartNew_VC()
                vc.comgFromOffer = true
                self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else{
            
            self.alertWithAction()
        }
    }

    
    
}

extension SubCategoriesVC:UITextFieldDelegate{
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if string.isEmpty
        {
            search = String(search.characters.dropLast())
        }
        else
        {
            search=textField.text!+string
        }
        
        print(search)
        
        var predicate = NSPredicate()
        
        if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
            
            predicate = NSPredicate(format: "SELF.portugueseSubCategoryName CONTAINS[cd] %@", search)
        }
        else{
            
            predicate = NSPredicate(format: "SELF.subCategoryName CONTAINS[cd] %@", search)
        }
        
        print("Predicate")
    
            if search != "" {
                groceryDataArr = (self.viewModel.groceryBaseArr.first?.Data?.filter {data in
                    
                    return (data.name?.lowercased().contains(search.lowercased()) ?? false)
                    
                } ?? [GroceryData]())
            }else{
                self.groceryDataArr = self.viewModel.groceryBaseArr.first?.Data
            }
       
        
        self.collectionview.reloadData()
        return true
    }
}
