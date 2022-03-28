//
//  ManageAddressesVC.swift
//  Joker
//
//  Created by Callsoft on 23/01/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class ManageAddressesVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet var tableFooterView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    @IBAction func tap_myWalletHistory(_ sender: Any) {
    }
    
    @IBAction func tap_addBank(_ sender: Any) {
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
    }
    
}


extension ManageAddressesVC{
    
    func configureTableView(){
        
        let cellNib = UINib(nibName: "ManageAddressTableViewCell", bundle: nil)
        tableview.register(cellNib, forCellReuseIdentifier: "Cell")
        tableview.tableFooterView = tableFooterView
        tableview.rowHeight = 56
    }
}


extension ManageAddressesVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ManageAddressTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
}
