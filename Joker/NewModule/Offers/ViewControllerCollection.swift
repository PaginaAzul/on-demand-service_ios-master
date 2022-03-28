//
//  ViewController.swift
//  UICollectionViewGallery
//
//  Created by ro6lyo on 11/19/2016.
//  Copyright (c) 2016 ro6lyo. All rights reserved.
//

import UIKit
import UICollectionViewGallery

////New code

class ViewControllerCollection: UIViewController {
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var txtSearch: UITextField!

    
    var stringArray: [String] = ["1", "2", "3", "4", "5","6","7"]
    var timr = Timer() , w:CGFloat=0.0 , search:String=""

    var filterArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterArr = stringArray
        txtSearch.delegate = self

        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        configureGallery()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        deconfigAutoscrollTimer()
        configAutoscrollTimer()
        
    }
    
    func configureGallery(){
        
        let yourWidth = self.galleryCollectionView.bounds.width
        let yourHeight = yourWidth
        
        galleryCollectionView.setGallery(withStyle: .autoFixed, minLineSpacing: 0, itemSize: CGSize(width: yourWidth + 5, height: yourHeight),minScaleFactor:0.8)
        
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        galleryCollectionView.changeOrientation()
    }
    
}

extension ViewControllerCollection:UITextFieldDelegate{
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        deconfigAutoscrollTimer()
        
        if string.isEmpty
        {
            search = String(search.characters.dropLast())
        }
        else
        {
            search=textField.text!+string
        }
        
        print(search)
        
        if search != "" {
            self.filterArr = (stringArray.filter {data in
                return (data.lowercased().contains(search.lowercased()) ?? false)
                
            } )
        }else{
            self.filterArr = stringArray
        }
        
        print("self.filterArr")
        
        for i in self.filterArr{
            print(i)
        }
        configureGallery()

        galleryCollectionView.reloadData()
        
        self.configAutoscrollTimer()
        
        return true
    }
    
}

//MARK: - AutoScroll Delegates
//TODO:
extension ViewControllerCollection{
    
    func configAutoscrollTimer()
    {
        
        timr = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(autoScrollView), userInfo: nil, repeats: true)
        
       
    }
    
    
    func deconfigAutoscrollTimer()
    {
        w = 0.0
        timr.invalidate()
        
    }
    
   
    
    @objc func autoScrollView()
    {
        
        let initailPoint = CGPoint(x: 0,y :w)
        
        if __CGPointEqualToPoint(initailPoint, self.galleryCollectionView.contentOffset)
        {
            if w<galleryCollectionView.contentSize.height
            {
                w += 0.5
            }
            else
            {
                w = 0.0
                
            }
            
            let offsetPoint = CGPoint(x: 0,y :w)
            
            galleryCollectionView.contentOffset=offsetPoint
        }
        else
        {
            w = galleryCollectionView.contentOffset.y
        }
    }
}

//
// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
//
extension ViewControllerCollection: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return filterArr.count // <-  this is your count of elements
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: customCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath as IndexPath) as? customCell)!
        cell.customLabel.text = filterArr[indexPath.row]
        return cell   //<- this is current item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //<-- this is selected items
        
        print("IndexPath-->" ,indexPath.row )

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension

    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        galleryCollectionView.recenterIfNeeded()
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            //MARK:- Priyanka Code
            //TODO:- Start
            let noOfCellsInRow = 1
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            return CGSize(width: size   , height: size - 5)
         
    }
    
}

class customCell :UICollectionViewCell {
    
    @IBOutlet weak var customLabel: UILabel!
    @IBOutlet weak var imageBg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        provideShadowFourSide()
        
    }
    
    func provideShadowFourSide(){

        self.imageBg.layer.masksToBounds = false
        self.imageBg.layer.shadowColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        self.imageBg.layer.shadowOffset =  CGSize.zero
        self.imageBg.layer.shadowOpacity = 0.5
        self.imageBg.layer.shadowRadius = 4
        
        self.contentView.layer.masksToBounds = false
        self.contentView.layer.shadowColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        self.contentView.layer.shadowOffset =  CGSize.zero
        self.contentView.layer.shadowOpacity = 0.5
        self.contentView.layer.shadowRadius = 4
        
        contentView.layer.cornerRadius = contentView.frame.size.height / 2

        contentView.layer.cornerRadius = 5

    }

    /*
    func provideCornarRadius(btnRef:UIView){
        contentView.layer.cornerRadius = contentView.frame.size.height / 2
        
    }
    
   func provideCustomCornarRadius(btnRef:UIView,radius:CGFloat){
    contentView.layer.cornerRadius = radius
   }
 
 */
    
}





