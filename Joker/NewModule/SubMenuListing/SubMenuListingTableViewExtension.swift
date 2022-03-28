//
//  SubMenuListingTableViewExtension.swift
//  JustBite
//
//  Created by Aman on 14/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import Foundation
import UIKit


extension SubMenuListingVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       // didScrollScrollView(offset: scrollView.contentOffset.y)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if customizeDataModelArray[indexPath.section].type != 1{
            customizeDataModelArray[indexPath.section].addons[indexPath.row].isSelected = !customizeDataModelArray[indexPath.section].addons[indexPath.row].isSelected

        }else{
            for index in 0..<customizeDataModelArray[indexPath.section].addons.count{
                if index == indexPath.row{
                    customizeDataModelArray[indexPath.section].addons[index].isSelected = !customizeDataModelArray[indexPath.section].addons[index].isSelected
                }else{
                    customizeDataModelArray[indexPath.section].addons[index].isSelected = false
                }
            }

        }


        tblAddOns.reloadData()
    }
}

extension SubMenuListingVC:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return customizeDataModelArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customizeDataModelArray[section].addons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
         let cell = tableView.dequeueReusableCell(withIdentifier: ChooseYorTasteTableViewCell.className, for: indexPath) as! ChooseYorTasteTableViewCell
        
        
        if indexPath.row == customizeDataModelArray[indexPath.section].addons.count {
            cell.bottomView.isHidden = true
        }else{
            cell.bottomView.isHidden = false
        }
        
      
        
        cell.configure(info:customizeDataModelArray[indexPath.section].addons[indexPath.row], type: customizeDataModelArray[indexPath.section].type)
        
        return cell
    }

  
    
}
