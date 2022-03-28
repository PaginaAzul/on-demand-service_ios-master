//
//  BankToBankVC.swift
//  Joker
//
//  Created by abc on 23/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class BankToBankVC: UIViewController {

    //MARK: - Outlet
    @IBOutlet weak var tblView_BankToBank: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        intialSetUp()
       
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: - User Defined Methods Extension
extension BankToBankVC{
    func intialSetUp(){
        tblView_BankToBank.tableFooterView = UIView()
    }
}
//MARK: - Extension TableView Controller
extension BankToBankVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tblView_BankToBank.register(UINib(nibName: "BankToBankTableViewCellAndXib", bundle: nil), forCellReuseIdentifier: "BankToBankTableViewCellAndXib")
        let cell = tblView_BankToBank.dequeueReusableCell(withIdentifier: "BankToBankTableViewCellAndXib", for: indexPath) as! BankToBankTableViewCellAndXib
       
        return cell
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
