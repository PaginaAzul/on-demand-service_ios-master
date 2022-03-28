//
//  MainCollCell.swift
//  Joker
//
//  Created by User on 10/12/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit

class MainCollCell: UICollectionViewCell {

    
    @IBOutlet weak var smallCollectionView: UICollectionView!
    

    var topArrayData = [TopArrayModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        smallCollectionView.isHidden = false
        smallCollectionView.delegate = self
        smallCollectionView.dataSource = self
        let collectionLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.itemSize = CGSize(width: UIScreen.main.bounds.width/5, height: 140)
        smallCollectionView.collectionViewLayout = collectionLayout
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.minimumLineSpacing = 5
        smallCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        smallCollectionView.register(UINib(nibName: "dummyCell", bundle: nil), forCellWithReuseIdentifier: "dummyCell")
        self.topArrayData.append(TopArrayModel(img: #imageLiteral(resourceName: "offers"), name: "Offers".localized()))
        self.topArrayData.append(TopArrayModel(img: #imageLiteral(resourceName: "meals"), name: "Meals".localized()))
        self.topArrayData.append(TopArrayModel(img: #imageLiteral(resourceName: "shopping"), name: "Shopping".localized()))
        self.topArrayData.append(TopArrayModel(img:#imageLiteral(resourceName: "services"), name: "Services".localized()))
        
    }

}


extension MainCollCell : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.topArrayData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       let cell = smallCollectionView.dequeueReusableCell(withReuseIdentifier: "dummyCell", for: indexPath) as! dummyCell
      
        cell.item = self.topArrayData[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = ScreenManager.OffersNew_VC()
            commonController.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 3{
            UserDefaults.standard.set(false, forKey: "NewModul")
            let vc = ScreenManager.getServiceProviderMapVC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDel.window?.rootViewController = navController
            appDel.window?.makeKeyAndVisible()
        }else{
            
            let vc = ScreenManager.HomeScreenNew_VC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDel.window?.rootViewController = navController
            appDel.window?.makeKeyAndVisible()
            
        }
    }
   
}

let appDel = UIApplication.shared.delegate as! AppDelegate
