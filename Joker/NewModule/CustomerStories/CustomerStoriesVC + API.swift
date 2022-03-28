//
//  CustomerStoriesVC + API.swift
//  Joker
//
//  Created by User on 22/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import Foundation
import UIKit


extension CustomerStoriesViewController {
    
   
    func getCustomerStoryAPI(){
        
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        let param = ["userId" : "5fa393080580e2030a01af9a"]
        
        self.viewModel.getCustomerStoryAPI(Domain.baseUrl().appending(APIEndpoint.getCustomerStory), param, nil)
        
        closureSetup()
        
    }
    
    func closureSetup(){
        
        
        self.viewModel.reloadList = { () in
            self.storiesTV.separatorColor = UIColor.white
            self.storiesTV.dataSource = self
            self.storiesTV.delegate = self
            self.storiesTV.reloadData()
        }
        
        
        
    }
    
}
