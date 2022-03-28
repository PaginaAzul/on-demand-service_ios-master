//
//  WalkInVC.swift
//  Joker
//
//  Created by Apple on 22/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class WalkInVC: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtnOutlet: UIButton!
    @IBOutlet weak var previousBtnOutlet: UIButton!
    
    
    var currentPage = 0.0
    
    var dataArr = NSMutableArray()
    let connection = webservices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intialise()
        self.apiCallForGetStaticContent()
    }

    @IBAction func tap_previousBtn(_ sender: UIButton) {
        
        let cellWidth = collectionView.visibleCells[0].bounds.size.width
        let contentOffset = Float(floor(collectionView.contentOffset.x - cellWidth))
        moveCollectionView(toFrame: CGFloat(contentOffset))
        
        
        let pageWidth:CGFloat = collectionView.frame.width
        let indexOfcurrentPage:CGFloat = floor((collectionView.contentOffset.x-pageWidth/2)/pageWidth)+1
        let currentPage = indexOfcurrentPage - 1.0
        print(currentPage)
        
        if currentPage == 0.0{
            
            self.previousBtnOutlet.isHidden = true
        }
        else{
            
            self.previousBtnOutlet.isHidden = false
        }
//        else if currentPage == 1.0{
//
//            self.previousBtnOutlet.isHidden = false
//        }
//        else if currentPage == 2.0{
//
//            self.previousBtnOutlet.isHidden = false
//        }
        
        self.pageControl.currentPage = Int(currentPage)
        pageControl.customPageControl(dotFillColor: UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00), dotBorderColor: UIColor(red: 158.0/255, green: 158.0/255, blue: 160.0/255, alpha: 1.0), dotBorderWidth: 1)
        
    }
    
    @IBAction func tap_nextBtn(_ sender: UIButton) {
        
        if dataArr.count != 0{
            
            let cellWidth = collectionView.visibleCells[0].bounds.size.width
            let contentOffset = Float(floor(collectionView.contentOffset.x + cellWidth))
            moveCollectionView(toFrame: CGFloat(contentOffset))
            
            let pageWidth:CGFloat = collectionView.frame.width
            let indexOfcurrentPage:CGFloat = floor((collectionView.contentOffset.x-pageWidth/2)/pageWidth)+1
            let currentPage = indexOfcurrentPage + 1.0
            
            print(currentPage)
            
            if currentPage == 0.0{
                
                self.previousBtnOutlet.isHidden = true
            }
//            else if currentPage == 1.0{
//
//                self.previousBtnOutlet.isHidden = false
//            }
//            else if currentPage == 2.0{
//
//                self.previousBtnOutlet.isHidden = false
//
//            }
            
//            else if currentPage == 3.0{
//
//                let vc = ScreenManager.getTermsAndConditionViewController()
//                self.navigationController?.pushViewController(vc, animated: true)
//
//            }
            else if Int(currentPage) == dataArr.count{
                
                let vc = ScreenManager.getTermsAndConditionViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else{
                
                self.previousBtnOutlet.isHidden = false
            }
            
            self.pageControl.currentPage = Int(currentPage)
            
            pageControl.customPageControl(dotFillColor: UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00), dotBorderColor: UIColor(red: 158.0/255, green: 158.0/255, blue: 160.0/255, alpha: 1.0), dotBorderWidth: 1)
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Sorry for inconvineince. Please wait for connect to server. Kindly kill the app and start again.", controller: self)
        }
        
    }
    
}


extension WalkInVC{
    
    func intialise()
    {
        self.view.insertSubview(pageControl, at: 2)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        self.previousBtnOutlet.isHidden = true
        pageControl.numberOfPages = self.dataArr.count

    }
    
}



extension WalkInVC : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if dataArr.count == 0{
            
             return 0
        }
        else{
            
            return dataArr.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        self.collectionView.register(UINib(nibName: "OnBaordingCollectionCell", bundle: nil), forCellWithReuseIdentifier: "OnBaordingCollectionCell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnBaordingCollectionCell", for: indexPath) as! OnBaordingCollectionCell
        
        let dict = dataArr.object(at: indexPath.row) as? NSDictionary ?? [:]

        if dict.count != 0{

            cell.headerNameLbl.text = dict.object(forKey: "title") as? String ?? ""
            
            if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
                
                cell.contentLbl.text = dict.object(forKey: "portDescription") as? String ?? ""
            }
            else{
                
                 cell.contentLbl.text = dict.object(forKey: "description") as? String ?? ""
            }
            
        }
        
        if indexPath.item == 0{
            
            cell.imgHeader.image = UIImage(named: "take2")
        }
        else if indexPath.item == 1{
            
            cell.imgHeader.image = UIImage(named: "take4")
        }
        else if indexPath.item == 2{
            
            cell.imgHeader.image = UIImage(named: "take3")
        }
        else{
            
            cell.imgHeader.image = UIImage(named: "take1")
        }
        
        pageControl.customPageControl(dotFillColor: UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00), dotBorderColor: UIColor(red: 158.0/255, green: 158.0/255, blue: 160.0/255, alpha: 1.0), dotBorderWidth: 1)
        
       return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func moveCollectionView(toFrame contentOffset: CGFloat) {
        let frame = CGRect(x: contentOffset, y: collectionView.contentOffset.y, width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        collectionView.scrollRectToVisible(frame, animated: true)
        
    }
    
}

extension WalkInVC:UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
     
        if  scrollView == self.collectionView {
            
            let pageWidth:CGFloat = scrollView.frame.width
            let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
            
            print(currentPage)
            
            if currentPage == 0.0{
                
                self.previousBtnOutlet.isHidden = true
            }
            else{
                
                self.previousBtnOutlet.isHidden = false
            }
//            else if currentPage == 1.0{
//
//                self.previousBtnOutlet.isHidden = false
//            }
//            else if currentPage == 2.0{
//
//                self.previousBtnOutlet.isHidden = false
//            }
 
             self.pageControl.currentPage = Int(currentPage)

             pageControl.customPageControl(dotFillColor: UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00), dotBorderColor: UIColor(red: 158.0/255, green: 158.0/255, blue: 160.0/255, alpha: 1.0), dotBorderWidth: 1)
            
        }
    }
}

extension UIPageControl {
    
    func customPageControl(dotFillColor:UIColor, dotBorderColor:UIColor, dotBorderWidth:CGFloat) {
        for (pageIndex, dotView) in self.subviews.enumerated() {
            if self.currentPage == pageIndex {
                dotView.backgroundColor = dotFillColor
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
            }else{
                dotView.backgroundColor = .clear
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
                dotView.layer.borderColor = dotBorderColor.cgColor
                dotView.layer.borderWidth = dotBorderWidth
            }
        }
    }
    
}

//MARK:- Webservices
//MARK:-
extension WalkInVC{
    
    func apiCallForGetStaticContent(){
        
        if CommonClass.sharedInstance.isConnectedToNetwork(){
            
            IJProgressView.shared.showProgressView(view: self.view)
            
            self.connection.startConnectionWithStringGetType(getUrlString: App.URLs.apiCallForGetStaticContent as NSString) { (receivedData) in
                
                IJProgressView.shared.hideProgressView()
                
                print(receivedData)
                
                let status = receivedData.object(forKey: "status") as? String ?? ""
                
                if status == "SUCCESS"{
                    
                    if let arr = receivedData.object(forKey: "response") as? NSArray{
                        
                        for i in 0..<arr.count{
                            
                            let dict = arr.object(at: i) as? NSDictionary ?? [:]
                            
                            let type = dict.object(forKey: "Type") as? String ?? ""
                            if type == "WalkingPage1" || type == "WalkingPage2" || type == "WalkingPage3" || type == "WalkingPage4" || type == "WalkingPage" || type == "WalkingPage\(i)" || type == "WalkingPage\(i + 1)"{
                                
                                 self.dataArr.add(dict)
                            }
                           
                        }
                        
                        self.intialise()
                        
                        let data = NSKeyedArchiver.archivedData(withRootObject: arr)
                        print("data........\(data)")
                        UserDefaults.standard.set(data, forKey: "WalkInArr")
                        
                        self.collectionView.reloadData()
                    }
                }
                else{
                    
                    
                }
                
            }
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please check your internet connection", controller: self)
        }
        
    }
}
