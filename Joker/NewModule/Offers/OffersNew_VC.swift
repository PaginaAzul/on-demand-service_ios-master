//
//  OffersNew_VC.swift
//  Joker
//
//  Created by cst on 21/10/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout
import UICollectionViewGallery


// https://stackoverflow.com/questions/35456988/how-to-make-uicollectionview-auto-scroll-using-nstimer


class OffersNew_VC: UIViewController {
    
    //MARK: - IBOUTLET'S
    //TODO: StoryBoard Connection
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLeft: UICollectionView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblHeader : UILabel!
    
    var timr = Timer() , w:CGFloat=0.0
    var timerLeft = Timer() ,  wLeft:CGFloat = 0.0 , search:String=""

    var infiniteSizeLeft = Int()
    var infiniteSizeRight = Int()
    
    let model = Model() , appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var leftDataModelArr = [OfferCategoryData]() , rightDataModelArr = [OfferCategoryData]()
    internal let viewModel = ViewModel()
    var filterModelArr = [OfferCategoryData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getOfferCategoryApiCall()

        txtSearch.delegate = self
        //model.buildDataSource()
        txtSearch.placeholder = "Search Offers".localized()
        lblHeader.text = "Offers".localized()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        leftDataModelArr.removeAll()
//        filterModelArr.removeAll()
//        getOfferCategoryApiCall()
//        configAutoscrollTimer()
    }
    
    
    override func loadViewIfNeeded() {
        
//        infiniteSizeLeft =  100000
//        infiniteSizeRight = 100000
//
//        let midIndexPathLeft = IndexPath(row: infiniteSizeLeft, section: 0)
//        let midIndexPathRight = IndexPath(row: infiniteSizeRight, section: 0)
//
//        collectionView.scrollToItem(at: midIndexPathRight,
//                                         at: .centeredVertically,
//                                         animated: false)
//
//        collectionViewLeft.scrollToItem(at: midIndexPathLeft,
//                                        at: .centeredVertically,
//                                        animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //

        if leftDataModelArr.count <= 5 {
            deconfigAutoscrollTimer()
        }else{
            
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        deconfigAutoscrollTimer()
    }
    
    func configureGallery(){
        
        let yourWidth = self.collectionView.bounds.width
        let yourHeight = yourWidth
        
        collectionView.setGallery(withStyle: .autoFixed, minLineSpacing: 0, itemSize: CGSize(width: yourWidth + 5, height: yourHeight),minScaleFactor:1.0)
        
        let yourWidthLeft = self.collectionViewLeft.bounds.width
        let yourHeightLeft = yourWidth
        
        collectionViewLeft.setGallery(withStyle: .autoFixed, minLineSpacing: 0, itemSize: CGSize(width: yourWidthLeft + 5, height: yourHeightLeft),minScaleFactor:1.0)
        
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        collectionView.changeOrientation()

    }
    
    
    
}

//MARK: - IBActions
//TODO:
extension OffersNew_VC {
    
    //TODO: Back Button Action
    @IBAction func tap_BackBTN(_ sender: Any) {
        
        if UserDefaults.standard.value(forKey: "Shop") != nil {
            
            let value =  UserDefaults.standard.value(forKey: "Shop") as? Bool ?? false
            if value == true {
                
                UserDefaults.standard.removeObject(forKey: "Shop")
                let vc = ScreenManager.MainModuleNew_VC()
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                appDelegate.window?.rootViewController = navController
                appDelegate.window?.makeKeyAndVisible()
                
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}

