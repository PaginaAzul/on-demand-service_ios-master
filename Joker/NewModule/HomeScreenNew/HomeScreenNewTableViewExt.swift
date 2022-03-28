//
//  HomeScreenNewTableViewExt.swift
//  Joker
//
//  Created by cst on 23/10/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation

extension HomeScreenNew_VC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0
        {
            return 250
        }else{
            return 300
        }
        
    }
 
    
}

extension HomeScreenNew_VC:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (self.viewModel.offerDataArray.first?.Data?.first?.status ?? "" == "" ) ? 0 : 1
        }else if section == 1{
            return (self.viewModel.homeDataArray.first?.Data?.restaurantList?.count ?? 0 > 0) ? 1: 0
        }else{
            return (self.viewModel.homeDataArray.first?.Data?.storeList?.count ?? 0 > 0) ? 1: 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tblViewHome.dequeueReusableCell(withIdentifier: HomeTableCell.className, for: indexPath) as! HomeTableCell
            
            cell.lbl_ItemType.text = mainArrCate[indexPath.section]
            cell.superVC = self
            cell.collectionView.tag = indexPath.section
            cell.btn_ViewMore.isHidden = true
            
            //pass Data
            cell.ExclusiveOfferArray = (self.viewModel.offerDataArray.first?.Data)!
            cell.collectionView.reloadData()
            return cell
            
        }else if indexPath.section == 1 {
            
            
            let cell = tblViewHome.dequeueReusableCell(withIdentifier: HomeTableCell.className, for: indexPath) as! HomeTableCell
            
            cell.btn_ViewMore.isHidden = false
            cell.lbl_ItemType.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 17.0)!
            cell.lbl_ItemType.textColor = AppColor.textColor
            cell.btn_ViewMore.setTitle("View All".localized(), for: .normal)
            cell.btn_ViewMore.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 15.0)!
            cell.btn_ViewMore.setTitleColor(#colorLiteral(red: 0.03607749939, green: 0.572451055, blue: 0.8170866966, alpha: 1), for: .normal)
            cell.superVC = self
            cell.collectionView.tag = indexPath.section
            
            cell.lbl_ItemType.text = mainArrCate[indexPath.section]
            
            cell.btn_ViewMore.isHidden = false
           
            cell.ResturantDataArray = (self.viewModel.homeDataArray.first?.Data?.restaurantList)!
            cell.collectionView.reloadData()

            return cell
            
        }else{
        
            
            let cell = tblViewHome.dequeueReusableCell(withIdentifier: HomeTableCell.className, for: indexPath) as! HomeTableCell
            
            cell.collectionView.tag = indexPath.section
            
            cell.lbl_ItemType.text = mainArrCate[indexPath.section]
           
            cell.superVC = self
            
            cell.btn_ViewMore.isHidden = false
            cell.lbl_ItemType.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 17.0)!
            cell.lbl_ItemType.textColor = AppColor.textColor
            cell.btn_ViewMore.setTitle("View All".localized(), for: .normal)
            cell.btn_ViewMore.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 15.0)!
            cell.btn_ViewMore.setTitleColor(#colorLiteral(red: 0.03607749939, green: 0.572451055, blue: 0.8170866966, alpha: 1), for: .normal)
            
            cell.StoreDataArray = (self.viewModel.homeDataArray.first?.Data?.storeList)!
            cell.collectionView.reloadData()

            return cell
        }
        
    }
    
    @objc func tapBtnViewAll(_ sender:UIButton){
        
        UserDefaults.standard.set("Food", forKey: "Food")
        
        if sender.tag == 1{
            
            UserDefaults.standard.set("Food", forKey: "Food")
            if self.collectionModelArr.count > 0 {
                
                self.collectionModelArr.removeAll()
                
                self.collectionModelArr.append(homeScreenModel(title: "Raddison Blue", categoryArr: ["North Indian","Italian","Chinese"], address: "L2 Centrestage Mall, Sector 18,Noida", distance: "2.2Km", image: "_image_one"))
                
                self.collectionModelArr.append(homeScreenModel(title: "Raddison Blue", categoryArr: ["North Indian","Italian","Chinese"], address: "L2 Centrestage Mall, Sector 18,Noida", distance: "2.2Km", image: "home_services"))
                
                let vc = ScreenManager.MyFavNew_VC()
                vc.isComing = "View All"
                vc.collectionModelArr = self.collectionModelArr
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else{
            
            if self.collectionModelArr.count > 0 {
                
                
                self.collectionModelArr.removeAll()
                
                self.collectionModelArr.append(homeScreenModel(title: "Big Bazar", categoryArr: [], address: "B-40, Block B sector 2, Noida,Uttar Pradesh,201301", distance: "2.2Km", image: "food"))
                
                self.collectionModelArr.append(homeScreenModel(title: "Max", categoryArr: [], address: "B-40, Block B sector 2, Noida,Uttar Pradesh,201301", distance: "2.2Km", image: "food"))
                
                let vc = ScreenManager.MyFavNew_VC()
                vc.isComing = "View All Grocery"
                
                vc.collectionModelArr = self.collectionModelArr
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }
        
    }
  
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
}
