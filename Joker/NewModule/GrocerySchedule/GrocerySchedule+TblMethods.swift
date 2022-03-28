//
//  GrocerySchedule+TblMethods.swift
//  Joker
//
//  Created by User on 05/01/21.
//  Copyright © 2021 Callsoft. All rights reserved.
//

import Foundation

extension GroceryScheduleDeliveryVC : UITableViewDelegate, UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hiddenSections.contains(section) {
            return 0
        }
        

        
        if self.isFirst {
            return 1

        }else{
            return 0

        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! scheduleCell
        
        cell.section = indexPath.section
        cell.lblNoSlots.isHidden = true
        cell.reloadTableDelegate = self
        cell.getTimeDelegat = self
        cell.scheduleColl.tag = indexPath.section
        
        /*
        if self.deliverySlot == "Afternoon"
        if self.deliverySlot == "Morning"
        */
        
        
        
        if indexPath.section == 0{
            if refreshStatus != true {

            if self.deliverySlot == "Morning" {
                print("Your Selected Slot - Morning")
                
                cell.selectedMorningSlot = true
                cell.selectedTime = self.deliveryTimeSlot ?? ""
                }
                /*
                cell.selection = true
                cell.isSelectedCell =  true
                
                
                for i in 0..<self.morningSlotArr.count {
                    if self.deliveryTimeSlot == self.morningSlotArr[i]{
                        cell.selectedIndex = i
                        break
                    }
                }
                */
               // cell.selectedTime = self.deliveryTimeSlot ?? ""

            }

            cell.lblNoSlots.isHidden = (morningSlotArr.count == 0 ? false : true)
            
        }else if indexPath.section == 1 {
            if refreshStatus != true {
            if self.deliverySlot == "Afternoon" {
               
                cell.selectedAfterNoonSlot = true
                cell.selectedTime = self.deliveryTimeSlot ?? ""
                
                print("Your Selected Slot - AfterNoon")
                
               // cell.selection = true
               // cell.isSelectedCell =  true
               // cell.selectedTime = self.deliveryTimeSlot ?? ""
                
                /*
                for i in 0..<self.afterSlotArr.count {
                    if self.deliveryTimeSlot == self.afterSlotArr[i]{
                        cell.selectedIndex = i
                        break
                    }
                }
                */
                
            }
            }
            cell.lblNoSlots.isHidden = (afterSlotArr.count == 0 ? false : true)

        }else{
            if refreshStatus != true {
            if self.deliverySlot == "Evening" {
                
                print("Your Selected Slot - Evening")
                
                    cell.selectedEveningSlot = true
                    cell.selectedTime = self.deliveryTimeSlot ?? ""
                }
               
                /*
                cell.selection = true
                cell.isSelectedCell =  true
                
                */
//                for i in 0..<self.eveningSlotArr.count {
//                    if self.deliveryTimeSlot == self.eveningSlotArr[i]{
//                        cell.selectedIndex = i
//                        break
//                    }
//                }
                
            }
            
            cell.lblNoSlots.isHidden = (eveningSlotArr.count == 0 ? false : true)
        }
        
        cell.itemSchedule = self.viewModel.getDeliverySlotBaseModelArr
        
        return cell
        
    }
    
 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
 
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerSchedule") as! headerSchedule

        headerView.btnExpand.setImage(#imageLiteral(resourceName: "down_arrow"), for: .normal)

        if (self.morningSlotArr.count != 0) && section == 0 {
            if expand {
                headerView.btnExpand.setImage(#imageLiteral(resourceName: "down_arrow"), for: .normal)

            }else{
                headerView.btnExpand.setImage(#imageLiteral(resourceName: "up_arrow"), for: .normal)

            }
        }
        
        if (self.afterSlotArr.count != 0) && section == 1 {
            if expand {
                headerView.btnExpand.setImage(#imageLiteral(resourceName: "down_arrow"), for: .normal)

            }else{
                headerView.btnExpand.setImage(#imageLiteral(resourceName: "up_arrow"), for: .normal)

            }
        }
        
        if (self.eveningSlotArr.count != 0) && section == 2 {
            if expand {
                headerView.btnExpand.setImage(#imageLiteral(resourceName: "down_arrow"), for: .normal)

            }else{
                headerView.btnExpand.setImage(#imageLiteral(resourceName: "up_arrow"), for: .normal)

            }
        }
        
       
        
        headerView.lblSlot.text = daySlot[section]
        headerView.btnExpand.tag = section
        headerView.btnExpand.addTarget(self, action: #selector(hideSection) , for: .touchUpInside)

        return headerView
    }

     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
   
    //** hide rows on specific section **//
    @objc private func hideSection(sender: UIButton) {
        // Create section let
        // Add indexPathsForSection method
        // Logic to add/remove sections to/from hiddenSections, and delete and insert functionality for tableView
        if  self.viewModel.getDeliverySlotBaseModelArr.first?.Data?.count ?? 0 > 0 {
            let section = sender.tag
            
            func indexPathsForSection() -> [IndexPath] {
                var indexPaths = [IndexPath]()
                
                indexPaths.append(IndexPath(row: 0,
                                            section: section))
                
                return indexPaths
            }
            
            if self.hiddenSections.contains(section) {
                self.hiddenSections.remove(section)
                self.scheduleTbl.insertRows(at: indexPathsForSection(),
                                            with: .fade)
                expand = false
                
            } else {
                self.hiddenSections.insert(section)
                self.scheduleTbl.deleteRows(at: indexPathsForSection(),
                                            with: .fade)
                expand = true

            }
            
            scheduleTbl.reloadSections(IndexSet(integer: section), with: .none)
        }
        
        

    }
    
    
}
