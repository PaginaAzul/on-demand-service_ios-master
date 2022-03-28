//
//  CustomerStoriesTableViewCell.swift
//  OWIN
//
//  Created by apple on 30/03/20.
//  Copyright © 2020 Mobulous. All rights reserved.
//

import UIKit

class CustomerStoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var customerImg: UIImageView!
    
    @IBOutlet weak var customerName: UILabel!
    
    @IBOutlet weak var customerDescription: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    var item:DataStory?{
        didSet{
            customerImg.setImage(withImageId: item?.image ?? "", placeholderImage: #imageLiteral(resourceName: "food_icon"))
            customerName.text = item?.username ?? ""
            customerDescription.text = item?.story ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CommonClass.sharedInstance.provideCornarRadius(btnRef: customerImg)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configureData(info:Customer_Stories){
        
        customerImg.image = UIImage(named: "\(info.image)")
        
        customerName.text = info.title
        customerDescription.text = info.description
        
             //        cell.customerImg.sd_setImage(with: URL(string: customerStories[indexPath.row].image), placeholderImage: UIImage(named: "user_signup"))
    }
}
