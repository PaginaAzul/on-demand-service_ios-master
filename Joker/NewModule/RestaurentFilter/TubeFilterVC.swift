//
//  TubeFilterVC.swift
//  OWIN
//
//  Created by SinhaAirBook on 06/08/20.
//  Copyright © 2020 Mobulous. All rights reserved.
//

import UIKit
import SwiftyJSON

class TubeFilterVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var lbl_SelectType: UILabel!
    @IBOutlet weak var btn_Grocery: UIButton!
    @IBOutlet weak var btn_Food: UIButton!
    @IBOutlet weak var tableViewMain: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbl_TotalProducts: UILabel!
    @IBOutlet weak var btn_Apply: UIButton!
    @IBOutlet weak var leftBtn1: UIButton!
    @IBOutlet weak var leftBtn2: UIButton!
    @IBOutlet weak var leftBtn3: UIButton!
    @IBOutlet weak var leftBtn4: UIButton!
    @IBOutlet weak var verticalStack: UIStackView!
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    //MARK:- Varibales
    let leftTableArr = ["Type","Distance"]
    var tableArr = [filerValue]()
    var filerTypeSelected: String?
    
    var btnSelect: Int?
 
    var lat: String?
    var long: String?
    
    //var delegate: retureFilterValueDelegate?
    //Filter Checks Variables
    var GTypeName: String?
    var GDistanceName: String?
    
    var FCuisinesName: String?
    var FTypeName: String?
    var FDistanceName: String?
    
    //Variables For Api
    
    var store_type: String = ""
    var cuisine: String = ""
    var categories: String = ""
    var is_veg: String = ""
    var is_non_veg: String = ""
    var rating: String = ""
    var distance: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var isRating: Bool?
    var currentRating: Double = 0.0
    
    
    var CategoryArr = [Category]()
    
    var typeCategory  = [String]()
   var btnClear = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        
        self.initilizeUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      // self.navigationSetUpView()
      
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        self.btn_Apply.addTarget(self, action: #selector(btnApplyFilterTap), for: .touchUpInside)
        
    }
    
    @IBAction func tap_BackBTN(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func tap_clear(_ sender: Any) {
        
        btnClear = true
        btn_Grocery.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
        btn_Food.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
        
        if btn_Grocery.isSelected{
            
            leftBtn4.isHidden = true
            
            ButtonSetup(btn: leftBtn1, text: "Type", textColor: .black, aligment: .left, image: UIImage(), bgColor:  #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1))
            ButtonSetup(btn: leftBtn2, text: "Distance", textColor: .black, aligment: .left, image: UIImage(), bgColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1))
            ButtonSetup(btn: leftBtn3, text: "Preference", textColor: .black, aligment: .left, image: UIImage(), bgColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1))
            
         
            btn_Grocery.isUserInteractionEnabled = true
            btn_Food.isUserInteractionEnabled = true
            
            if self.tableArr.count > 0 {
                self.tableArr.removeAll()
            }
            
          typeCategory = ["Liquor Stores","Pharmacy","Grocery","Household"]
                           
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.configTable(table: self.tableView,identifier: "FilterRightCell")
            }
            
        }else{
            leftBtn4.isHidden = false
            leftBtn3.isHidden = false
            typeCategory = ["Staples","Snacks","Dairy","Household"]
            
            ButtonSetup(btn: leftBtn1, text: "Taste", textColor: .black, aligment: .left, image: UIImage(), bgColor:  #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1))
            ButtonSetup(btn: leftBtn3, text: "Eat Type", textColor: .black, aligment: .left, image: UIImage(), bgColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1))
            ButtonSetup(btn: leftBtn2, text: "Type", textColor: .black, aligment: .left, image: UIImage(), bgColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1))
            ButtonSetup(btn: leftBtn4, text: "Ratings", textColor: .black, aligment: .left, image: UIImage(), bgColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1))
            
            
            btn_Grocery.isUserInteractionEnabled = true
            btn_Food.isUserInteractionEnabled = false
            
            if self.tableArr.count > 0 {
                self.tableArr.removeAll()
            }
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.configTable(table: self.tableView,identifier: "FilterRightCell")
            }
        }
        
        
    }
    
    // MARK: Drag dismiss function
         @objc func handleDismiss(sender: UIPanGestureRecognizer) {
             switch sender.state {
             case .changed:
                 
                 viewTranslation = sender.translation(in: view)
                 if viewTranslation.y > 0 {
                 UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                     self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                 })
                 }
             case .ended:
                 if viewTranslation.y < 100 {
                     UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                         self.view.transform = .identity
                     })
                 } else {
                     dismiss(animated: true, completion: nil)
                 }
             default:
                 break
             }
         }
    
    //TODO: UISetup
    
    internal func initilizeUI(){
        
        if #available(iOS 11.0, *) {
            ButtonSetup(btn: btn_Grocery, text: "", textColor: .black, aligment: .leading, image: #imageLiteral(resourceName: "selected"),bgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            ButtonSetup(btn: btn_Food, text: "", textColor: .black, aligment: .leading, image: #imageLiteral(resourceName: "unselected"),bgColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        } else {
            // Fallback on earlier versions
        }
        
        
        btn_Grocery.setImage(#imageLiteral(resourceName: "radio_s"), for: .normal)
        btn_Grocery.isSelected = true
        btn_Food.isSelected = false
        btn_Food.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
        btn_Grocery.isUserInteractionEnabled = false
        btn_Food.isUserInteractionEnabled = true
       
        leftSideMenuInitilization()
        self.store_type = "2"
        
        ButtonSetup(btn: btn_Apply, text: "Apply Filter", textColor: .white, aligment: .center, image: UIImage(),bgColor: #colorLiteral(red: 0.03607749939, green: 0.572451055, blue: 0.8170866966, alpha: 1))
        lbl_SelectType.text = "Select Type:"
       
        lbl_SelectType.textColor = .black
        btn_Grocery.isSelected = true
        btn_Food.isSelected = false
        //leftSideMenuInitilization()
        btn_Grocery.tag = 1
        btn_Food.tag = 2
        
        btn_Grocery.addTarget(self, action: #selector(filterBntTap(_:)), for: .touchUpInside)
        btn_Food.addTarget(self, action: #selector(filterBntTap(_:)), for: .touchUpInside)
        self.leftBtn1.addTarget(self, action: #selector(filterBntTap(_:)), for: .touchUpInside)
        self.leftBtn2.addTarget(self, action: #selector(filterBntTap(_:)), for: .touchUpInside)
        self.leftBtn3.addTarget(self, action: #selector(filterBntTap(_:)), for: .touchUpInside)
        self.leftBtn4.addTarget(self, action: #selector(filterBntTap(_:)), for: .touchUpInside)
    }
    
    func ButtonSetup(btn: UIButton, text: String ,textColor: UIColor , aligment: UIControl.ContentHorizontalAlignment, image: UIImage,bgColor:UIColor? = nil) {
        btn.setImage(image, for: .normal)
        btn.setTitle("  \(text)", for: .normal)
       // btn.titleLabel?.font = AppFont.Semibold.size(AppFontName.SourceSansPro, size: 16)
        btn.setTitleColor(textColor, for: .normal)
        btn.contentHorizontalAlignment = aligment
        btn.backgroundColor = bgColor
        if aligment == .left{
        btn.titleEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        }
    }
    
    @objc func btnApplyFilterTap(){
        
        if self.cuisine == "" && self.categories == "" && self.distance == "" && self.is_non_veg == "" && self.is_veg == "" && self.rating == "" {
//            _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: "Please select aleast one filter to proceed!", style: AlertStyle.warning)
            
        }else{
            self.dismiss(animated: true) {
             //   self.delegate?.filterValue(self.store_type, self.cuisine, self.categories, self.is_veg, self.is_non_veg, self.rating, self.distance, self.lat ?? "", self.long ?? "")
            }
            
        }
    }
    
    func leftSideMenuInitilization(){
        
        self.isRating = false
        
        if btn_Grocery.isSelected{
            
            leftBtn4.isHidden = true
            
            ButtonSetup(btn: leftBtn1, text: "Type", textColor: .white, aligment: .left, image: UIImage(), bgColor:  #colorLiteral(red: 0.03607749939, green: 0.572451055, blue: 0.8170866966, alpha: 1))
            ButtonSetup(btn: leftBtn2, text: "Distance", textColor: .black, aligment: .left, image: UIImage(), bgColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1))
            ButtonSetup(btn: leftBtn3, text: "Preference", textColor: .black, aligment: .left, image: UIImage(), bgColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1))
            
         
            btn_Grocery.isUserInteractionEnabled = false
            btn_Food.isUserInteractionEnabled = true
            
            if self.tableArr.count > 0 {
                self.tableArr.removeAll()
            }
            
          typeCategory = ["Liquor Stores","Pharmacy","Grocery","Household"]
                       
                           
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.configTable(table: self.tableView,identifier: "FilterRightCell")
            }
            
        }else{
            leftBtn4.isHidden = false
            leftBtn3.isHidden = false
            typeCategory = ["Staples","Snacks","Dairy","Household"]
            
            ButtonSetup(btn: leftBtn1, text: "Taste", textColor: .white, aligment: .left, image: UIImage(), bgColor:  #colorLiteral(red: 0.03607749939, green: 0.572451055, blue: 0.8170866966, alpha: 1))
            ButtonSetup(btn: leftBtn3, text: "Eat Type", textColor: .black, aligment: .left, image: UIImage(), bgColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1))
            ButtonSetup(btn: leftBtn2, text: "Type", textColor: .black, aligment: .left, image: UIImage(), bgColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1))
            ButtonSetup(btn: leftBtn4, text: "Ratings", textColor: .black, aligment: .left, image: UIImage(), bgColor: #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1))
            
            
            btn_Grocery.isUserInteractionEnabled = true
            btn_Food.isUserInteractionEnabled = false
            
            if self.tableArr.count > 0 {
                self.tableArr.removeAll()
            }
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.configTable(table: self.tableView,identifier: "FilterRightCell")
            }
        }
    }
    
    @objc func filterBntTap(_ sender:UIButton){
        self.isRating = false
        if sender.tag == 1{
            
            sender.setImage(#imageLiteral(resourceName: "radio_s"), for: .normal)
            sender.isSelected = true
            btn_Food.isSelected = false
            btn_Food.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            sender.isUserInteractionEnabled = false
            btn_Food.isUserInteractionEnabled = true
          
            leftSideMenuInitilization()
            
            self.store_type = "2" // For Grocery Store Type 2
        }else if sender.tag == 2{
            sender.setImage(#imageLiteral(resourceName: "radio_s"), for: .normal)
            sender.isSelected = true
            btn_Grocery.isSelected = false
            btn_Grocery.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
            sender.isUserInteractionEnabled = false
            btn_Grocery.isUserInteractionEnabled = true
            
            leftSideMenuInitilization()
            
            self.store_type = "1" // For Food Store Type 1
        }else if sender.tag == 3{
            
            
            
            if self.store_type == "1"{
                typeCategory = ["Staples","Snacks","Dairy","Household"]
            }else{
                typeCategory = ["Liquor Stores","Pharmacy","Grocery","Household"]
            }
            
            if btn_Grocery.isSelected{
                
                if self.tableArr.count > 0 {
                    self.tableArr.removeAll()
                }
              
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.configTable(table: self.tableView,identifier: "FilterRightCell")
                }
                
                self.tableView.reloadData()
            }else{
                if self.tableArr.count > 0 {
                    self.tableArr.removeAll()
                }
               
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.configTable(table: self.tableView,identifier: "FilterRightCell")
                }
            }
            sender.setTitleColor(.white, for: .normal)
            sender.backgroundColor = #colorLiteral(red: 0.03607749939, green: 0.572451055, blue: 0.8170866966, alpha: 1)
            self.leftBtn2.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
            self.leftBtn2.titleLabel?.textColor = .black
            self.leftBtn3.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
            self.leftBtn3.titleLabel?.textColor = .black
            self.leftBtn4.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
            self.leftBtn4.titleLabel?.textColor = .black
            
        }else if sender.tag == 4{
            self.tableView.reloadData()
            
        
            leftBtn2.setTitleColor(.white, for: .normal)
            leftBtn2.backgroundColor =  #colorLiteral(red: 0.03607749939, green: 0.572451055, blue: 0.8170866966, alpha: 1)
            self.leftBtn1.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
            self.leftBtn1.titleLabel?.textColor = .black
            self.leftBtn3.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
            self.leftBtn3.titleLabel?.textColor = .black
            self.leftBtn4.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
            self.leftBtn4.titleLabel?.textColor = .black
        }else if sender.tag == 5{
            self.tableView.reloadData()
            if self.tableArr.count > 0 {
                self.tableArr.removeAll()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.configTable(table: self.tableView,identifier: "FilterRightCell")
            }
            leftBtn3.setTitleColor(.white, for: .normal)
            leftBtn3.backgroundColor =  #colorLiteral(red: 0.03607749939, green: 0.572451055, blue: 0.8170866966, alpha: 1)
            self.leftBtn1.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
            self.leftBtn1.titleLabel?.textColor = .black
            self.leftBtn2.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
            self.leftBtn2.titleLabel?.textColor = .black
            self.leftBtn4.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
            self.leftBtn4.titleLabel?.textColor = .black
        }else if sender.tag == 6 {
            self.isRating = true
            self.configTable(table: self.tableView, identifier: "FliterTypeCell")
            
            leftBtn4.setTitleColor(.white, for: .normal)
            leftBtn4.backgroundColor =  #colorLiteral(red: 0.03607749939, green: 0.572451055, blue: 0.8170866966, alpha: 1)
            self.leftBtn1.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
            self.leftBtn1.titleLabel?.textColor = .black
            self.leftBtn2.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
            self.leftBtn2.titleLabel?.textColor = .black
            self.leftBtn3.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
            self.leftBtn3.titleLabel?.textColor = .black
            
        }
    }
}

//MARK:- TableView Setup
//MARK:-
extension TubeFilterVC:UITableViewDelegate,UITableViewDataSource,ReturnNumberOfRatingDelegate{
    
    func noOfRating(_ rating: Double) {
        self.rating = rating.description
        self.currentRating = rating
    }
    
    func configTable(table: UITableView,identifier: String? = nil){
        table.register(UINib(nibName: identifier ?? "", bundle: nil), forCellReuseIdentifier: identifier ?? "")
        table.dataSource = self
        table.delegate = self
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.isRating == true ? 1 : self.typeCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.isRating == true{
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "FliterTypeCell", for: indexPath) as! FliterTypeCell
            cell.view_Rating.rating = self.currentRating
            cell.btnDone.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            cell.delegate = self
            
        return cell
        }else{
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "FilterRightCell", for: indexPath) as! FilterRightCell
            
            cell.btnCheck.tag = indexPath.row
            cell.btnCheck.setTitle("  \(typeCategory[indexPath.row])", for: .normal)
            
            if indexPath.row == 0 {
                
                if btnClear == true{
                    cell.btnCheck.isSelected =  false
                    cell.btnCheck.setImage(#imageLiteral(resourceName: "check_box_un"), for: .normal)
                    cell.btnCheck.setTitleColor(.black, for: .normal)
                }else{
                    cell.btnCheck.isSelected = true
                    cell.btnCheck.setImage(#imageLiteral(resourceName: "check_box_s"), for: .normal)
                    cell.btnCheck.setTitleColor(#colorLiteral(red: 0.03607749939, green: 0.572451055, blue: 0.8170866966, alpha: 1), for: .normal)
                }
                
            }else{
                cell.btnCheck.isSelected =  false
                cell.btnCheck.setImage(#imageLiteral(resourceName: "check_box_un"), for: .normal)
                cell.btnCheck.setTitleColor(.black, for: .normal)
            }
            
            cell.btnCheck.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
            return cell
        }
    }
    
  
    
    @objc func btnClick(_ sender:UIButton){
        
           sender.isSelected = !sender.isSelected
           btnCheckShow(sender)
        
    }
    
    func btnCheckShow(_ sender:UIButton){
        
        if  sender.isSelected{
            sender.setImage(#imageLiteral(resourceName: "check_box_s"), for: .normal)
            sender.setTitleColor(#colorLiteral(red: 0.03607749939, green: 0.572451055, blue: 0.8170866966, alpha: 1), for: .normal)
            
        }else{
            sender.setImage(#imageLiteral(resourceName: "check_box_un"), for: .normal)
            sender.setTitleColor(.black, for: .normal)
            
        }
     
        //self.tableView.reloadData()
    }
    
    
}

struct filerValue {
    
    var name: String
    var id: Int
    var isSelected: Bool
    
}

