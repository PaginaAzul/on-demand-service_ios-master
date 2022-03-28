//
//  NewFilterVCAman.swift
//  JustBite
//
//  Created by Deepti Sharma on 04/02/20.
//  Copyright © 2020 Mobulous. All rights reserved.
//

import UIKit


protocol BackDataToRetDetailsFilter {
    func backDataToDetilsReloadFilter(itemtype:String,taste:String,eatType:String)
}


class NewFilterVCAman:BaseViewController  {
    
    
    @IBOutlet weak var btnTasteRef: UIButton!
    
    @IBOutlet weak var btnSweetRef: UIButton!
    
    @IBOutlet weak var btnSaltyRef: UIButton!
    
    @IBOutlet weak var btnMixedRef: UIButton!
    
    ////////////////////////////
    @IBOutlet weak var btnTypeRef: UIButton!
    
    @IBOutlet weak var btnVegRef: UIButton!
    
    @IBOutlet weak var btnNonVegRef: UIButton!
    
    
    ////////////////////////////
    @IBOutlet weak var btnEatTypeRef: UIButton!
    
    @IBOutlet weak var btnLunchRef: UIButton!
    
    @IBOutlet weak var btnBreakfastRef: UIButton!
    
    @IBOutlet weak var btnDinnerRef: UIButton!
   
    var resturantid = String()
    var categoryid = String()
    var delegateFilter : BackDataToRetDetailsFilter?
    
    var taste = String()
    var itemtype = String()
    var estType = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
         print(resturantid)
        print(categoryid)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnBack(_ sender: UIButton) {
      
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnTasteTapped(_ sender: UIButton) {
        

        btnTasteRef.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        
        if sender.tag == 0{
            btnSweetRef.setImage(#imageLiteral(resourceName: "f_radio_s"), for: .normal)
            btnSaltyRef.setImage(#imageLiteral(resourceName: "f_radio"), for: .normal)
            btnMixedRef.setImage(#imageLiteral(resourceName: "f_radio"), for: .normal)
        }else if sender.tag == 1{
            btnSweetRef.setImage(#imageLiteral(resourceName: "f_radio"), for: .normal)
            btnSaltyRef.setImage(#imageLiteral(resourceName: "f_radio_s"), for: .normal)
            btnMixedRef.setImage(#imageLiteral(resourceName: "f_radio"), for: .normal)
        }else{
            btnSweetRef.setImage(#imageLiteral(resourceName: "f_radio"), for: .normal)
            btnSaltyRef.setImage(#imageLiteral(resourceName: "f_radio"), for: .normal)
            btnMixedRef.setImage(#imageLiteral(resourceName: "f_radio_s"), for: .normal)
        }
        if sender.tag == 0{
            taste = "1"
        }
        else if sender.tag == 1{
            taste = "2"
        }
        else{
            taste = "3"
        }
        
        print("selected taste-->",taste)
        print("selected item-->",itemtype)
        print("selected eat-->",estType)
        
       // delegateFilter?.backDataToDetilsReloadFilter(itemtype: itemtype, taste: taste, eatType: estType)
        
    }
    
    @IBAction func btnTypeTapped(_ sender: UIButton) {
        btnTypeRef.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        if sender.tag == 0{
            btnVegRef.setImage(#imageLiteral(resourceName: "f_radio_s"), for: .normal)
            btnNonVegRef.setImage(#imageLiteral(resourceName: "f_radio"), for: .normal)
        }else{
            btnVegRef.setImage(#imageLiteral(resourceName: "f_radio"), for: .normal)
            btnNonVegRef.setImage(#imageLiteral(resourceName: "f_radio_s"), for: .normal)
        }
        
         if sender.tag == 0{
            itemtype = "0"
        }
        else{
            itemtype = "1"
        }
        print("selected taste-->",taste)
        print("selected item-->",itemtype)
        print("selected eat-->",estType)
       //  delegate?.backDataToDetilsReloadFilter(itemtype: itemtype, taste: taste, eatType: estType)
    }
    
    
    @IBAction func btnEatTypeTapped(_ sender: UIButton) {
        btnEatTypeRef.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        if sender.tag == 0{
            btnLunchRef.setImage(#imageLiteral(resourceName: "f_radio_s"), for: .normal)
            btnBreakfastRef.setImage(#imageLiteral(resourceName: "f_radio"), for: .normal)
            btnDinnerRef.setImage(#imageLiteral(resourceName: "f_radio"), for: .normal)
        }else if sender.tag == 1{
            btnLunchRef.setImage(#imageLiteral(resourceName: "f_radio"), for: .normal)
            btnBreakfastRef.setImage(#imageLiteral(resourceName: "f_radio_s"), for: .normal)
            btnDinnerRef.setImage(#imageLiteral(resourceName: "f_radio"), for: .normal)
        }else{
            btnLunchRef.setImage(#imageLiteral(resourceName: "f_radio"), for: .normal)
            btnBreakfastRef.setImage(#imageLiteral(resourceName: "f_radio"), for: .normal)
            btnDinnerRef.setImage(#imageLiteral(resourceName: "f_radio_s"), for: .normal)
        }
        
        if sender.tag == 0{
            estType = "2"
        }
        else if sender.tag == 1{
            estType = "1"
        }
        else{
            estType = "3"
        }
        print("selected taste-->",taste)
        print("selected item-->",itemtype)
        print("selected eat-->",estType)
        //  delegate?.backDataToDetilsReloadFilter(itemtype: itemtype, taste: taste, eatType: estType)
    }
    
    @IBAction func filterBtnAction(_ sender: Any) {
        print("selected filter taste-->",taste)
        print("selected filter item-->",itemtype)
        print("selected filter eat-->",estType)
        
//        if itemtype == ""{
//             self.delegateFilter?.backDataToDetilsReloadFilter(itemtype:"", taste: self.taste, eatType: self.estType)
//        }
//        else if taste == ""{
//            self.delegateFilter?.backDataToDetilsReloadFilter(itemtype:itemtype, taste: "", eatType: self.estType)
//        }
//        else if estType == ""{
//            self.delegateFilter?.backDataToDetilsReloadFilter(itemtype:itemtype, taste: taste, eatType: "")
//        }
//        else if estType == "" && taste == "" {
//            self.delegateFilter?.backDataToDetilsReloadFilter(itemtype:itemtype, taste: "", eatType: "")
//        }
//        else if estType == "" && itemtype == "" {
//            self.delegateFilter?.backDataToDetilsReloadFilter(itemtype:"", taste: self.taste, eatType: "")
//        }
//        else if taste == "" && itemtype == "" {
//            self.delegateFilter?.backDataToDetilsReloadFilter(itemtype:"", taste: "", eatType: estType)
//        }
//        else{
//            self.delegateFilter?.backDataToDetilsReloadFilter(itemtype: self.itemtype, taste: self.taste, eatType: self.estType)
//        }
      
        self.navigationController?.popViewController(animated: false)
        
    }
    
    
    
    
}
