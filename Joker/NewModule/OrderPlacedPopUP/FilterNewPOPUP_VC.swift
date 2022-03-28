//
//  FilterNewPOPUP_VC.swift
//  Joker
//
//  Created by cst on 30/10/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit
import DatePickerDialog

protocol sortProtocol {
    func sorting(orderHighOrLow:Bool , date:String , noSelectionStatus:Bool)
}


class FilterNewPOPUP_VC: UIViewController {

    @IBOutlet weak var btnApply: UIButton!

    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var btnUnSelect: UIButton!
    @IBOutlet weak var txtFieldDate: UITextField!
    
    @IBOutlet weak var lblDiscounted: UILabel!
    @IBOutlet weak var lblValidity: UILabel!

    var sortDelegate:sortProtocol?
    var defaultDate: Date!
    var tagHigh = true
    
    var selectFilter = Bool()
    var noSelection = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noSelection = true

        tagHigh = true

        lblDiscounted.text = "Discounted Price".localized()
        lblValidity.text = "Validity Date".localized()
        btnApply.setTitle("Apply".localized(), for: .normal)
        btnSelect.setTitle("   High to Low price".localized(), for: .normal)
        btnUnSelect.setTitle("   Low to High price".localized(), for: .normal)
        // Do any additional setup after loading the view.
    }
    
        
    @IBAction func tap_Calendar(_ sender: Any) {
      
            datePickerTapped()

    }
    
   @IBAction func btnSelectFilter(_ sender:UIButton){
          
          if sender.tag == 1{
            noSelection = true
              tagHigh = true
            
              btnSelect.setImage(#imageLiteral(resourceName: "radio_1s"), for: .normal)
              
              btnUnSelect.setImage(#imageLiteral(resourceName: "radio_1un"), for: .normal)
              
          }else if sender.tag == 2{
            
             tagHigh = false

             btnSelect.setImage(#imageLiteral(resourceName: "radio_1un"), for: .normal)
              
            btnUnSelect.setImage(#imageLiteral(resourceName: "radio_1s"), for: .normal)
            noSelection = true
              
        }
        
    }
    
    @IBAction func btnApply(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            
            self.sortDelegate?.sorting(orderHighOrLow: self.tagHigh, date: self.txtFieldDate.text ?? "", noSelectionStatus: self.noSelection)
            
        }
    }
    
    
    
    func datePickerTapped() {
        
        
       let setLocale  = Localize.currentLanguage()
        
        DatePickerDialog(locale: Locale(identifier: setLocale)).show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) { date in
                if let dt = date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy"
                    self.txtFieldDate.text = formatter.string(from: dt)
                    
                }
        }
        
      }
    
    
   
}
