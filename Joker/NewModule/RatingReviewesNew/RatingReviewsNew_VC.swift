//
//  RatingReviewsNew_VC.swift
//  Joker
//
//  Created by cst on 20/10/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit

class RatingReviewsNew_VC: UIViewController {

    //MARK: - OUTLETS
    //TODO:
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblHeader: UILabel!

    var ratingModelArr = [RatingModel]()
    var avgRating:Float?
    var totalRating:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblHeader.text = "Ratings & Reviews".localized()
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "RatingReviewsCell", bundle: nil), forCellReuseIdentifier: "RatingReviewsCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
 
        
    }
    

    @IBAction func btnBack(_ Sender:UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }

}
//MARK: - Extension UITableView DataSource and Delegates
//TODO:
extension RatingReviewsNew_VC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return ratingModelArr.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell =  tableView.dequeueReusableCell(withIdentifier: RatingReviewsCell.className, for: indexPath) as! RatingReviewsCell
        
        cell.item = ratingModelArr[indexPath.row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
         return UITableViewAutomaticDimension
        
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header:RatingNewHeader = Bundle.main.loadNibNamed("RatingNewHeader", owner: self, options: nil)!.first! as! RatingNewHeader
        
        header.viewRatingHdr.settings.fillMode = .half
        header.viewRatingHdr.rating = Double(avgRating ?? 0.0)
        let avgRat = round(avgRating ?? 0.0)
        header.lblRating.text = "\(avgRat) \("Ratings".localized())"
        header.lblTotalRating.text = "\("Restaurant's Latest Reviews".localized() + "(")\(totalRating ?? 0)+)"
        
        return header
    }
   
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
       return 185
   }
}



