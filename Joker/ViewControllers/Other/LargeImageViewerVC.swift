//
//  LargeImageViewerVC.swift
//  Joker
//
//  Created by Dacall soft on 05/06/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit

class LargeImageViewerVC: UIViewController {
    
    @IBOutlet weak var imgFullScreen: UIImageView!
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    var imageString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            
            let fullImgStr = "\(self.imageString)"
            
            let urlStr = URL(string: fullImgStr)
            
            if urlStr != nil{
                
                self.imgFullScreen.setImageWith(urlStr!)
            }
        }
        
        scrollview.delegate = self
        scrollview.minimumZoomScale = 1.0
        scrollview.maximumZoomScale = 10.0
        scrollview.alwaysBounceVertical = false
        scrollview.alwaysBounceHorizontal = false
        scrollview.showsVerticalScrollIndicator = true
        scrollview.flashScrollIndicators()
    }
    
    @IBAction func tap_closeBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension LargeImageViewerVC:UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.imgFullScreen
    }
    
}
