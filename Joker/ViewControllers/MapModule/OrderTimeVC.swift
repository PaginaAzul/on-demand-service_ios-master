//
//  OrderTimeVC.swift
//  Joker
//
//  Created by Callsoft on 22/01/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

protocol SelectedTimeDelegate{
    
    func selectionTimeOfOrder(time:String)
}

import UIKit

class OrderTimeVC: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var lblIWantMyOrder: UILabel!
    
    @IBOutlet weak var btnOk: UIButton!
    
    @IBOutlet weak var lblToday: UILabel!
    
    var selectedIndex = 9
    
    var controllerPurpuse = ""
    
    var didSelect = false
    var selectedTimeStr = ""
    
    var delegate:SelectedTimeDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if controllerPurpuse == "Delivery"{
            
            lblIWantMyOrder.text = "I Want My Order".localized()
        }
        else{
            
            lblIWantMyOrder.text = "I Want My Service".localized()
        }
        
        btnOk.setTitle("OK".localized(), for: .normal)
        
        lblToday.text = "Today".localized()
        
        configureTableView()
    }
    
    
    @IBAction func tap_closeBtn(_ sender: Any) {
        
        if didSelect == true{
            
            self.delegate?.selectionTimeOfOrder(time: selectedTimeStr)
            self.dismiss(animated: true, completion: nil)
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please select the time".localized(), controller: self)
        }
       
    }
    
}


extension OrderTimeVC{
    
    func configureTableView(){
        
        let cellNib = UINib(nibName: "OrderTimeTableViewCell", bundle: nil)
        tableview.register(cellNib, forCellReuseIdentifier: "Cell")
        tableview.rowHeight = 35
        tableview.tableFooterView = UIView()
    }
}


extension OrderTimeVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OrderTimeTableViewCell
        
        switch indexPath.row {
        case 0:
            
            cell.lblTime.text = "In 1 hr".localized()
            
        case 1:
            
            cell.lblTime.text = "In 2 hr".localized()
            
        case 2:
            
            cell.lblTime.text = "In 3 hr".localized()
            
        case 3:
            
            cell.lblTime.text = "In 4 hr".localized()
            
        case 4:
            
            cell.lblTime.text = "In 5+ hr".localized()
            
        case 5:
            
            cell.lblTime.text = "In 1 day".localized()
            
        case 6:
            
            cell.lblTime.text = "In 2 days".localized()
            
        case 7:
            
            cell.lblTime.text = "In 3 days".localized()
            
        default:
            
            print("Nothing")
        }
        
        if selectedIndex == indexPath.row{
            
            cell.viewSelectedLine.backgroundColor = UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00)
            cell.lblTime.textColor = UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00)
        }
        else{
            
            cell.viewSelectedLine.backgroundColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0)
            cell.lblTime.textColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0)
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        didSelect = true
        
        
        switch indexPath.row {
        case 0:
            
            selectedTimeStr = "In 1 hr"//.localized()
            
        case 1:
            
            selectedTimeStr = "In 2 hr"//.localized()
            
        case 2:
            
            selectedTimeStr = "In 3 hr"//.localized()
            
        case 3:
            
            selectedTimeStr = "In 4 hr"//.localized()
            
        case 4:
            
            selectedTimeStr = "In 5+ hr"//.localized()
            
        case 5:
            
            selectedTimeStr = "In 1 day"//.localized()
            
        case 6:
            
            selectedTimeStr = "In 2 days"//.localized()
            
        case 7:
            
            selectedTimeStr = "In 3 days"//.localized()
            
        default:
            
            print("Nothing")
        }
        
        selectedIndex = indexPath.row
        
        tableview.reloadData()
    }
}
