//
//  GroceryScheduleDeliveryVC.swift
//  Joker
//
//  Created by cst on 23/10/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit
import DropDown


class GroceryScheduleDeliveryVC: UIViewController {
    
    @IBOutlet weak var lblSelectDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblSlot: UILabel!
    @IBOutlet weak var btn_DropDown: UIButton!
    @IBOutlet weak var btnDaySlot: UIButton!
    @IBOutlet weak var scheduleTbl: UITableView!
    @IBOutlet weak var btnOk: UIButton!

    
    var viewModel = ViewModel()
    var resAndStoreId:String?
    var dropDown = DropDown()
    var daySlot = ["Morning".localized() , "Afternoon".localized() , "Evening".localized()]
    
    var morningSlotArr = [String]()
    var afterSlotArr = [String]()
    var eveningSlotArr = [String]()
    
    var daysArr = [String]() , dateArr = [String]()
    var deliverySlot:String? , deliveryTimeSlot:String? , deliveryDate:String? , deliveryDay:String?
    
    var hiddenSections = Set<Int>()
    var englishArr = [String]()
    
    var expand = Bool()
    var groceryDelegate:getGroceryPlaceOrderProtocol?
    var isFirst = Bool()
    var refreshStatus = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnOk.setTitle("Okay".localized(), for: .normal)
        initalSetup()
        lblSelectDay.text?.localized()
        if #available(iOS 11.0, *) {
            self.scheduleTbl.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            scheduleTbl.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: Double.leastNormalMagnitude))

        }

        self.scheduleTbl.contentInset = UIEdgeInsets(top: -25, left: 0, bottom: 0, right: 0)
        
     // scheduleTbl.register(UINib(nibName: "headerSchedule", bundle: nil), forHeaderFooterViewReuseIdentifier: headerSchedule.reuseIdentifier ?? "")
        
    }
    
}






//MARK: - IBActions
//TODO:
extension GroceryScheduleDeliveryVC {
    
    //TODO: Button Ok
    @IBAction func tap_OK(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
           // let deliverySlot = self.viewModel.getDeliverySlotBaseModelArr.first?.Data?.first?.timeSlot ?? "Day not available"
            
            let deliveryTimeSlot =  self.deliveryTimeSlot // self.lblSlot.text ?? ""
            
            let indexOfDay = self.daysArr.index(of: self.lblDate.text ?? "")
            
            let deliveryDay = self.englishArr[indexOfDay ?? 0]

            let deliveryDate = self.dateArr[indexOfDay ?? 0]
                        
            print("-->>> \(deliveryDate) @@ --> @@ ", self.deliverySlot ,deliveryTimeSlot , self.lblDate.text ?? "" , deliveryDay)
            
            self.groceryDelegate?.getPlaceOrderData(deliverySlot: self.deliverySlot ?? "Day not available", deliveryTimeSlot: deliveryTimeSlot ?? "" , deliveryDate: deliveryDate, deliveryDay: deliveryDay)
            
        }
    }
    
    //TODO: Select Day from Drop Down
    @IBAction func tap_Calendar(_ sender: Any) {
        self.setDataOnDropDown(tag:(sender as AnyObject).tag)
        
    }
    
    //TODO: Select shift Slot like morning and evening
    @IBAction func tap_SlotSelect(_ sender: Any) {
        self.setDataOnDropDown(tag:(sender as AnyObject).tag)
        
    }
    
    
}





