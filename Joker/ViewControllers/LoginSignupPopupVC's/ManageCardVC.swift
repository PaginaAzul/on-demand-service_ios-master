//
//  ManageCardVC.swift
//  Joker
//
//  Created by Apple on 23/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ManageCardVC: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var addNewCardBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var controllerName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerTableCell()
        
        self.headerView.backgroundColor = UIColor(red: 190.0/255, green: 113.0/255, blue: 252.0/255, alpha: 1.0)
        self.addNewCardBtn.backgroundColor = UIColor(red: 190.0/255, green: 113.0/255, blue: 252.0/255, alpha: 1.0)
        
        tableView.reloadData()
        
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_addNewCardBtn(_ sender: Any) {
        
        if controllerName == ""{
            
            self.navigationController?.popViewController(animated: true)
        }
        else{
            
            let vc = ScreenManager.getAddCardVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    

}

extension ManageCardVC {
    
    func registerTableCell(){
        
        let cellNib = UINib(nibName: "MasterCardCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "MasterCardCell")
        
        
    }
    
}


extension ManageCardVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MasterCardCell", for: indexPath) as! MasterCardCell
        cell.baseView.borderWidth = 2
        cell.baseView.borderColor = UIColor(red: 128.0/255, green: 0.0/255, blue: 186.0/255, alpha: 1.0)
        return cell
    }
    
}
