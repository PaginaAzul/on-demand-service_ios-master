//
//  ManageSavedCardsVC.swift
//  Joker
//
//  Created by Apple on 24/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ManageSavedCardsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var addNewCardBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var payNowBtn: UIButton!
    
    var arrOfimages :[UIImage] = [#imageLiteral(resourceName: "flag"),#imageLiteral(resourceName: "Cirrus"),#imageLiteral(resourceName: "Cirrus")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialise()
        
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap_payNowBtn(_ sender: Any) {
        
        let vc = ScreenManager.getPopupVC()
        
        vc.controllerName = "Pay Now"
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func tap_addNewCardBtn(_ sender: Any) {
        
        let vc = ScreenManager.getAddCardVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension ManageSavedCardsVC {
    
    func registerTableCell(){
        
        let cellNib = UINib(nibName: "MasterCardCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "MasterCardCell")
        
    }
    
    func initialise(){
        
        
        registerTableCell()
        
        self.cardView.borderWidth = 2
        self.cardView.borderColor = UIColor(red: 190.0/255, green: 113.0/255, blue: 252.0/255, alpha: 1.0)
        
        
        
        self.headerView.backgroundColor = UIColor(red: 190.0/255, green: 113.0/255, blue: 252.0/255, alpha: 1.0)
        self.addNewCardBtn.backgroundColor = UIColor(red: 190.0/255, green: 113.0/255, blue: 252.0/255, alpha: 1.0)
        self.payNowBtn.backgroundColor = UIColor(red: 190.0/255, green: 113.0/255, blue: 252.0/255, alpha: 1.0)
        
        let normalText1  = "Total Amount to be added : "
        let normalText2 = "15.0SAR"
        let myMutableString1 = NSMutableAttributedString()
        let myMutableString2 = NSAttributedString(string: "\(normalText1) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 15.0)!, .foregroundColor :UIColor.black])
        
        
        let myMutableString4 = NSAttributedString(string: "\(normalText2) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 15.0)!, .foregroundColor :UIColor(red: 190.0/255, green: 113.0/255, blue: 252.0/255, alpha: 1.0)] )
        
        
        
        myMutableString1.append(myMutableString2)
        myMutableString1.append(myMutableString4)
        self.totalAmountLbl.attributedText = myMutableString1
        
        
        tableView.reloadData()
    }
    
}


extension ManageSavedCardsVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MasterCardCell", for: indexPath) as! MasterCardCell
        cell.baseView.borderWidth = 2
        cell.checkBoximg.image = nil
        cell.cardImg.image = arrOfimages[indexPath.row]
        cell.moreBtn.setImage(UIImage(named: "un_cir"), for: .normal)
        cell.baseView.borderColor = UIColor(red: 128.0/255, green: 0.0/255, blue: 186.0/255, alpha: 1.0)
        return cell
    }
    
}
