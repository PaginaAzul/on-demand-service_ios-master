//
//  ResturantInfoViewC.swift
//  OWIN
//
//  Created by SinhaAirBook on 22/08/20.
//  Copyright © 2020 Mobulous. All rights reserved.
//
import UIKit
import Cosmos
import DropDown

class ResturantInfoViewC: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var lblDescriptionHeader: UILabel!{
        didSet{
            lblDescriptionHeader.text = "Description".localized()
        }
    }
    @IBOutlet weak var lblReviewHeader: UILabel!{
        didSet{
            lblReviewHeader.text = "Reviews".localized()
        }
    }

    
    @IBOutlet weak var tblRating: UITableView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblWorkingHour: UILabel!
    @IBOutlet weak var lblWorking: UILabel!

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var btn_DropDown: UIButton!
    @IBOutlet weak var btnViewAll: UIButton!
    
    //
    var id: String?
    var dropDown = DropDown()
    var viewC = UIViewController()
    var resInfoData = [OfferListModel]()
    var ResAndStoreDetailArray = [ResAndStoreDetailBaseModel]()
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.initilizeUI()
        
        tblRating.tableFooterView = UIView()
        tblRating.register(UINib(nibName: "RatingReviewsCell", bundle: nil), forCellReuseIdentifier: "RatingReviewsCell")
        tblRating.delegate = self
        tblRating.dataSource = self
        tblRating.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
    }
    
    internal func initilizeUI(){
        lblWorking.text = "Working Hours".localized()
        btn_DropDown.isHidden = true
        lblHeader.text = (ResAndStoreDetailArray.first?.Data?.resAndStoreDetail?.storeType == "Grocery Store") ? "Store Info".localized() : "Restaurants Info".localized()
        lblDescription.text = ResAndStoreDetailArray.first?.Data?.resAndStoreDetail?.description ?? ""
        
        self.dropDown(self.lblWorkingHour)
        self.dropDown.dataSource.removeAll()
        
        self.lblWorkingHour.text = "\(ResAndStoreDetailArray.first?.Data?.resAndStoreDetail?.openingTime ?? "")-\(ResAndStoreDetailArray.first?.Data?.resAndStoreDetail?.closingTime ?? "") \("(Today)".localized())"
//        for item in (data?.restorentTime)!{
//            self.dropDown.dataSource.append(item)
//        }
        
        self.btn_DropDown.addTarget(self, action: #selector(dropDownTap), for: .touchUpInside)
        self.btnViewAll.addTarget(self, action: #selector(btnViewAllTapped), for: .touchUpInside)
        let str = NSMutableAttributedString(string: "View All".localized(), attributes: [NSAttributedString.Key.font : UIFont(name: App.Fonts.SegoeUI.Regular, size: 15)!,NSMutableAttributedString.Key.foregroundColor: #colorLiteral(red: 0.03607749939, green: 0.572451055, blue: 0.8170866966, alpha: 1) , NSMutableAttributedString.Key.underlineColor : #colorLiteral(red: 0.03607749939, green: 0.572451055, blue: 0.8170866966, alpha: 1) , NSMutableAttributedString.Key.underlineStyle : NSUnderlineStyle.styleSingle.rawValue])
        btnViewAll.setAttributedTitle(str, for: .normal)
        
       
//        lblName.text = ""
//        viewRating.rating = Double(0 )
//        lblReview.text = ""
//        lblTime.text = ""
        
    }
    
    @objc func dropDownTap(){
        self.dropDown.show()
    }
    
    @objc func btnViewAllTapped(){
        self.dismiss(animated: true) {
            
            
            let vc = ScreenManager.ratingReviewsNew_VC()
            
            if self.ResAndStoreDetailArray.first?.Data?.rating?.count != 0 {
                vc.ratingModelArr = (
                    self.ResAndStoreDetailArray.first?.Data?.rating)!

            }
            
    
            
            vc.avgRating = self.ResAndStoreDetailArray.first?.Data?.resAndStoreDetail?.avgRating ?? 0
            vc.totalRating = self.ResAndStoreDetailArray.first?.Data?.resAndStoreDetail?.totalRating ?? 0
             
            //ratingModelArr
            self.viewC.navigationController?.pushViewController(vc, animated: true)
            
          // let vc = ScreenManager.GroceryScheduleDeliveryPoPUpVC()
         //  self.viewC.present(vc, animated: true, completion: nil)
            
            
        }
    }
    //MARK:- DropDownSteup For State
    
    func dropDown(_ lbl: UILabel) {
        
        dropDown.anchorView = self.btn_DropDown
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        dropDown.selectionAction = { [] (index: Int, item: String) in
            lbl.text = item
        }
    }
    
    // MARK: Drag dismiss function
         @objc func handleDismiss(sender: UIPanGestureRecognizer) {
             switch sender.state {
             case .changed:
                 
                 viewTranslation = sender.translation(in: view)
                 if viewTranslation.y > 0 {
                 UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                     self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                 })
                 }
             case .ended:
                 if viewTranslation.y < 100 {
                     UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                         self.view.transform = .identity
                     })
                 } else {
                     dismiss(animated: true, completion: nil)
                 }
             default:
                 break
             }
         }

    
    
    @IBAction func tapClose(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


//MARK: - Extension UITableView DataSource and Delegates
//TODO:
extension ResturantInfoViewC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return self.ResAndStoreDetailArray.first?.Data?.rating?.count ?? 0
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell =  tableView.dequeueReusableCell(withIdentifier: RatingReviewsCell.className, for: indexPath) as! RatingReviewsCell
        
        cell.item = self.ResAndStoreDetailArray.first?.Data?.rating?[indexPath.row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
         return UITableViewAutomaticDimension
        
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }

}


