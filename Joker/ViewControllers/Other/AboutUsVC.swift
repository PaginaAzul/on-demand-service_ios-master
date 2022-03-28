//
//  AboutUsVC.swift
//  Joker
//
//  Created by Dacall soft on 22/03/19.
//  Copyright © 2019 Callsoft. All rights reserved.
//

import UIKit
import WebKit


class AboutUsVC: UIViewController {

    
    @IBOutlet weak var navLbl: UILabel!
    
    @IBOutlet weak var webview: UIView!
    
    
    var controllerPurpuse = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
        
    }
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AboutUsVC{
    
    func initialSetup(){
        
        var urlStr = ""
        
        if controllerPurpuse == "About"{
            
            navLbl.text = "About Us".localized()
            
            if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
                
                urlStr = "http://3.129.47.202/aboutPt.html"
            }
            else{
              
                urlStr = "http://3.129.47.202/about.html"
            }
            
        }
        else if controllerPurpuse == "TermsCondition"{
            
            navLbl.text = "Terms and Conditions".localized()
            
            if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
                
                
                urlStr = "http://3.129.47.202/termsPt.html"
            }
            else{
                
              
                urlStr = "http://3.129.47.202/terms.html"
            }
            
        }
        else{
            
            navLbl.text = "Privacy Policy".localized()
            
            if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
                
              
                urlStr = "http://3.129.47.202/privacyPt.html"
            }
            else{
                
              
                urlStr = "http://3.129.47.202/privacy.html"
            }
            
        }

        
        let url = URL(string: urlStr)
        let request = URLRequest(url: url!)
        let webView = WKWebView(frame: self.webview.frame)
        webView.navigationDelegate = self
    
        webView.load(request)
        self.webview.addSubview(webView)
        
    }

}


extension AboutUsVC:WKNavigationDelegate
{
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
         IJProgressView.shared.showProgressView(view: self.view)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        IJProgressView.shared.hideProgressView()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        IJProgressView.shared.hideProgressView()
    }

    
}
