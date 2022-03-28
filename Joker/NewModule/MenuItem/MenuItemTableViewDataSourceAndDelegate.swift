//
//  MenuItemTableViewDataSourceAndDelegate.swift
//  JustBite
//
//  Created by Aman on 14/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import Foundation
import UIKit


extension MenuItemsVC:UITableViewDelegate{
    
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableViewAutomaticDimension
       }
       
       func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableViewAutomaticDimension
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  protObj?.backDataToDetilsReload(index1: indexPath.row)
       // self.dismiss(animated: true, completion: nil)
    }
    
   
}

extension MenuItemsVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryDataModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblAddOns.dequeueReusableCell(withIdentifier: MenuItemTableViewCell.className, for: indexPath) as! MenuItemTableViewCell
        
        cell.configure(info:categoryDataModelArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
       UIView.animate(withDuration: 0.4) {
           cell.transform = CGAffineTransform.identity
       }
   }
}
