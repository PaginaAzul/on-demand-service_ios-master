//
//  HomeTableCell.swift
//  OWIN
//
//  Created by SinhaAirBook on 20/08/20.
//  Copyright © 2020 Mobulous. All rights reserved.
//

import UIKit

class HomeTableCell: UITableViewCell {
    
    @IBOutlet weak var lbl_ItemType: UILabel!
    @IBOutlet weak var btn_ViewMore: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imgArr1 = [String]()
    var imgArr2 = [String]()
    var tagIndexPath : Int?
    var superVC = UIViewController()
    
    var Scrollinftimer = Timer() // Set Timer
    var Image_Scroll = ["food","home_services"]
    
    var rowIndex = Int()
    var collectionModelArr = [homeScreenModel]()
    var lat = String()
    var long = String()
    
    //Offer DataSource
    var ExclusiveOfferArray = [ExclusiveOffer]()
    var ResturantDataArray = [RestaurantList]()
    var StoreDataArray = [StoreList]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setData()

        if collectionView.tag == 0 {
             btn_ViewMore.isHidden = true
             collectionView.reloadData()
        }else if collectionView.tag == 1 ||   collectionView.tag == 2 {
            
            btn_ViewMore.isUserInteractionEnabled = true
            btn_ViewMore.isHidden = false
            lbl_ItemType.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 17.0)!
            lbl_ItemType.textColor = AppColor.textColor
            btn_ViewMore.setTitle("View All".localized(), for: .normal)
            btn_ViewMore.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 15.0)!
            btn_ViewMore.setTitleColor(#colorLiteral(red: 0.03607749939, green: 0.572451055, blue: 0.8170866966, alpha: 1), for: .normal)
            btn_ViewMore.addTarget(self, action: #selector(btnViewAllTap), for: .touchUpInside)
            configCollection()
            
            
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    internal func setData() {
        
        let collectionLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionLayout.scrollDirection = .horizontal
        
        if collectionView.tag == 0{
            collectionLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 200)
            
        }else{
             collectionLayout.itemSize = CGSize(width: collectionView.frame.size.width , height: 250)
        }
        
        collectionView.collectionViewLayout = collectionLayout
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.minimumLineSpacing = 0
        
        //self.contentView.backgroundColor = AppColor.updatedAppColor
        // collectionTView.register(nib: HomeCollectionCell.className)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
       
        
    }
    //TODO: Register Nib method
    fileprivate func registerNib(){

        self.collectionView.register(UINib(nibName: "HomeCollectionCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionCell")

    }
    
    func configCollection(){
        registerNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
    }
    
    
    @IBAction func viewMoreTap(_ sender: UIButton) {
        print("ViewMore")
        if self.ResturantDataArray.count > 0 {
            let vc = ScreenManager.MyFavNew_VC()
            vc.resturantListArray = self.ResturantDataArray
            vc.isComing = "View All"
            self.superVC.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            let vc = ScreenManager.MyFavNew_VC()
            vc.storeListArray = self.StoreDataArray
            vc.isComing = "View All Grocery"
            self.superVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func btnViewAllTap(){
       
    }
    
}
//MARK: - Uicollection View DataSource & Delegates
//TODO:
extension HomeTableCell : UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
          //  return Image_Scroll.count
            return self.ExclusiveOfferArray.count
        }else if collectionView.tag == 1{
            //return self.collectionModelArr.count
            return self.ResturantDataArray.count
        }else{
           //return self.collectionModelArr.count
            return self.StoreDataArray.count
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 0 {
            
            self.collectionView.register(UINib(nibName: "offerCell", bundle: nil), forCellWithReuseIdentifier: "offerCell")
            
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "offerCell", for: indexPath) as! offerCell
            cell.item = self.ExclusiveOfferArray[indexPath.row]
            return cell
            
        }else if collectionView.tag == 1 {
            self.collectionView.register(UINib(nibName: "HomeCollectionCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionCell")
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as! HomeCollectionCell
           
            //pass Data
            cell.item = self.ResturantDataArray[indexPath.row]
            
            return cell
            
        }else{
            self.collectionView.register(UINib(nibName: "HomeCollectionCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionCell")
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as! HomeCollectionCell
           
            //pass Data
            cell.Storeitem = self.StoreDataArray[indexPath.row]
            
            
            return cell
        }
    }
    
    
    
  
    
    @objc func startTimer(timersset : Timer)
    {
        UIView.animate(withDuration: 5.0, delay: 10.0, options: .repeat, animations:
        {
            
                self.collectionView.scrollToItem(at: IndexPath(row: timersset.userInfo! as! Int,section:0), at: .centeredHorizontally, animated: false)
                print("Row on Scroll!!",timersset.userInfo! as! Int)
       
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            return  CGSize(width: collectionView.frame.size.width-20, height: 300)
        }else if collectionView.tag == 1{
             return  CGSize(width: collectionView.frame.size.width , height: 250)
        }else{
            return  CGSize(width: collectionView.frame.size.width , height: 250)
        }
           
       }
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Offer")
        
        if collectionView.tag == 0 {
            UserDefaults.standard.set("Food", forKey: "Food")
            
            if self.ExclusiveOfferArray[indexPath.row].sellerData?.storeType == "Grocery Store"{
                let vc = ScreenManager.GroceryDetailVC()
               // vc.comgFromOffer = true
                vc.id = self.ExclusiveOfferArray[indexPath.row].resAndStoreId ?? ""
                self.superVC.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = ScreenManager.RestaurentDetailsVC()
                vc.comgFromOffer = true
                vc.id = self.ExclusiveOfferArray[indexPath.row].resAndStoreId ?? ""
                self.superVC.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        else if collectionView.tag == 1   {
            
            UserDefaults.standard.set("Food", forKey: "Food")
            let vc = ScreenManager.RestaurentDetailsVC()
            vc.id = self.ResturantDataArray[indexPath.row].Id ?? ""
            vc.isFav = isFavt
            self.superVC.navigationController?.pushViewController(vc, animated: true)
          
        }else if collectionView.tag == 2{
            
            UserDefaults.standard.set("Restaurent", forKey: "Food")
            let vc = ScreenManager.GroceryDetailVC()
            print("ID on selecting",self.StoreDataArray[indexPath.row].Id ?? "" )
            
            vc.id = self.StoreDataArray[indexPath.row].Id ?? ""
            vc.isFavt = isFavt
            self.superVC.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            
        }

        
    }
    
}

var isFavt = Bool()

