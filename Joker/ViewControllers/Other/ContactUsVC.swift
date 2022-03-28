//
//  ContactUsVC.swift
//  Joker
//
//  Created by Dacall soft on 22/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class ContactUsVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var lblnav: UILabel!
    
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblnav.text = "Contact Us".localized()
        
        configureTableView()
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }

}


extension ContactUsVC{
    
    func configureTableView(){
        
        let cellNib = UINib(nibName: "ContactUsTableViewCell", bundle: nil)
        tableview.register(cellNib, forCellReuseIdentifier: "Cell")
        tableview.rowHeight = 160
        tableview.tableFooterView = UIView()
    }
}


extension ContactUsVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContactUsTableViewCell
        
        if indexPath.row == 0{
            
            cell.contentImg.image = UIImage(named:"contactUsLocation")
            cell.contentLbl.text = "Cond. Vila Flor, Rua 04, nº 202 Rua principal do Camama Luanda-Angola"
        }
        else if indexPath.row == 1{
            
            cell.contentImg.image = UIImage(named:"contactUsCall")
            cell.contentLbl.text = "+244 923 283 618"
            
        }
        else{
            
            cell.contentImg.image = UIImage(named:"contactUsEmail")
            cell.contentLbl.text = "paginazul@paginazul.co.ao"
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1{
         
            self.makePhoneCall(phoneNumber: "+244923283618")
           
        }else if indexPath.row == 2{
            
            let email:String = "paginazul@paginazul.co.ao"
            
            //MARK: Email Case
            if let url = URL(string: "mailto:\(email)") {
                UIApplication.shared.open(url)
            }
        }
        
    }
    
    func makePhoneCall(phoneNumber: String) {
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
            
            let alert = UIAlertController(title: ("Call " + phoneNumber + "?"), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}


