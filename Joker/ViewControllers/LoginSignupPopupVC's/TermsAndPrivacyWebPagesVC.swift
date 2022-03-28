//
//  TermsAndPrivacyWebPagesVC.swift
//  Joker
//
//  Created by retina on 12/03/20.
//  Copyright © 2020 Callsoft. All rights reserved.
//

import UIKit
import WebKit

class TermsAndPrivacyWebPagesVC: UIViewController {

    
    @IBOutlet weak var lblNav: UILabel!
    
     @IBOutlet weak var webview: UIView!
    
    var purpuse = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urlStr = ""
        
        if purpuse == "Terms"{
            
            lblNav.text = "Terms and Conditions".localized()
            
            if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
                urlStr = "http://3.129.47.202/termsPt.html"
           
            }
            else{
                
                 urlStr = "http://3.129.47.202/terms.html"
                
            }
            
        }
        else{
            
            lblNav.text = "Privacy Policy".localized()
            
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
    
    
    @IBAction func tap_backBtn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
 
}


extension TermsAndPrivacyWebPagesVC:WKNavigationDelegate{
    
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
