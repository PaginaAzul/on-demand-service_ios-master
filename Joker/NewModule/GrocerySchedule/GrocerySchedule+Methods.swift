//
//  GrocerySchedule+Methods.swift
//  Joker
//
//  Created by User on 05/01/21.
//  Copyright © 2021 Callsoft. All rights reserved.
//

import Foundation
import DropDown
import DatePickerDialog

//MARK: - OPTIONAL PROTOCOL

 protocol getGroceryPlaceOrderProtocol {
    
    
     func getPlaceOrderData(deliverySlot:String ,deliveryTimeSlot:String ,deliveryDate:String , deliveryDay:String)
    
}

//MARK: - Extension Custom Methods
//TODO:
extension GroceryScheduleDeliveryVC {
    
    //** INITIAL SETUP **//
     func initalSetup(){
        
        englishArr = Date.getDaysInEnglish(forLastNDays: 7)
        daysArr = Date.getDaysFromCurrent(forLastNDays: 7)
        dateArr = Date.getDates(forLastNDays: 7)
        
        self.lblSelectDay.text = "Select Day".localized()
       
        if self.deliveryDate == nil {

           // self.getSlotData(daysArr[0])
           // self.lblDate.text = daysArr[0]
            self.lblDate.text = "Choose delivery day".localized()
            self.lblDay.text = "Select Time Slot".localized()
            self.lblSlot.text = "-"
            self.getSlotData("")

        }else{
            
            let selectedDay = self.deliveryDay ?? ""
            
            self.lblDate.text = selectedDay.localized()
            self.lblDay.text = self.deliverySlot ?? ""
            self.lblSlot.text = self.deliveryTimeSlot ?? ""
            self.getSlotData(self.deliveryDay ?? "")
        }
        
        self.btnDaySlot.isHidden = true
       
        
    }

    func configure(){
        
         let nib = UINib(nibName: "headerSchedule", bundle: nil)
         self.scheduleTbl.register(nib, forHeaderFooterViewReuseIdentifier: "headerSchedule")
         
         self.scheduleTbl.register(UINib(nibName: "scheduleCell", bundle: nil), forCellReuseIdentifier: "scheduleCell")

         self.scheduleTbl.delegate = self
         self.scheduleTbl.dataSource = self
         self.scheduleTbl.reloadData()
    }
    
    //TODO: Drop Down
    func setDataOnDropDown(tag:Int){
        
        dropDown.dataSource.removeAll()
        
        if tag == 1 {
            
            dropDown.dataSource = daysArr
            dropDown.anchorView = self.btn_DropDown
            DropDown.appearance().selectionBackgroundColor = UIColor.clear
            dropDown.backgroundColor = UIColor.white
            
            dropDown.selectionAction = { [] (index: Int, item: String) in
                self.lblDate.text = item
                
                let deliveryDay = self.englishArr[index ?? 0]
                
                    self.deliveryDay = ""
                    self.deliveryTimeSlot = ""
                
                self.getSlotData(deliveryDay)
                
            }
            
        }else{
            
            if self.viewModel.getDeliverySlotBaseModelArr.first?.Data?.count ?? 0 > 1{
                self.btnDaySlot.isHidden = false
            }else{
                self.btnDaySlot.isHidden = true
            }
            
            for i in (0..<(self.viewModel.getDeliverySlotBaseModelArr.first?.Data?.count ?? 0)){
                let daySlot = (self.viewModel.getDeliverySlotBaseModelArr.first?.Data?[i].timeSlot)!
                dropDown.dataSource.append(daySlot)
            }
            
            dropDown.anchorView = self.btnDaySlot
            DropDown.appearance().selectionBackgroundColor = UIColor.clear
            dropDown.backgroundColor = UIColor.white
            dropDown.selectionAction = { [] (index: Int, item: String) in
                
                self.lblDay.text = item
                
            }
            
        }
        
        dropDown.show()
    }

    
    func datePickerTapped() {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            
            if let dt = date {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                self.lblDate.text = formatter.string(from: dt)
                
            }
        }
    }
    
}



//MARK: - PROTOCOL INHERITANCE
//TODO: EXTNESION : INHERITED ReloadTablePro PROTOCOL BY GroceryScheduleDeliveryVC
extension GroceryScheduleDeliveryVC : ReloadTablePro , GetTimeProtocol  {
    
    func getSlotAndTime(_ slot: String, time: String) {
        //var deliverySlot:String? , deliveryTimeSlot:String? , deliveryDate:String? , deliveryDay:String?
        self.deliveryTimeSlot = time
        self.deliverySlot = slot
    }
    

    
    
    func reloadProStatus(_ tag: Int) {
        refreshStatus = true
        if tag == 0 {
            
            self.scheduleTbl.reloadSections(IndexSet(integer: 1), with: .none)
            self.scheduleTbl.reloadSections(IndexSet(integer: 2), with: .none)
            refreshStatus = false
        }
        
        if tag == 1 {
            
            self.scheduleTbl.reloadSections(IndexSet(integer: 0), with: .none)
            self.scheduleTbl.reloadSections(IndexSet(integer: 2), with: .none)
            refreshStatus = false

        }
        
        if tag == 2 {
            
            self.scheduleTbl.reloadSections(IndexSet(integer: 0), with: .none)
            self.scheduleTbl.reloadSections(IndexSet(integer: 1), with: .none)
            refreshStatus = false

        }
    }
    
}
