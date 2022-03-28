//
//  GrocerySchedule+Api.swift
//  Joker
//
//  Created by User on 05/01/21.
//  Copyright © 2021 Callsoft. All rights reserved.
//

import Foundation

//MARK: - EXTENSION CUSTOM METHODS
//TODO:
extension GroceryScheduleDeliveryVC {
    
    //** GET SLOT TIME BY DAY SELECTION FROM TOMORROW TO NEXT 7 DYAS **//
    func getSlotData(_ day:String){
        
        self.isFirst = (self.viewModel.getDeliverySlotBaseModelArr.first?.Data?.count == 0) ? false : true

        commonController = self
        
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        
        
        
        let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "" ,
                     "langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "en",
                     "resAndStoreId":resAndStoreId ?? "",
                     "day":day] as [String : Any]
        
        print("param--At Delivery Slot",param)
        
        viewModel.getDeliverySlotListAPI(Domain.baseUrl().appending(APIEndpoint.getDeliverySlotList), param as [String : Any], header)
        
        self.closureSetup()
        
    }
    
    func closureSetup(){
        
        viewModel.reloadList = { () in
            
            self.morningSlotArr.removeAll()
            self.afterSlotArr.removeAll()
            self.eveningSlotArr.removeAll()
            
            for i in 0..<(self.viewModel.getDeliverySlotBaseModelArr.first?.Data?.count ?? 0){
                
                if self.viewModel.getDeliverySlotBaseModelArr.first?.Data?[i].timeSlot == "Morning" {
                   
                    self.morningSlotArr.append("\(self.viewModel.getDeliverySlotBaseModelArr.first?.Data?[i].openTime ?? "") - \(self.viewModel.getDeliverySlotBaseModelArr.first?.Data?[i].closeTime ?? "")")

                }else if self.viewModel.getDeliverySlotBaseModelArr.first?.Data?[i].timeSlot == "Afternoon"{
                    self.afterSlotArr.append("\(self.viewModel.getDeliverySlotBaseModelArr.first?.Data?[i].openTime ?? "") - \(self.viewModel.getDeliverySlotBaseModelArr.first?.Data?[i].closeTime ?? "")")

                    
                }else if self.viewModel.getDeliverySlotBaseModelArr.first?.Data?[i].timeSlot == "Evening"{
                    
                    self.eveningSlotArr.append("\(self.viewModel.getDeliverySlotBaseModelArr.first?.Data?[i].openTime ?? "") - \(self.viewModel.getDeliverySlotBaseModelArr.first?.Data?[i].closeTime ?? "")")

                }
                
            }
            
            self.isFirst = (self.viewModel.getDeliverySlotBaseModelArr.first?.Data?.count == 0) ? false : true

            self.configure()
            
           // self.lblDay.text =  self.viewModel.getDeliverySlotBaseModelArr.first?.Data?.first?.timeSlot ?? "Day not available"
            
           // self.lblSlot.text = ( self.viewModel.getDeliverySlotBaseModelArr.first?.Data?.count == 0) ? "Slot not available" : "\(self.viewModel.getDeliverySlotBaseModelArr.first?.Data?.first?.openTime ?? "")-\(self.viewModel.getDeliverySlotBaseModelArr.first?.Data?.first?.closeTime ?? "")"
            
        }
        
    }
    
}
