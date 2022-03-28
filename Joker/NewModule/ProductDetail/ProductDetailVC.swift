//
//  ProductDetailVC.swift
//  Joker
//
//  Created by cst on 24/10/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit
import Cosmos

class ProductDetailVC: UIViewController {

    //MARK: - IBOUTLET's
    //TODO:
    @IBOutlet weak var viewCosmos: CosmosView!
    @IBOutlet weak var viewLike: UIView!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var btnFavRef: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDescriptionHeader: UILabel!

    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblReviews: UILabel!
    @IBOutlet weak var btnAddToCart: UIButton!

    @IBOutlet weak var favButton: UIView!
    
    //MARK: - VARIABLE's
    //TODO:
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var icComingFromOffer = Bool() , comgFromOffer = Bool()
    
    internal var viewModel = ViewModel()
    var productId:String?
    var type = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.productDetail()

        btnAddToCart.setTitle("Add To Cart".localized(), for: .normal)
        lblDescriptionHeader.text = "Description".localized()
        lblReviews.text = "\(0) (\(0) \("Reviews".localized()))"
        lblQuantity.text = "\("Quantity".localized()) : \(0)"

          
        favButton.isHidden = true
        btnFavRef.isHidden = true
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
      
    @IBAction func tapCart(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "IsUserLogin"){
            
            let vc = ScreenManager.MyCartNew_VC()
            vc.icComingFromOffer = self.icComingFromOffer
            vc.comgFromOffer = self.comgFromOffer
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            
            self.alertWithAction()
        }
    }
    
    
    func makeRootToLoginSignup(){
        
        let vc = ScreenManager.getSignInSignupVC()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    func alertWithAction(){
        
        let alertController = UIAlertController(title: "", message: "You are not logged in. Please login/signup before proceeding further.".localized(), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            self.makeRootToLoginSignup()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

    

}
