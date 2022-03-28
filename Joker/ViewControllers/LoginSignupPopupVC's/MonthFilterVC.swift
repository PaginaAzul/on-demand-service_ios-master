//
//  MonthFilterVC.swift
//  Joker
//
//  Created by Callsoft on 29/01/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import DropDown

protocol FilterMonthOrYearDelegate {
    
    func filterByMonthOrYear(Type:String,value:String)
}

class MonthFilterVC: UIViewController {

    
    @IBOutlet weak var btnMonth: UIButton!
    
    @IBOutlet weak var btnYear: UIButton!
    
    var yearArr = NSMutableArray()
    
    var monthArr = ["Jan","Feb","March","April","May","June","July","Aug","Sep","Oct","Nov","Dec"]
    
    var dropdownTag = 0
    let dropDown = DropDown()
    
    var delegate:FilterMonthOrYearDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        for i in stride(from: 2019, to: 0, by: -1) {
            
            let yearStr = "\(i)"
            var actualYearAppendStr = ""
            
            if yearStr.length == 1{
                
                actualYearAppendStr = "000"+yearStr
            }
            else if yearStr.length == 2{
                
                actualYearAppendStr = "00"+yearStr
            }
            else if yearStr.length == 3{
                
                actualYearAppendStr = "0"+yearStr
            }
            else{
                
                actualYearAppendStr = yearStr
            }
            
            self.yearArr.add(actualYearAppendStr)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            if self.dropdownTag == 0{
                
                self.callDelegate(type: "invoiceYear", value: "\(item)")
            }
            else{
                
                self.callDelegate(type: "invoiceMonth", value: "\(index + 1)")
            }
        }
    }
    
    
    @IBAction func tap_closeBtn(_ sender: Any) {
        
       self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func tap_selectYearBtn(_ sender: Any) {
        
        dropdownTag = 0
        dropDown.dataSource = yearArr as! [String]
        dropDown.anchorView = btnYear
        dropDown.show()
    }
    
    
    @IBAction func tap_selectMonthBtn(_ sender: Any) {
        
        dropdownTag = 1
        dropDown.dataSource = monthArr
        dropDown.anchorView = btnMonth
        dropDown.show()
    }
    
    func callDelegate(type:String,value:String){
        
        self.delegate?.filterByMonthOrYear(Type: type, value: value)
        self.dismiss(animated: true, completion: nil)
    }
   
}
