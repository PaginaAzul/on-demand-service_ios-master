//
//  SearchSubcategoryVC.swift
//  Joker
//
//  Created by retina on 23/06/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit

class SearchSubcategoryVC: UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    var AllData:Array<Dictionary<String,Any>> = []
    var SearchData:Array<Dictionary<String,Any>> = []
    var search:String=""
    var categoryName = ""
    
    var langCategoryName = ""
    
    var categoryID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtSearch.placeHolderColor = UIColor.white
        
        txtSearch.placeholder = "Search".localized()
        
        txtSearch.delegate = self
        
        SearchData = AllData
        
        configureTableView()
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_closeBtn(_ sender: Any) {
        
        search = ""
        txtSearch.text = ""
        SearchData = AllData
       // self.tableview.reloadData()
        self.collectionview.reloadData()
    }
        
}


extension SearchSubcategoryVC{
    
    func configureTableView(){
        
        let cellNib = UINib(nibName: "SearchSubcategoryTableViewCell", bundle: nil)
//        tableview.register(cellNib, forCellReuseIdentifier: "Cell")
//        tableview.rowHeight = 63
//        tableview.tableFooterView = UIView()
        
        collectionview.dataSource = self
        collectionview.delegate = self
        
    }
}


extension SearchSubcategoryVC:UITextFieldDelegate{
    
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
            
            predicate=NSPredicate(format: "SELF.portugueseSubCategoryName CONTAINS[cd] %@", search)
        }
        else{
            
            predicate=NSPredicate(format: "SELF.subCategoryName CONTAINS[cd] %@", search)
        }
       
        let arr=(AllData as NSArray).filtered(using: predicate)
        
        if arr.count > 0
        {
            SearchData.removeAll(keepingCapacity: true)
            SearchData=arr as! Array<Dictionary<String,Any>>
        }
        else
        {
            SearchData=AllData
        }
         self.collectionview.reloadData()
        return true
    }
}


extension SearchSubcategoryVC:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       return SearchData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoriesCollectionViewCell
        
        
        var Data:Dictionary<String,Any> = SearchData[indexPath.row]
        
        if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
            
            let name = Data["portugueseSubCategoryName"] ?? ""
            cell.lblCategoriesName.text = name as? String ?? ""
        }
        else{
            
            let name = Data["subCategoryName"] ?? ""
            cell.lblCategoriesName.text = name as? String ?? ""
        }
        
        let imgStr = Data["image"] as? String ?? ""
        
        if imgStr != ""{
            
            let urlStr = URL(string: imgStr)
            
            if urlStr != nil{
                
                cell.imgView.setImageWith(urlStr!, placeholderImage: UIImage(named: "catImageNew"))
            }
        }
        else{
            
            cell.imgView.image = UIImage(named: "catImageNew")
        }
        
       // cell.selectionStyle = .none
        
        //Round Corners
        cell.imgView.cornerRadius = 8
        cell.imgView.layer.masksToBounds = true
        
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.white.cgColor
        
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        
        //cell.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         var Data:Dictionary<String,Any> = SearchData[indexPath.row]
               
               let name = Data["subCategoryName"] as? String ?? ""
               
               let langSubcategoryName = Data["portugueseSubCategoryName"] as? String ?? ""
               
               let subcategoryId = Data["_id"] as? String ?? ""
               
               UserDefaults.standard.set("", forKey: "RequestDeliveryID")
               
               let vc = ScreenManager.getPrfessionalWorkerGoOrderVC()
               
               vc.comingFrom = "ServiceProviderMap"
               
               vc.categoryName = self.categoryName
               
               vc.subcategoryName = name
               
               vc.categoryId = self.categoryID
               vc.subcategoryId = subcategoryId
               
               vc.langCategoryName = self.langCategoryName
               
               vc.langSubcategoryName = langSubcategoryName
               
               self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //MARK: Tarun Sir Code
        //return CGSize(width: collectionview.frame.size.width/2 - 6, height: collectionview.frame.size.width/2 - 70)
        
        //MARK: - Priyanka Code
        //Start
        //Flow Layout
         let noOfCellsInRow = 2

                let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

                let totalSpace = flowLayout.sectionInset.left
                    + flowLayout.sectionInset.right
                    + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

                let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

                return CGSize(width: size, height: size + 40)
        //End
        
    }
}
