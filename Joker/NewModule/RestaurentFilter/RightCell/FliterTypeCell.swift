//
//  FliterTypeCell.swift
//  OWIN
//
//  Created by SinhaAirBook on 06/08/20.
//  Copyright © 2020 Mobulous. All rights reserved.
//

import UIKit
import Cosmos

class FliterTypeCell: UITableViewCell {

    //MARK:- Outlet
  
    @IBOutlet weak var view_Rating: CosmosView!
    @IBOutlet weak var btnDone: UIButton!
    
    var delegate: ReturnNumberOfRatingDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnDone.addTarget(self, action: #selector(btnDoneTap), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func btnDoneTap(){
        self.btnDone.setTitleColor(#colorLiteral(red: 0.03607749939, green: 0.572451055, blue: 0.8170866966, alpha: 1), for: .normal)
        self.delegate?.noOfRating(self.view_Rating.rating)
    }
    
}

protocol ReturnNumberOfRatingDelegate {
    func noOfRating(_ rating:Double)
}
