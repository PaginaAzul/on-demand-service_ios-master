//
//  RatingReviewsCell.swift
//  Joker
//
//  Created by cst on 20/10/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit
import Cosmos


class RatingReviewsCell: UITableViewCell {
    
    //MARK: - OUTLET'S
    //TODO:
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime:UILabel!
    @IBOutlet weak var lblReviewContent:UILabel!
    @IBOutlet weak var imgView:UIImageView!
    
    let viewModel = ViewModel()
    
    //MARK: - VARIABLE'S
    //TODO:
    var item:RatingModel? {
        
        didSet {
            imgView.setImage(withImageId: item?.userData?.profilePic ?? "", placeholderImage: #imageLiteral(resourceName: "catImageNew"))
            lblName.text = item?.userData?.name
            
            var newTimeZone = String()
            
            newTimeZone = newTimeZone.timeDateConversion(formateDate:String((item?.createdAt?.prefix(19))!))
            
            let start = String.Index(utf16Offset: 11, in: newTimeZone)
            let end = String.Index(utf16Offset: 18, in: newTimeZone)
            let substring = String(newTimeZone[start...end])
            
            let timeAgo = viewModel.DateDiff(dateR: "\(newTimeZone.prefix(10))" , time: "\(substring)")
            
            lblTime.text = timeAgo
            lblReviewContent.text = item?.review
            viewRating.rating = Double(item?.rating ?? 0)
        }
        
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //Configure the view for the selected state
        
    }
    
    
}
