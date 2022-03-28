

import Foundation
import UIKit


//MARK: UITableViewDelegate
//TODO:
extension MyOrderOngoingVC:UITableViewDelegate , deleteHeader {
    func deleteOrder(_ tag: Int, message: String) {
        
        CommonClass.sharedInstance.callNativeAlert(title: "", message: message, controller: self)
        
        if tag == 1{
            getOrder("Ongoing")
            
        }else{
            getOrder("Upcoming")
            
        }
    }
    
   
//    func deleteOrder(_ tag: Int ) {
//
//        if tag == 1{
//            getOrder("Ongoing")
//
//        }else{
//            getOrder("Upcoming")
//
//        }
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.getOrderRootArray.first?.Data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if btnTag == 1 {
            
            if self.viewModel.getOrderRootArray.first?.Data?[section].isSelected == true && isExpandViewMore == 1{
                return self.viewModel.getOrderRootArray.first?.Data?[section].orderData?.count ?? 0 > 1 ? 2 : 1
            }else if  self.viewModel.getOrderRootArray.first?.Data?[section].isSelected == true && isExpandViewMore == 2{
                return self.viewModel.getOrderRootArray.first?.Data?[section].orderData?.count ?? 0
            }else{
                return 0
            }
            
        }else if btnTag == 2{
            
            if self.viewModel.getOrderRootArray.first?.Data?[section].isSelected == true && isExpandViewMore == 1{
                return self.viewModel.getOrderRootArray.first?.Data?[section].orderData?.count ?? 0 > 1 ? 2 : 1
            }else if  self.viewModel.getOrderRootArray.first?.Data?[section].isSelected == true && isExpandViewMore == 2{
                return self.viewModel.getOrderRootArray.first?.Data?[section].orderData?.count ?? 0
            }else{
                return 0
            }
            
        }else{
            
            if self.viewModel.getOrderRootArray.first?.Data?[section].isSelected == true && isExpandViewMore == 1{
                return self.viewModel.getOrderRootArray.first?.Data?[section].orderData?.count ?? 0 > 1 ? 2 : 1
            }else if  self.viewModel.getOrderRootArray.first?.Data?[section].isSelected == true && isExpandViewMore == 2{
                return self.viewModel.getOrderRootArray.first?.Data?[section].orderData?.count ?? 0
            }else{
                return 0
            }
            
        }
    }
    
}



//MARK: UITableViewDataSource
//TODO:
extension MyOrderOngoingVC:UITableViewDataSource{
 
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if btnTag == 1{
            
            let cell = tblViewHome.dequeueReusableCell(withIdentifier: InnerTableViewCell.className, for: indexPath) as! InnerTableViewCell
            
            cell.item = self.viewModel.getOrderRootArray.first?.Data?[indexPath.section].orderData?[indexPath.row]
            
            cell.imgSymbol.isHidden = false
            
            return cell
            
        }else if btnTag == 2{
            
            let cell = tblViewHome.dequeueReusableCell(withIdentifier: InnerTableViewCell.className, for: indexPath) as! InnerTableViewCell
            
            cell.item = self.viewModel.getOrderRootArray.first?.Data?[indexPath.section].orderData?[indexPath.row]
            
            cell.imgSymbol.isHidden = false
            
            return cell
            
        }
        
        else{
            let cell = tblViewHome.dequeueReusableCell(withIdentifier: InnerTableViewCell.className, for: indexPath) as! InnerTableViewCell
            
            cell.item = self.viewModel.getOrderRootArray.first?.Data?[indexPath.section].orderData?[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
        
    }
        
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
        if self.btnTag == 1{
            let header:MyOrderOnGoingHeaderView = Bundle.main.loadNibNamed(MyOrderOnGoingHeaderView.className, owner: self, options: nil)!.first! as! MyOrderOnGoingHeaderView
            
            header.itemOnGoing = self.viewModel.getOrderRootArray.first?.Data?[section]
            header.deleteHeaderDelegate = self
            header.selectedTab = self.btnTag
            header.btnTap.tag = section
            header.btnTap.addTarget(self, action: #selector(self.tapSectionBtn(sender:)), for: UIControl.Event.touchUpInside)
            
            return header
            
        }else if self.btnTag == 2{
            
            let header:PreviousOrderHeader = Bundle.main.loadNibNamed(PreviousOrderHeader.className, owner: self, options: nil)!.first! as! PreviousOrderHeader
            
            header.itemPast = self.viewModel.getOrderRootArray.first?.Data?[section]
            CommonClass.sharedInstance.provideCustomCornarRadius(btnRef: header, radius: 5)
            
            header.btnTap.tag = section
            header.btnTap.addTarget(self, action: #selector(self.tapSectionBtn(sender:)), for: UIControl.Event.touchUpInside)
                        
            header.btnReorderRef.setTitle("Reorder".localized(), for: .normal)
            header.btnRateOrder.isUserInteractionEnabled = true

            header.btnRateOrder.tag = section
            print("On section",self.viewModel.getOrderRootArray.first?.Data?[section].ratingData?.Id)
            
            header.btnRateOrder.addTarget(self, action: #selector(self.tapShareReviews(sender:)), for: UIControl.Event.touchUpInside)
            
            
         //   header.btnRate.tag = section
        //    header.btnRate.addTarget(self, action: #selector(self.tapShareReviews(sender:)), for: UIControl.Event.touchUpInside)
            
            header.btnReorderRef.tag = section
            header.btnReorderRef.addTarget(self, action: #selector(self.tapReOrder(sender:)), for: UIControl.Event.touchUpInside)
            
            return header
            
        }else {
            
            let header:MyOrderOnGoingHeaderView = Bundle.main.loadNibNamed(MyOrderOnGoingHeaderView.className, owner: self, options: nil)!.first! as! MyOrderOnGoingHeaderView
            
            header.item = self.viewModel.getOrderRootArray.first?.Data?[section]
            
            header.selectedTab = self.btnTag
            
            header.btnTap.tag = section
            header.btnTap.addTarget(self, action: #selector(self.tapSectionBtn(sender:)), for: UIControl.Event.touchUpInside)
            
            header.deleteHeaderDelegate = self
            header.btnCancelRef.isUserInteractionEnabled = true
            
            header.btnCancelRef.tag = section
            
            return header
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if btnTag == 1{
            
            if self.viewModel.getOrderRootArray.first?.Data?[section].isSelected == true{
                
                let footer:InnerTableViewFooter = Bundle.main.loadNibNamed(InnerTableViewFooter.className, owner: self, options: nil)!.last! as! InnerTableViewFooter
                
                footer.itemOnGoing = self.viewModel.getOrderRootArray.first?.Data?[section]
                footer.lblTotolTopConstraint.constant = 12
                footer.btnViewMore.tag = section
                footer.btnViewMore.addTarget(self, action: #selector(btnViewMore), for: .touchUpInside)
                if self.viewModel.getOrderRootArray.first?.Data?[section].orderData?.count ?? 0 > 2{
                    footer.btnViewMore.isHidden = false
                }else{
                    footer.btnViewMore.isHidden = true
                }
                                
                footer.btnReOrder.isHidden = true
                
                return footer
            }else{
                return nil
            }
            
            
            
        }else if btnTag == 2{
            
            if self.viewModel.getOrderRootArray.first?.Data?[section].isSelected == true{
                
                let footer:InnerTableViewFooter = Bundle.main.loadNibNamed(InnerTableViewFooter.className, owner: self, options: nil)!.last! as! InnerTableViewFooter
                
                
                footer.itemPast = self.viewModel.getOrderRootArray.first?.Data?[section]
                
                footer.lblTotolTopConstraint.constant = 27
                
                footer.btnViewMore.tag = section
                footer.btnViewMore.addTarget(self, action: #selector(btnViewMore), for: .touchUpInside)
                
                footer.btnReOrder.tag = section
                
                footer.btnReOrder.addTarget(self, action: #selector(self.tapReOrder(sender:)), for: UIControl.Event.touchUpInside)
                
                if self.viewModel.getOrderRootArray.first?.Data?[section].orderData?.count ?? 0 > 2{
                    footer.btnViewMore.isHidden = false
                }else{
                    footer.btnViewMore.isHidden = true
                }
                
                return footer
                
            }else{
                return nil
            }
            
            
        }else{
            
            if self.viewModel.getOrderRootArray.first?.Data?[section].isSelected == true{
                let footer:InnerTableViewFooter = Bundle.main.loadNibNamed(InnerTableViewFooter.className, owner: self, options: nil)!.last! as! InnerTableViewFooter
                
                footer.lblTotolTopConstraint.constant = 27
                footer.btnReOrder.isHidden = true
                footer.btnViewMore.tag = section
                
                if self.viewModel.getOrderRootArray.first?.Data?[section].orderData?.count ?? 0 > 2{
                    footer.btnViewMore.isHidden = false
                }else{
                    footer.btnViewMore.isHidden = true
                }
                
                footer.item = self.viewModel.getOrderRootArray.first?.Data?[section]
                footer.btnViewMore.addTarget(self, action: #selector(btnViewMore), for: .touchUpInside)
                
                return footer
            }else{
                return nil
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if btnTag == 1{
            
            if self.viewModel.getOrderRootArray.first?.Data?[section].isSelected == true{
                return 280
            }else{
                return 10
            }
            
        }else if btnTag == 2{
            if self.viewModel.getOrderRootArray.first?.Data?[section].isSelected == true{
                return 295
            }else{
                return 10
            }
            
        }else{
            if self.viewModel.getOrderRootArray.first?.Data?[section].isSelected == true{
                return 295
            }else{
                return 10
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        if btnTag == 1{
            if self.viewModel.getOrderRootArray.first?.Data?[section].isSelected == true{
                return 200
            }else{
                return 130
            }
        }
        else if btnTag == 2{
            
            if self.viewModel.getOrderRootArray.first?.Data?[section].isSelected == true{
                return UITableViewAutomaticDimension
            }else{
                return UITableViewAutomaticDimension
            }
        }
        else{
            return 130
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if btnTag == 1{
            if self.viewModel.getOrderRootArray.first?.Data?[section].isSelected == true{
                return 200
            }else{
                return 130
            }
        }
        else if btnTag == 2{
            if self.viewModel.getOrderRootArray.first?.Data?[section].isSelected == true{
                return 110
            }else{
                return 165
            }
        }
        else{
            return 130
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if btnTag == 2{
            
            return UITableViewAutomaticDimension
        }
        else{
            return UITableViewAutomaticDimension
        }
        
    }
    
    
}

