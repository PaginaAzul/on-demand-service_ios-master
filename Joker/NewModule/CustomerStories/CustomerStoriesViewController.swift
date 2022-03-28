//
//  CustomerStoriesViewController.swift
//  OWIN
//
//  Created by apple on 30/03/20.
//  Copyright © 2020 Mobulous. All rights reserved.
//

import UIKit

class CustomerStoriesViewController:UIViewController {

    @IBOutlet weak var storiesTV: UITableView!
    @IBOutlet weak var lblHeader : UILabel!
    
    //MARK: - Variable's
    var customerStories = [Customer_Stories]()
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblHeader.text = "Customer Stories".localized()
        
        customerStories.append(Customer_Stories(id: 1, title: "Prashant Chaudhary", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", image: "user1"))
        
        customerStories.append(Customer_Stories(id: 1, title: "Sumit Singh", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", image: "user2"))
        
        customerStories.append(Customer_Stories(id: 1, title: "Prashant Chaudhary", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", image: "user1"))
        
        customerStories.append(Customer_Stories(id: 1, title: "Sumit Singh", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", image: "user2"))
        
        customerStories.append(Customer_Stories(id: 1, title: "Prashant Chaudhary", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", image: "user1"))
        
        customerStories.append(Customer_Stories(id: 1, title: "Sumit Singh", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", image: "user2"))
        
        customerStories.append(Customer_Stories(id: 1, title: "Prashant Chaudhary", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", image: "user1"))
        
        storiesTV.separatorColor = UIColor.white
        
        storiesTV.dataSource = self
        storiesTV.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getCustomerStoryAPI()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
      
    }
   
    @IBAction func tap_sideMenuBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
//        let vc = ScreenManager.getMoreVC()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension CustomerStoriesViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.customerStoriesArr.first?.Data?.count ?? 0
       // return customerStories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomerStoriesTableViewCell = storiesTV.dequeueReusableCell(withIdentifier: CustomerStoriesTableViewCell.className, for: indexPath) as! CustomerStoriesTableViewCell
        
      //  cell.configureData(info: customerStories[indexPath.row])

        cell.item = self.viewModel.customerStoriesArr.first?.Data?[indexPath.row]

        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

class Customer_Stories{
   
    var id = Int()
     var title = String()
     var description = String()
     var image = String()
  
    init(id: Int,title:String,description:String,image:String){
        self.id = id
         self.title = title
         self.description = description
         self.image = image
        
    }
}
