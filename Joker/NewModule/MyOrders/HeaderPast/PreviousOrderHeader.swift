//
//  PreviousOrderHeader.swift
//  JustBite
//
//  Created by Aman on 17/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import UIKit



class PreviousOrderHeader: UIView {
    
    @IBOutlet weak var btnTap: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnRateOrder: UIButton!
    @IBOutlet weak var btnReorderRef: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var btnRate: UIButton!

    @IBOutlet weak var heightReorder: NSLayoutConstraint!
    
    var dateFormatterForTime = DateFormatter()
    var dateFormatterForDate = DateFormatter()
    
    var itemPast : DataGetOrder? {
        didSet {
            callForDateTime()
            dateTimeLbl.isHidden = false
            dateTimeLbl.text! = "Delivered".localized()
            dateTimeLbl.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 15.0)!
            dateTimeLbl.textColor = AppColor.themeColor
            
            lblTitle.attributedText = CommonClass.sharedInstance.attributedStringOfferNew(title: itemPast?.sellerData?.name ?? "", subTitle: "\("Order Id".localized()) : \(itemPast?.orderNumber ?? "")", subTitle2: self.fetchData(dateToConvert: itemPast?.createdAt ?? ""), delemit: "\n", sizeTitle: 16, sizeSubtitle2: 12, sizeSubtitle: 15, titleColor: AppColor.textColor, SubtitleColor: UIColor.black, SubtitleColor2: UIColor.darkGray)
            
            imgView.setImage(withImageId: itemPast?.sellerData?.image ?? "", placeholderImage: #imageLiteral(resourceName: "check_box_un"))
            
            btnRateOrder.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.Regular, size: 14.0)!
            btnRateOrder.setTitleColor(AppColor.subtitleColor, for: .normal)
            btnRateOrder.setTitle("  Rate Order".localized(), for: .normal)
            
            btnReorderRef.titleLabel?.font = UIFont(name: App.Fonts.SegoeUI.SemiBold, size: 15.0)!
            
            btnReorderRef.backgroundColor = AppColor.themeColor
            btnReorderRef.setTitleColor(AppColor.whiteColor, for: .normal)
            btnReorderRef.setTitle("  Reorder".localized(), for: .normal)
            
            
            CommonClass.sharedInstance.provideCustomBorder(btnRef: imgView)
            
            if itemPast?.isSelected == true{
                btnReorderRef.isHidden  = true
                heightReorder.constant = 0
                btnTap.setImage(#imageLiteral(resourceName: "up_arrow"), for: .normal)
            }else{
                heightReorder.constant = 50

                btnTap.setImage(#imageLiteral(resourceName: "down_arrow"), for: .normal)
                btnReorderRef.isHidden  = false
            }
            
            
        }
    }
    
    func callForDateTime(){
        dateFormatterForTime.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForTime.dateFormat = "hh:mm a"
        dateFormatterForDate.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterForDate.dateFormat = "dd-MMM-yyyy"
    }
    
    func fetchData(dateToConvert:String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let pendingDate = dateFormatter.date(from: dateToConvert)!
        let sendTime = self.dateFormatterForTime.string(from: pendingDate)
        let sendDate = self.dateFormatterForDate.string(from: pendingDate)
        
        print("sendTime-->" , sendTime ,sendDate , dateToConvert , pendingDate  )
        
        return "\(sendDate) \(sendTime)"
    }
    
    @IBAction func tapReorder(_ sender: UIButton) {
 
        
        
    }
    
    
    
}

extension PreviousOrderHeader {
    
    // Add Item
    func addCardItem(_ productId : String){
        
        let header = ["token": UserDefaults.standard.value(forKey: "UserAuthorizationToken") as? String ?? ""] as [String:String]
        
        let param = ["userId":UserDefaults.standard.value(forKey: "UserID") as? String ?? "",
                     "productId": productId,
                     "langCode": UserDefaults.standard.value(forKey: "LANGUAGE") as? String ?? "" ] as [String:Any]
        
        let apiHandle = ApiHandler()
        apiHandle.fetchApiService(method: .post, url: Domain.baseUrl().appending(APIEndpoint.addToCart), passDict: param, header: header) { (result) in

            switch result{

            case .success(let data):

                print(data)

                if data["response_message"].stringValue == "Item added to cart successfully"{
                }else{
                    CommonClass.sharedInstance.callNativeAlert(title: "", message: data["response_message"].stringValue, controller: commonController)
                }
                break
            case .failure(let error):
                CommonClass.sharedInstance.callNativeAlert(title: "", message: error.localizedDescription, controller: commonController)
                break
            }
        }
    }
    
    
    
}
