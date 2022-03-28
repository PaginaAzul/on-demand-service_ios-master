//
//  NewSubcategoryViewController.swift
//  Joker
//
//  Created by retina on 16/06/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit

class NewSubcategoryViewController: UIViewController {

    @IBOutlet weak var lblCategoryName: UILabel!
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    let connection = webservices()
    
    var categoryID = ""
    var categoryName = ""
    var globalLangCatName = ""
    
    var categoryArr = NSArray()
    
    var AllData:Array<Dictionary<String,Any>> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionview.dataSource = self
        collectionview.delegate = self
        
        self.apiCallForGetSubCategoryList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
            
            lblCategoryName.text = globalLangCatName
        }
        else{
            
            lblCategoryName.text = categoryName
        }
    }
    
    
    @IBAction func tap_searchIcon(_ sender: Any) {
        
        if self.categoryArr.count != 0{
            
            let vc = ScreenManager.getSearchSubcategoryVC()
            
            vc.AllData = self.AllData
            
            vc.categoryName = self.categoryName
            
            vc.categoryID = self.categoryID
            
            vc.langCategoryName = globalLangCatName
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension NewSubcategoryViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoriesCollectionViewCell
        
        let dict = categoryArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let subCatName = dict.object(forKey: "subCategoryName") as? String ?? ""
        
        let subcategoryLang = dict.object(forKey: "portugueseSubCategoryName") as? String ?? ""
        
        if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
            
            cell.lblCategoriesName.text = subcategoryLang
        }
        else{
            
            cell.lblCategoriesName.text = subCatName
        }
        
        let imgStr = dict.object(forKey: "image") as? String ?? ""
        if imgStr != ""{
            
            let urlStr = URL(string: imgStr)
            cell.imgView.setImageWith(urlStr!, placeholderImage: UIImage(named: "catImageNew"))
        }
        
        
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
        
        UserDefaults.standard.set("", forKey: "RequestDeliveryID")
        
        let vc = ScreenManager.getPrfessionalWorkerGoOrderVC()
        
        vc.comingFrom = "ServiceProviderMap"
        
        vc.categoryName = self.categoryName
        
        let dict = categoryArr.object(at: indexPath.row) as? NSDictionary ?? [:]
        
        let subCateName = dict.object(forKey: "subCategoryName") as? String ?? ""
        
        let subcategoryLang = dict.object(forKey: "portugueseSubCategoryName") as? String ?? ""
        
        let subCategoryId = dict.object(forKey: "_id") as? String ?? ""
        
        vc.subcategoryId = subCategoryId
        
        vc.subcategoryName = subCateName
        vc.categoryId = self.categoryID
        
        vc.langCategoryName = globalLangCatName
        vc.langSubcategoryName = subcategoryLang
        
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


extension NewSubcategoryViewController{
    
    func apiCallForGetSubCategoryList(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            let param = ["categoryId":categoryID]
            
            IJProgressView.shared.showProgressView(view: self.view)
            self.connection.startConnectionWithStingWithoutToken(App.URLs.apiCallForGetSubCategory as NSString, method_type: methodType.post, params: param as [NSString : NSObject]) { (receivedData) in
                
                print(receivedData)
                
                IJProgressView.shared.hideProgressView()
                
                if self.connection.responseCode == 1{
                    
                    let status = receivedData.object(forKey: "status") as? String ?? ""
                    if status == "SUCCESS"{
                        
                        
                      //  self.AllData = receivedData.object(forKey: "response") as? Array ?? []
                        
                        if let arr = receivedData.object(forKey: "response") as? NSArray{
                            
                            self.categoryArr = arr
                            
                            for i in 0..<arr.count{
                                
                                if let dict = arr.object(at: i) as? Dictionary<String, Any>{
                                    
                                    print(dict)
                                    self.AllData.append(dict)
                                }
                                
                            }
                            
                            print(self.AllData)
                            
                            self.collectionview.reloadData()
                            
                        }
                        
                    }
                    else{
                        
                        
                    }
                }
                else{
                    
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: "Something Went Wrong", controller: self)
                }
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
}
