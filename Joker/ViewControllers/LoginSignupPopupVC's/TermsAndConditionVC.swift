//
//  TermsAndConditionVC.swift
//  Joker
//
//  Created by Apple on 22/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class TermsAndConditionVC: UIViewController {

    @IBOutlet weak var checkBoxBtn: UIButton!
    @IBOutlet weak var lbl_termsAndConditions: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var lblTermsAndPrivacy: UILabel!
    
    @IBOutlet weak var lblContent: UILabel!
    
    var termsCheck = true
    
    let termText = "I accept".localized()+" "+"Terms & Conditions".localized()+" and "+"Privacy Policy".localized()
    let term = "Terms & Conditions".localized()
    let policy = "Privacy Policy".localized()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTermsAndPrivacy.text = "Terms & Conditions and Privacy Policy".localized()
        nextBtn.setTitle("Next".localized(), for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        initailise()
    }
    
    @IBAction func tap_nextBtn(_ sender: Any) {
        
        if termsCheck == true{
            
//            let vc = ScreenManager.getAgreeDisagreeAlertVC()
//
//            vc.nabObj = self
//
//            self.present(vc, animated: true, completion: nil)
            
            let vc = ScreenManager.MainModuleNew_VC()
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navController
            appDelegate.window?.makeKeyAndVisible()
            
        }
        else{
            
            CommonClass.sharedInstance.callNativeAlert(title: "", message: "Please accept the terms and conditions of app.".localized(), controller: self)
        }
        
    }
    
    @IBAction func tap_checkBoxBtn(_ sender: UIButton) {
        
        if termsCheck == true{
            
            termsCheck = false
            
            checkBoxBtn.setImage(UIImage(named: "check_box_un"), for: .normal)
        }
        else{
            
            checkBoxBtn.setImage(UIImage(named: "check_box_s"), for: .normal)
            
            termsCheck = true
        }
        
    }
    
}

extension TermsAndConditionVC{
    
    
    func initailise()
    {
        nextBtn.backgroundColor = UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00)
        
//        let normalText1  = "I accept "
//        let underLineText1 = "Terms & Conditions"
//        let normalText2 = " and "
//        let underLineText2 = "Privacy Policy"
//        let myMutableString1 = NSMutableAttributedString()
//        let myMutableString2 = NSAttributedString(string: "\(normalText1) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 14.0)!, .foregroundColor :UIColor(red: 81/255, green: 82/255, blue: 87/255, alpha: 1.0)])
//        let myMutableString3 = NSAttributedString(string: "\(underLineText1) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 14.0)!, .foregroundColor :UIColor(red: 52/255, green: 54/255, blue: 64/255, alpha: 1.0), .underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
//
//        let myMutableString4 = NSAttributedString(string: "\(normalText2) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 14.0)!, .foregroundColor :UIColor(red: 81/255, green: 82/255, blue: 87/255, alpha: 1.0)] )
//        let myMutableString5 = NSAttributedString(string: "\(underLineText2) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :UIColor(red: 52/255, green: 54/255, blue: 64/255, alpha: 1.0),.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
//
//
//        myMutableString1.append(myMutableString2)
//        myMutableString1.append(myMutableString3)
//        myMutableString1.append(myMutableString4)
//        myMutableString1.append(myMutableString5)
//        self.lbl_termsAndConditions.attributedText = myMutableString1
        

        ///////////
      
        let formattedText = String.format(strings: [term, policy],
                                          boldFont: UIFont(name: App.Fonts.SegoeUI.Bold, size: 14)!,
                                          boldColor: UIColor(red: 0.03, green: 0.57, blue: 0.82, alpha: 1.00),
                                          inString: termText,
                                          font: UIFont(name: App.Fonts.SegoeUI.Regular, size: 14)!,
                                          color: UIColor.black)
        
        lbl_termsAndConditions.attributedText = formattedText
        lbl_termsAndConditions.numberOfLines = 0
        lbl_termsAndConditions.sizeToFit()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTermTapped))
        lbl_termsAndConditions.addGestureRecognizer(tap)
        lbl_termsAndConditions.isUserInteractionEnabled = true
        
        /////////////////
        
        let data = UserDefaults.standard.value(forKey: "WalkInArr") as! NSData
        let walkInDataArr = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! NSArray
        
        for i in 0..<walkInDataArr.count{
            
            let dict = walkInDataArr.object(at: i) as? NSDictionary ?? [:]
            let type = dict.object(forKey: "Type") as? String ?? ""
            
            if type == "TermCondition"{
                
                //lblContent.text = dict.object(forKey: "description") as? String ?? ""
                
                var txt = ""
                
                if UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" == "ar"{
                    
                     txt = dict.object(forKey: "portDescription") as? String ?? ""
                }
                else{
                    
                     txt = dict.object(forKey: "description") as? String ?? ""
                }
                
                self.lblContent.attributedText = txt.html2AttributedString!
                
                break
            }
        }
        
    }
}


extension NSAttributedString {
    
    convenience init(htmlString html: String) throws {
        try self.init(data: Data(html.utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil)
    }
    
}

extension String {
    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(
            data: data,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType:
                NSAttributedString.DocumentType.plain],
            documentAttributes: nil) else { return nil }
        return html
    }
}

extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        guard
            let data = self.data(using: .utf8)
            else { return nil }
        do {
            return try NSAttributedString(data: data, options: [
                NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
                ], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}



extension TermsAndConditionVC{
    
    
    func checkRange(_ range: NSRange, contain index: Int) -> Bool {
        
        return index > range.location && index < range.location + range.length
    }
    
    @objc func handleTermTapped(gesture: UITapGestureRecognizer) {
        
        let termString = termText as NSString
        let termRange = termString.range(of: term)
        let policyRange = termString.range(of: policy)
        
        let tapLocation = gesture.location(in: lbl_termsAndConditions)
        
        let index = lbl_termsAndConditions.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
        
        DispatchQueue.main.async {
            
            if self.checkRange(termRange, contain: index) == true {
                
                self.termTxtTapped()
                
                return
            }
            
            if self.checkRange(policyRange, contain: index) {
                
                self.privacyTxtTapped()
                
                return
            }
        }
        
    }
    
    
    func termTxtTapped(){
        
        let vc = ScreenManager.getTermsAndPrivacyWebpagesVC()
        vc.purpuse = "Terms"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func privacyTxtTapped(){
        
        let vc = ScreenManager.getTermsAndPrivacyWebpagesVC()
        vc.purpuse = "Privacy"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}



extension String {
    
    static func format(strings: [String],
                       boldFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                       boldColor: UIColor = UIColor.blue,
                       inString string: String,
                       font: UIFont = UIFont.systemFont(ofSize: 14),
                       color: UIColor = UIColor.black) -> NSAttributedString {
        let attributedString =
            NSMutableAttributedString(string: string,
                                      attributes: [
                                        NSAttributedString.Key.font: font,
                                        NSAttributedString.Key.foregroundColor: color])
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: boldColor]
        for bold in strings {
            attributedString.addAttributes(boldFontAttribute, range: (string as NSString).range(of: bold))
        }
        return attributedString
    }
}


extension UILabel {
    
    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        
        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
}
